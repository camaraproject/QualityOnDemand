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

package com.camara.qod.model;

import com.camara.qod.api.model.Protocol;
import com.camara.qod.api.model.QosProfile;
import java.net.URI;
import java.util.UUID;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.index.Indexed;

/**
 * This is the QoS Session subscription resource.
 */
@Data
@Builder
@RedisHash("QoSSession")
public class QosSession {
  private UUID id;
  private String subscriptionId;
  private long startedAt;
  private long expiresAt;
  private int duration;
  @Indexed private String ueAddr;
  @Indexed private String asAddr;
  @Indexed private String uePorts;
  @Indexed private String asPorts;
  private QosProfile qos;
  private Protocol protocolIn;
  private Protocol protocolOut;
  private URI notificationUri;
  private String notificationAuthToken;
  private long
      expirationLockUntil; // The lock ensures, that the task is only scheduled once for expiration.
}
