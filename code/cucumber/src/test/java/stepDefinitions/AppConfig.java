/*-
 * ---license-start
 * CAMARA Project
 * ---
 * Copyright (C) 2022 - 2023 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC
 *
 * The contributor of this file confirms his sign-off for the
 * Developer Certificate of Origin
 *             (https://developercertificate.org).
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

package stepDefinitions;

public class AppConfig {

  public static final String BASE_URL = "http://localhost:9091";
  public static final int SCEF_PORT = Integer.parseInt("8081");
  public static final String SCEF_PATH = "/3gpp-as-session-with-qos/v1/scs";

  public static final String SESSION_ID = "80a7db98-6d1b-46c8-a602-fd6370fe5a21";
  public static final String JSON_STRING_MANDATORY = """
      {
          "duration": 10,
          "ueId": {
              "msisdn": "12345678901",
              "ipv4addr": "192.168.0.0/24"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          },
          "qos": "QOS_E"
      }
      """;

  public static final String JSON_STRING_ALL_PARAMS = """
      {
          "duration": 10,
          "ueId": {
              "externalId": "123456789@domain.com",
              "msisdn": "1234567812",
              "ipv4addr": "192.168.1.0/24"
          },
          "asId": {
              "ipv4addr": "192.168.1.0/24"
          },
          "uePorts": {
              "ranges": [
                  {
                      "from": 5010,
                      "to": 5020
                  }
              ],
              "ports": [
                  5060,
                  5070
              ]
          },
          "asPorts": {
              "ranges": [
                  {
                      "from": 5010,
                      "to": 5020
                  }
              ],
              "ports": [
                  5060,
                  5070
              ]
          },
          "qos": "QOS_E",
          "notificationUri": "http://127.0.0.1:8000/notifications",
          "notificationAuthToken": "c8974e592c2fa383d4a3960714"
      }
            
      """;
  public static final String JSON_STRING_MANDATORY_PARAMS = """
      {
               "duration": 10,
               "ueId": {
                   "msisdn": "12345678902",
                   "ipv4addr": "192.168.0.0/24"
               },
               "asId": {
                   "ipv4addr": "192.168.0.0/24"
               },
               "qos": ""
           }
      """;


  public static final String JSON_STRING_ALL = """
      {
          "duration": 10,
          "ueId": {
              "externalId": "123456789@domain.com",
              "msisdn": "1234567812",
              "ipv4addr": "192.168.1.0/24"
          },
          "asId": {
              "ipv4addr": "192.168.1.0/24"
          },
          "uePorts": {
              "ranges": [
                  {
                      "from": 5010,
                      "to": 5020
                  }
              ],
              "ports": [
                  5060,
                  5070
              ]
          },
          "asPorts": {
              "ranges": [
                  {
                      "from": 5010,
                      "to": 5020
                  }
              ],
              "ports": [
                  5060,
                  5070
              ]
          },
          "qos": "QOS_E",
          "notificationUri": "http://127.0.0.1:8000/notifications",
          "notificationAuthToken": "c8974e592c2fa383d4a3960714"
      }
      """;

}
