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

package com.camara.qod.config;

import lombok.Getter;
import lombok.ToString;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/** SCEF QoS API configuration, see http://www.3gpp.org/ftp/Specs/archive/29_series/29.122/ */
@Configuration
@Getter
@ToString
public class ScefConfig {
  @Value("${scef.server.apiroot}")
  private String apiRoot;

  @Value("${scef.server.flowid.low-latency}")
  private int flowIdLowLatency;

  @Value("${scef.server.flowid.throughput-s}")
  private int flowIdThroughputS;

  @Value("${scef.server.flowid.throughput-m}")
  private int flowIdThroughputM;

  @Value("${scef.server.flowid.throughput-l}")
  private int flowIdThroughputL;

  @Value("${scef.server.scsasid}")
  private String scsAsId;

  @Value("${scef.notifications.url}")
  private String scefNotificationsDestination;

  @Value("${scef.auth.type}")
  private String authMethod;

  @Value("${scef.auth.username}")
  private String userName;

  @Value("${scef.auth.password}")
  private String password;

  @Value("${scef.auth.oauth.token}")
  private String token;

  @Value("${scef.debug}")
  private Boolean scefDebug;

  @Value("${scef.server.supportedFeatures}")
  private String supportedFeatures;
}
