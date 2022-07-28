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

package com.camara.qod.commons;

/**
 * This class contains utility functions.
 */
public final class Util {
  private Util() {}

  /**
   * Returns the subscription id of a given subscription URI.
   *
   * @param subscriptionUri URI of the subscription
   * @return subscriptionId
   */
  public static String subscriptionId(String subscriptionUri) {
    if (subscriptionUri == null) {
      return null;
    }
    String[] split = subscriptionUri.split("subscriptions/");
    if (split.length == 0) {
      return null;
    }
    return split[split.length - 1];
  }
}
