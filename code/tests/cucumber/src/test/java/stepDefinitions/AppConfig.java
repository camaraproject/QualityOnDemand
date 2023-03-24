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

package stepDefinitions;

public class AppConfig {

  public static final String BASE_URL = "https://FQDN";
  public static final String INVALID_SESSION_ID = "70a6db98-6d1b-46c8-a602-fd6370fe5a22";
  public static final String JSON_STRING_MANDATORY = """
      {
          "duration": 50,
          "ueId": {
              "msisdn": "123456789"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          },
          "qos": "QOS_E"
      }
      """;

  public static final String JSON_STRING_MISSING_DOUBLE_QUOTE = """
    {
          "duration": 50,
          "ueId": {
              "msisdn": "123456789"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          },
          qos": "QOS_E"
      }
      """;

  public static final String JSON_STRING_MISSING_BRACKET = """
    "duration": 50,
          "ueId": {
              "msisdn": "123456789"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          },
          "qos": "QOS_E"
      }
      """;

  public static final String JSON_STRING_INCORRECT_MSISDN = """
    {
          "duration": 50,
          "ueId": {
              "msisdn": "123456789"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          },
          "qos": "QOS_E"
      }
      """;

  public static final String JSON_STRING_INCORRECT_IP = """
 {
          "duration": 50,
          "ueId": {
              "msisdn": "12345678901"
              "ipv6addr": "192.168.0.0"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          },
          "qos": "QOS_E"
      }
      """;

  public static final String JSON_STRING_MISSING_QOS = """
      {
          "duration": 60,
          "ueId": {
              "msisdn": "12345678901",
              "ipv4addr": "192.168.0.0/24"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
          }
      }
      """;

  public static final String JSON_STRING_ALL = """
      {
          "duration": 50,
          "ueId": {
              "msisdn": "123456789"
          },
          "asId": {
              "ipv4addr": "192.168.0.0/24"
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
          "notificationUri": "https://application-server.com/notifications",
          "notificationAuthToken": "c8974e592c2fa383d4a3960714"
      }
      """;
}
