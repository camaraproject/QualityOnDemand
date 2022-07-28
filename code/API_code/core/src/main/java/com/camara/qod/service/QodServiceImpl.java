/*-
 * ---license-start
 * CAMARA Project
 * ---
 * Copyright (C) 2022 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC
 * The contributor of this file confirms his sign-off for the
 * Developer Certificate of Origin (http://developercertificate.org).
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */

package com.camara.qod.service;

import com.camara.qod.api.model.*;
import com.camara.qod.api.notifications.SessionNotificationsCallbackApi;
import com.camara.qod.commons.Util;
import com.camara.qod.config.QodConfig;
import com.camara.qod.config.RedisConfig;
import com.camara.qod.config.ScefConfig;
import com.camara.qod.controller.SessionApiException;
import com.camara.qod.mapping.ModelMapper;
import com.camara.qod.model.QosSession;
import com.camara.qod.repository.QodSessionRepository;
import com.camara.scef.api.ApiClient;
import com.camara.scef.api.AsSessionWithQoSApiSubscriptionLevelDeleteOperationApi;
import com.camara.scef.api.AsSessionWithQoSApiSubscriptionLevelPostOperationApi;
import com.camara.scef.api.model.AsSessionWithQoSSubscription;
import com.camara.scef.api.model.FlowInfo;
import com.camara.scef.api.model.UserPlaneEvent;
import com.camara.scef.api.model.UserPlaneNotificationData;
import inet.ipaddr.IPAddressString;
import java.time.Instant;
import java.util.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/** Service, that supports the implementations of the methods of the sessions' path. */
@Service
public class QodServiceImpl implements QodService {
  private static final Logger log = LoggerFactory.getLogger(QodServiceImpl.class);

  private static final String BASE_URL_TEMPLATE = "%s/3gpp-as-session-with-qos/v1";
  private static final int FLOW_ID_UNKNOWN = -1;
  private static final String FLOW_DESCRIPTION_TEMPLATE_IN = "permit in %s from %s to %s";
  private static final String FLOW_DESCRIPTION_TEMPLATE_OUT = "permit out %s from %s to %s";
  private static final String[] PRIVATE_NETWORKS = {
    "10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"
  };

  /** SCEF QoS API, see http://www.3gpp.org/ftp/Specs/archive/29_series/29.122/ */
  private final ScefConfig scefConfig;

  private final QodConfig qodConfig;
  private final RedisConfig redisConfig;

  private final QodSessionRepository sessionRepo;
  private final ModelMapper modelMapper;
  private final RedisTemplate<String, String> redisTemplate;

  private final AsSessionWithQoSApiSubscriptionLevelPostOperationApi postApi;
  private final AsSessionWithQoSApiSubscriptionLevelDeleteOperationApi deleteApi;

  @Autowired
  public QodServiceImpl(
      QodSessionRepository sessionRepo,
      ModelMapper modelMapper,
      RedisTemplate<String, String> redisTemplate,
      ScefConfig scefConfig,
      QodConfig qodConfig,
      RedisConfig redisConfig) {
    this.sessionRepo = sessionRepo;
    this.modelMapper = modelMapper;
    this.redisTemplate = redisTemplate;
    this.scefConfig = scefConfig;
    this.qodConfig = qodConfig;
    this.redisConfig = redisConfig;

    ApiClient apiClient =
        new ApiClient().setBasePath(String.format(BASE_URL_TEMPLATE, scefConfig.getApiRoot()));
    if (scefConfig.getAuthMethod().equals("basic")) {
      apiClient.setUsername(scefConfig.getUserName());
      apiClient.setPassword(scefConfig.getPassword());
    } else {
      apiClient.setAccessToken(scefConfig.getToken());
    }
    apiClient.setDebugging(scefConfig.getScefDebug());
    this.postApi = new AsSessionWithQoSApiSubscriptionLevelPostOperationApi(apiClient);
    this.deleteApi = new AsSessionWithQoSApiSubscriptionLevelDeleteOperationApi(apiClient);
  }

  @Override
  public SessionInfo createSession(@NotNull CreateSession session) {
    QosProfile qosProfile = session.getQos();
    final int flowId = getFlowId(qosProfile);

    // if multiple ueAddr are not allowed and specified ueAddr is a network segment, return error
    if (!qodConfig.getQosAllowMultipleUeAddr()
        && session.getUeAddr().matches(qodConfig.getNetworkSegmentRegEx())) {
      throw new SessionApiException(
          HttpStatus.BAD_REQUEST,
          "A network segment for ueAddr is not allowed in the current configuration: "
              + session.getUeAddr()
              + " is not allowed, but "
              + session.getUeAddr().substring(0, session.getUeAddr().indexOf("/"))
              + " is allowed.");
    }

    // Check if already exists
    Optional<QosSession> actual =
        checkExistingSessions(
            session.getUeAddr(),
            session.getAsAddr(),
            session.getUePorts(),
            session.getAsPorts(),
            session.getProtocolIn(),
            session.getProtocolOut());
    if (actual.isPresent()) {
      QosSession s = actual.get();
      Instant expirationTime = Instant.ofEpochSecond(s.getExpiresAt());
      String sessionId =
          qodConfig.getQosMaskSensibleData()
              ? maskString(s.getId().toString())
              : s.getId().toString();
      throw new SessionApiException(
          HttpStatus.CONFLICT,
          "Found session " + sessionId + " already active until " + expirationTime);
    }

    // Check if asAddr is could be in private network
    // TODO: create warning in response
    for (String privateNetwork : PRIVATE_NETWORKS) {
      IPAddressString pn = new IPAddressString(privateNetwork);
      if (pn.contains(new IPAddressString(session.getAsAddr()))) {
        // TODO: Put this message into response
        log.warn("Creating a session for AS in private network " + privateNetwork);
        break;
      }
    }

    String qosReference = getReference(qosProfile);
    String protocolIn = getProtocol(session.getProtocolIn());
    String protocolOut = getProtocol(session.getProtocolOut());

    String asAddr = session.getAsAddr();
    String ueAddr = session.getUeAddr();

    if (session.getAsPorts() != null) {
      // Validate port ranges generally beside the check in checkExistingSessions
      checkPortRange(session.getAsPorts());
      // AS port present. Append it to IP
      asAddr += " " + session.getAsPorts();
    }
    if (session.getUePorts() != null) {
      // Validate port ranges generally beside the check in checkExistingSessions
      checkPortRange(session.getUePorts());
      // UE port present. Append it to IP
      ueAddr += " " + session.getUePorts();
    }

    // UUID for session
    UUID uuid = UUID.randomUUID();

    // Time
    long now = Instant.now().getEpochSecond();
    int duration = session.getDuration();
    long expiresAt = now + duration;

    FlowInfo flowInfo = createFlowInfo(ueAddr, asAddr, protocolIn, protocolOut, flowId);
    AsSessionWithQoSSubscription qosSubscription =
        createQosSubscription(
            session.getUeAddr(), flowInfo, qosReference, scefConfig.getSupportedFeatures());
    AsSessionWithQoSSubscription response =
        postApi.scsAsIdSubscriptionsPost(scefConfig.getScsAsId(), qosSubscription);
    String subscriptionId = Util.subscriptionId(response.getSelf());
    if (subscriptionId == null) {
      throw new SessionApiException(
          HttpStatus.INTERNAL_SERVER_ERROR,
          "No valid subscription ID was provided in NEF/SCEF response");
    }

    QosSession qosSession =
        saveSession(
            now, expiresAt, duration, uuid, session, qosProfile, subscriptionId);

    return modelMapper.map(qosSession);
  }

  @Override
  public SessionInfo getSession(@NotNull UUID sessionId) {
    return sessionRepo
        .findById(sessionId)
        .map(modelMapper::map)
        .orElseThrow(
            () ->
                new SessionApiException(
                    HttpStatus.NOT_FOUND, "QoD session not found for session ID: " + sessionId));
  }

  @Override
  public SessionInfo deleteSession(@NotNull UUID sessionId) {
    QosSession qosSession =
        sessionRepo
            .findById(sessionId)
            .orElseThrow(
                () ->
                    new SessionApiException(
                        HttpStatus.NOT_FOUND,
                        "QoD session not found for session ID: " + sessionId));

    sessionRepo.deleteById(sessionId);
    redisTemplate
            .opsForZSet()
            .remove(redisConfig.getQosSessionExpirationListName(), sessionId.toString());

    if (qosSession.getSubscriptionId() != null) {
      ResponseEntity<UserPlaneNotificationData> response =
          deleteApi.scsAsIdSubscriptionsSubscriptionIdDeleteWithHttpInfo(
              scefConfig.getScsAsId(), qosSession.getSubscriptionId());
      if (!response.getStatusCode().is2xxSuccessful()) {
        // TODO properly process NEF/SCEF error codes
        throw new SessionApiException(
            HttpStatus.INTERNAL_SERVER_ERROR,
            "NEF/SCEF returned error "
                + response.getStatusCodeValue()
                + " while deleting NEF/SCEF session with subscription ID: "
                + qosSession.getSubscriptionId());
      }
    }
    return modelMapper.map(qosSession);
  }

  @Override
  @Async
  public void handleQosNotification(
      @NotBlank String subscriptionId, @NotNull UserPlaneEvent event) {
    Optional<QosSession> sessionOptional = sessionRepo.findBySubscriptionId(subscriptionId);
    // TODO implement proper event model. For now only SESSION_TERMINATED event is supported
    if (sessionOptional.isPresent() && event.equals(UserPlaneEvent.SESSION_TERMINATION)) {
      QosSession session = sessionOptional.get();
      SessionInfo sessionInfo = deleteSession(session.getId());
      notifySession(sessionInfo, SessionEvent.SESSION_TERMINATED);

      if (session.getNotificationUri() != null && session.getNotificationAuthToken() != null) {
        com.camara.qod.api.notifications.ApiClient apiClient =
            new com.camara.qod.api.notifications.ApiClient()
                .setBasePath(session.getNotificationUri().toString());
        apiClient.setApiKey(session.getNotificationAuthToken());
        SessionNotificationsCallbackApi callback = new SessionNotificationsCallbackApi(apiClient);
        callback.postNotification(
            new Notification().sessionId(session.getId()).event(SessionEvent.SESSION_TERMINATED));
      }
    }
  }

  @Override
  @Async("taskScheduler") // @EnableScheduling and @EnableAsync both define a task executor, thus we
  // need to specify which one to use
  public void notifySession(@NotNull SessionInfo qosSession, @NotNull SessionEvent event) {
    if (qosSession.getNotificationUri() != null && qosSession.getNotificationAuthToken() != null) {
      com.camara.qod.api.notifications.ApiClient apiClient =
          new com.camara.qod.api.notifications.ApiClient()
              .setBasePath(qosSession.getNotificationUri().toString());
      apiClient.setApiKey(qosSession.getNotificationAuthToken());
      SessionNotificationsCallbackApi callback = new SessionNotificationsCallbackApi(apiClient);
      callback.postNotification(new Notification().sessionId(qosSession.getId()).event(event));
    }
  }

  /**
   * Save QoS session.
   *
   * @param startedAt - timestamp of session begin
   * @param expiresAt - timestamp of automatic session termination
   * @param duration - session duration in seconds
   * @param session - information to new session
   * @param qualityProfile - quality requested for session
   * @param subscriptionId - network QoS subscription ID
   * @return created QoS session
   */
  private QosSession saveSession(
      long startedAt,
      long expiresAt,
      int duration,
      UUID uuid,
      CreateSession session,
      QosProfile qualityProfile,
      String subscriptionId) {
    QosSession qosSession =
        QosSession.builder()
            .id(uuid)
            .startedAt(startedAt)
            .expiresAt(expiresAt)
            .duration(duration)
            .ueAddr(session.getUeAddr())
            .asAddr(session.getAsAddr())
            .uePorts(session.getUePorts())
            .asPorts(session.getAsPorts())
            .protocolIn(session.getProtocolIn())
            .protocolOut(session.getProtocolOut())
            .qos(qualityProfile)
            .subscriptionId(subscriptionId)
            .notificationUri(session.getNotificationUri())
            .notificationAuthToken(session.getNotificationAuthToken())
            .expirationLockUntil(0) // Expiration Lock is initialised with 0, gets updated when an
            // ExpiredSessionTask is created
            .build();
    log.info("Save QoS session " + qosSession);
    sessionRepo.save(qosSession);
    // add an entry to a sorted set which contains the session id and the expiration time
    redisTemplate
        .opsForZSet()
        .add(
            redisConfig.getQosSessionExpirationListName(),
            qosSession.getId().toString(),
            expiresAt);
    return qosSession;
  }

  private int getFlowId(@NotNull QosProfile profile) {
    int flowId;
    switch (profile) {
      case LOW_LATENCY:
        flowId = scefConfig.getFlowIdLowLatency();
        break;
      case THROUGHPUT_S:
        flowId = scefConfig.getFlowIdThroughputS();
        break;
      case THROUGHPUT_M:
        flowId = scefConfig.getFlowIdThroughputM();
        break;
      case THROUGHPUT_L:
        flowId = scefConfig.getFlowIdThroughputL();
        break;
      default:
        flowId = FLOW_ID_UNKNOWN;
    }
    if (flowId == FLOW_ID_UNKNOWN) {
      throw new SessionApiException(HttpStatus.BAD_REQUEST, "QoS profile unknown or disabled");
    }
    return flowId;
  }

  private Optional<QosSession> checkExistingSessions(
      String ueAddr,
      String asAddr,
      String uePorts,
      String asPorts,
      Protocol inProtocol,
      Protocol outProtocol) {
    List<QosSession> qosSessions = sessionRepo.findByUeAddr(ueAddr);

    return qosSessions.stream()
        .filter(qosSession -> checkNetworkIntersection(asAddr, qosSession.getAsAddr()))
        .filter(
            qosSession ->
                checkPortIntersection(
                    uePorts == null ? "0-65535" : uePorts,
                    qosSession.getUePorts() == null ? "0-65535" : qosSession.getUePorts()))
        .filter(
            qosSession ->
                checkPortIntersection(
                    asPorts == null ? "0-65535" : asPorts,
                    qosSession.getAsPorts() == null ? "0-65535" : qosSession.getAsPorts()))
        .filter(qosSession -> checkProtocolIntersection(inProtocol, qosSession.getProtocolIn()))
        .filter(
            qosSession -> checkProtocolIntersection(outProtocol, qosSession.getProtocolOut()))
        .findFirst();
  }

  private String getReference(QosProfile profile) {
    switch (profile) {
      case LOW_LATENCY:
        return qodConfig.getQosReferenceLowLatency();
      case THROUGHPUT_S:
        return qodConfig.getQosReferenceThroughputS();
      case THROUGHPUT_M:
        return qodConfig.getQosReferenceThroughputM();
      case THROUGHPUT_L:
        return qodConfig.getQosReferenceThroughputL();
      default:
        throw new SessionApiException(HttpStatus.BAD_REQUEST, "QoS profile not valid");
    }
  }

  private String getProtocol(Protocol protocol) {
    switch (protocol) {
      case ANY:
        return "ip";
      case TCP:
        return "6";
      case UDP:
        return "17";
      default:
        throw new SessionApiException(HttpStatus.BAD_REQUEST, "Protocol not valid");
    }
  }

  private FlowInfo createFlowInfo(
      String ueAddr, String asAddr, String protocolIn, String protocolOut, Integer flowId) {
    return new FlowInfo()
        .flowId(flowId)
        .addFlowDescriptionsItem(
            String.format(FLOW_DESCRIPTION_TEMPLATE_IN, protocolIn, ueAddr, asAddr))
        .addFlowDescriptionsItem(
            String.format(FLOW_DESCRIPTION_TEMPLATE_OUT, protocolOut, asAddr, ueAddr));
  }

  private AsSessionWithQoSSubscription createQosSubscription(
      String ueAddr, FlowInfo flowInfo, String qosReference, String supportedFeatures) {
    return new AsSessionWithQoSSubscription()
        .ueIpv4Addr(ueAddr)
        .flowInfo(List.of(flowInfo))
        .qosReference(qosReference)
        .notificationDestination(scefConfig.getScefNotificationsDestination())
        .requestTestNotification(true)
        .supportedFeatures(supportedFeatures);
  }

  private String maskString(String unmaskedString) {
    return maskString(unmaskedString, 4);
  }

  private String maskString(String unmaskedString, int numberOfUnmaskedChars) {
    int indexOfMaskDelimiter = unmaskedString.length() - numberOfUnmaskedChars;
    return unmaskedString.substring(0, indexOfMaskDelimiter).replaceAll("[^-]", "X")
        + unmaskedString.substring(indexOfMaskDelimiter);
  }

  /**
   * Check if the given networks intersect.
   *
   * @param network1 single IP address or network
   * @param network2 single IP address or network
   * @return true for intersecting networks, false otherwise
   */
  private static boolean checkNetworkIntersection(String network1, String network2) {
    IPAddressString one = new IPAddressString(network1);
    IPAddressString two = new IPAddressString(network2);
    return one.contains(two) || two.contains(one);
  }

  /**
   * Check if the ports in range ordered from lower to higher.
   *
   * @param ports Ports to validate
   */
  private static void checkPortRange(String ports) {
    String[] portsArr = ports.split(",");
    for (String port : portsArr) {
      int[] portRange = parsePortsToPortRange(port);
      if (portRange[0] > portRange[1]) {
        throw new SessionApiException(HttpStatus.BAD_REQUEST, "Ports range not valid " + port);
      }
    }
  }

  /**
   * Check if the ports of a new requested session are already defined in an active Session.
   *
   * @param newSessionPorts Ports of the new requested Session
   * @param existingPorts Ports of active sessions
   * @return true for ports already in use, false for ports not in use
   */
  private static boolean checkPortIntersection(String newSessionPorts, String existingPorts) {
    String[] newSession = newSessionPorts.split(",");
    String[] existing = existingPorts.split(",");
    for (String newSessionPort : newSession) {
      int[] newPortRange = parsePortsToPortRange(newSessionPort);
      if (newPortRange[0] > newPortRange[1]) {
        throw new SessionApiException(
            HttpStatus.BAD_REQUEST, "Ports range not valid " + newSessionPort);
      }
      for (String existingPort : existing) {
        int[] existingPortRange = parsePortsToPortRange(existingPort);
        if (newPortRange[0] <= existingPortRange[1] && existingPortRange[0] <= newPortRange[1]) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Parse the ports string to integer ranges.
   *
   * @param ports (e.g. "5000-5600"; "1234")
   * @return integer port range (e.g. [5000, 5600]; [1234, 1234])
   */
  private static int[] parsePortsToPortRange(String ports) {
    if (!ports.contains("-")) {
      ports = ports + "-" + ports; // convert single port to port range
    }
    return Arrays.stream(ports.split("-")).mapToInt(Integer::parseInt).toArray();
  }

  /**
   * Check if the given protocols intersect.
   *
   * @param protocol1 protocol name (e.g. UDP/TCP) or null (ANY)
   * @param protocol2 protocol name (e.g. UDP/TCP) or null (ANY)
   * @return true for intersecting protocols, false otherwise
   */
  private static boolean checkProtocolIntersection(Protocol protocol1, Protocol protocol2) {
    if (protocol1 == null && protocol2 == null) {
      return true;
    } else if (protocol1 == null || protocol2 == null) {
      return true;
    } else {
      return protocol1.equals(protocol2);
    }
  }

}
