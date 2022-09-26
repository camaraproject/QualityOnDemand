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

package com.camara.qod.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.tomakehurst.wiremock.junit5.WireMockTest;
import com.camara.scef.api.model.AsSessionWithQoSSubscription;
import com.camara.scef.api.model.UserPlaneNotificationData;
import com.camara.qod.api.SessionsApiDelegate;
import com.camara.qod.api.model.CreateSession;
import com.camara.qod.api.model.Protocol;
import com.camara.qod.api.model.QosProfile;
import com.camara.qod.api.model.SessionInfo;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@ActiveProfiles("test")
@WireMockTest(httpPort = 9000)
class SessionsApiDelegateImplTest {
  private final String asId;

  private final SessionsApiDelegate api;
  private final Boolean maskSensibleData;
  private final Integer defaultDuration;

  @Autowired
  public SessionsApiDelegateImplTest(
      @Value("${scef.server.scsasid}") String asId,
      SessionsApiDelegate api,
      @Value("${qod.mask-sensible-data}") Boolean maskSensibleData) {
    this.asId = asId;
    this.api = api;
    this.maskSensibleData = maskSensibleData;
    this.defaultDuration = 2;

    MockHttpServletRequest request = new MockHttpServletRequest();
    RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
  }

  @Test
  void getUnknownSession() {
    SessionApiException exception =
        assertThrows(SessionApiException.class, () -> api.getSession(UUID.randomUUID()));
    assertTrue(exception.getMessage().contains("not found"));
  }

  @Test
  void createAndDeleteSession() throws JsonProcessingException {
    stubForCreateSubscription();
    stubForDeleteSubscription();

    UUID sessionId = createSession(session(QosProfile.LOW_LATENCY));
    deleteSession(sessionId);
  }

  @Test
  void createSessionAlreadyActiveNotPermitted() throws JsonProcessingException {
    stubForCreateSubscription();
    stubForDeleteSubscription();

    UUID sessionId = createSession(session(QosProfile.LOW_LATENCY));
    SessionApiException exception =
        assertThrows(
            SessionApiException.class, () -> api.createSession(session(QosProfile.LOW_LATENCY)));
    assertTrue(exception.getMessage().contains("already active"));
    if (this.maskSensibleData) {
      assertTrue(exception.getMessage().contains("XXXXXXXX-XXXX-XXXX-XXXX-"));
    }
    deleteSession(sessionId);
  }

  /**
   * New sessions should be validated against rules in order to prevent creating session which QoS
   * profile couldn't be guaranteed.
   */
  @Test
  void createOnlyValidSessions() throws JsonProcessingException {
    stubForCreateSubscription();
    stubForDeleteSubscription();

    UUID sessionId =
        createSession(
            session(QosProfile.LOW_LATENCY, "200.24.24.0/24", "5000-5002,6000", defaultDuration));

    // not permitted because of included address, ports and protocols
    SessionApiException exception =
        assertThrows(
            SessionApiException.class,
            () -> api.createSession(session(QosProfile.LOW_LATENCY, "200.24.24.0/26")));
    assertTrue(exception.getMessage().contains("already active"));

    // permitted because of different ports
    UUID sessionIdTwo =
        createSession(session(QosProfile.LOW_LATENCY, "200.24.24.0/24", "6001", defaultDuration));

    deleteSession(sessionId);
    deleteSession(sessionIdTwo);
  }

  /**
   * Networks need to be defined with the start address (e.g. 200.24.24.0/24 and not 200.24.24.2/24)
   */
  @Test
  void createSessionDirtyNetworkDefinitionNotPermitted() {
    SessionApiException exception =
        assertThrows(
            SessionApiException.class,
            () -> api.createSession(session(QosProfile.LOW_LATENCY, "200.24.24.2/24")));
    assertTrue(exception.getMessage().contains("Network specification not valid"));
  }

  /** Profile THROUGHPUT_L is not permitted, see test configuration (application-test.yml) */
  @Test
  void createSessionQosProfileNotPermitted() {
    SessionApiException exception =
        assertThrows(
            SessionApiException.class, () -> api.createSession(session(QosProfile.THROUGHPUT_L)));
    assertTrue(exception.getMessage().contains("profile unknown"));
  }

  @Test
  void createSessionPortsNotValid() {

    CreateSession createSession =
        new CreateSession()
            .ueAddr("172.24.11.4")
            .asAddr("200.24.24.2")
            .duration(defaultDuration)
            .protocolIn(Protocol.ANY)
            .protocolOut(Protocol.ANY)
            .qos(QosProfile.LOW_LATENCY)
            .notificationUri(URI.create("http://example.com"))
            .notificationAuthToken("12345")
            .asPorts("1000, 100A");

    SessionApiException exception =
        assertThrows(SessionApiException.class, () -> api.createSession(createSession));
    assertTrue(exception.getMessage().contains("not valid"));
  }

  @Test
  void createSessionPortsRangeNotValid() {

    CreateSession createSession =
        new CreateSession()
            .ueAddr("172.24.11.4")
            .asAddr("200.24.24.3")
            .duration(defaultDuration)
            .protocolIn(Protocol.ANY)
            .protocolOut(Protocol.ANY)
            .qos(QosProfile.LOW_LATENCY)
            .notificationUri(URI.create("http://example.com"))
            .notificationAuthToken("12345")
            .asPorts("9000-8000, 1000");

    SessionApiException exception =
        assertThrows(SessionApiException.class, () -> api.createSession(createSession));
    assertTrue(exception.getMessage().contains("range not valid"));
  }

  @Test
  void deleteUnknownSession() {
    SessionApiException exception =
        assertThrows(SessionApiException.class, () -> api.deleteSession(UUID.randomUUID()));
    assertTrue(exception.getMessage().contains("not found"));
  }

  @Test
  void expireSession() throws JsonProcessingException, InterruptedException {
    stubForCreateSubscription();
    stubForDeleteSubscription();

    UUID sessionId = createSession(session(QosProfile.LOW_LATENCY));
    sessionFound(sessionId);
    Thread.sleep(defaultDuration * 1000 + 1);
    sessionNotFound(sessionId);
  }

  private UUID createSession(CreateSession createSession) {
    ResponseEntity<SessionInfo> response = api.createSession(createSession);
    assertNotNull(response);
    assertEquals(HttpStatus.CREATED, response.getStatusCode());
    assertNotNull(response.getBody());
    return response.getBody().getId();
  }

  private void sessionFound(UUID sessionId) {
    ResponseEntity<SessionInfo> response = api.getSession(sessionId);
    assertNotNull(response);
    assertEquals(HttpStatus.OK, response.getStatusCode());
    assertNotNull(response.getBody());
  }

  private void deleteSession(UUID sessionId) {
    ResponseEntity<Void> response = api.deleteSession(sessionId);
    assertNotNull(response);
    assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());
  }

  private void sessionNotFound(UUID sessionId) {
    SessionApiException exception =
        assertThrows(SessionApiException.class, () -> api.getSession(sessionId));
    assertTrue(exception.getMessage().contains("not found"));
  }

  private void stubForCreateSubscription() throws JsonProcessingException {
    stubFor(
        post("/3gpp-as-session-with-qos/v1/" + asId + "/subscriptions")
            .willReturn(
                created()
                    .withHeader("Content-Type", "application/json")
                    .withBody(subscriptionJsonString())));
  }

  private void stubForDeleteSubscription() throws JsonProcessingException {
    stubFor(
        delete(
                urlPathMatching(
                    "/3gpp-as-session-with-qos/v1/" + asId + "/subscriptions/([a-zA-Z0-9/-]*)"))
            .willReturn(
                ok().withHeader("Content-Type", "application/json")
                    .withBody(notificationDataJsonString())));
  }

  private String subscriptionJsonString() throws JsonProcessingException {
    ObjectMapper objectMapper = new ObjectMapper();

    AsSessionWithQoSSubscription subscription =
        new AsSessionWithQoSSubscription()
            .self("http://foo.com/subscriptions/" + UUID.randomUUID());
    return objectMapper.writeValueAsString(subscription);
  }

  private String notificationDataJsonString() throws JsonProcessingException {
    ObjectMapper objectMapper = new ObjectMapper();

    UserPlaneNotificationData notificationData = new UserPlaneNotificationData();
    return objectMapper.writeValueAsString(notificationData);
  }

  private CreateSession session(QosProfile qosProfile) {
    return session(qosProfile, "200.24.24.2");
  }

  private CreateSession session(QosProfile qosProfile, String asAddr) {
    return session(qosProfile, asAddr, null, defaultDuration);
  }

  private CreateSession session(
      QosProfile qosProfile, String asAddr, String uePorts, Integer duration) {
    return new CreateSession()
        .ueAddr("172.24.11.4")
        .asAddr(asAddr)
        .duration(duration)
        .uePorts(uePorts)
        .protocolIn(Protocol.ANY)
        .protocolOut(Protocol.ANY)
        .qos(qosProfile)
        .notificationUri(URI.create("http://example.com"))
        .notificationAuthToken("12345");
  }
}
