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

import com.camara.qod.api.SessionsApiDelegate;
import com.camara.qod.api.model.CreateSession;
import com.camara.qod.api.model.SessionInfo;
import com.camara.qod.service.QodService;
import inet.ipaddr.IPAddress;
import inet.ipaddr.IPAddressString;
import java.net.URI;
import java.util.Arrays;
import java.util.Optional;
import java.util.UUID;
import java.util.regex.Pattern;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;


/** Contains implementations for the methods of the sessions' path. */
@Controller
public class SessionsApiDelegateImpl implements SessionsApiDelegate {
  private static final int maxSessionDuration = 86400; // 24 hours
  private static final String PORTS_REGEX =
      "^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[0-9]{1,4})$|^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[0-9]{1,4})-(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[0-9]{1,4})$";

  private final QodService qodService;

  @Autowired
  public SessionsApiDelegateImpl(QodService qodService) {
    this.qodService = qodService;
  }

  @Override
  public ResponseEntity<SessionInfo> createSession(CreateSession createSession) {
    createSession.setDuration(
        Optional.ofNullable(createSession.getDuration()).orElse(maxSessionDuration));
    createSession.setAsPorts(prettifyPorts(createSession.getAsPorts()));
    createSession.setUePorts(prettifyPorts(createSession.getUePorts()));
    validateNetwork(createSession.getAsAddr());
    validateNetwork(createSession.getUeAddr());
    validatePorts(createSession.getAsPorts());
    validatePorts(createSession.getUePorts());

    SessionInfo sessionInfo = qodService.createSession(createSession);

    URI location = ServletUriComponentsBuilder.fromCurrentRequest()
            .path("/{id}")
            .buildAndExpand(sessionInfo.getId())
            .toUri();
    return ResponseEntity.created(location).body(sessionInfo);
  }

  @Override
  public ResponseEntity<SessionInfo> getSession(UUID sessionId) {
    SessionInfo sessionInfo = qodService.getSession(sessionId);
    return ResponseEntity.status(HttpStatus.OK).body(sessionInfo);
  }

  @Override
  public ResponseEntity<Void> deleteSession(UUID sessionId) {
    qodService.deleteSession(sessionId);
    return ResponseEntity.noContent().build();
  }

  private void validateNetwork(String network) {
    IPAddress current = new IPAddressString(network).getAddress();
    IPAddress rewritten = current.toPrefixBlock();
    if (current != rewritten) {
      throw new SessionApiException(
          HttpStatus.BAD_REQUEST, "Network specification not valid " + network);
    }
  }

  private void validatePorts(String ports) {
    Pattern portsPattern = Pattern.compile(PORTS_REGEX);
    if (ports != null && !Arrays.stream(ports.split(",")).allMatch(portsPattern.asPredicate())) {
      throw new SessionApiException(
          HttpStatus.BAD_REQUEST, "Ports specification not valid " + ports);
    }
  }

  private String prettifyPorts(String ports) {
    if (ports != null && !ports.isEmpty()) {
      return ports.replaceAll("^,*", "").replaceAll(",*$", "").replaceAll("\\s+", "");
    }
    return null;
  }
}
