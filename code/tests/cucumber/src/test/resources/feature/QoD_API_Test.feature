#/*- ---license-start
#* CAMARA Project
#* ---
#* Copyright (C) 2022 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC
#* The contributor of this file confirms his sign-off for the
#* Developer Certificate of Origin (http://developercertificate.org).
#* ---
#* Licensed under the Apache License, Version 2.0 (the "License");
#* you may not use this file except in compliance with the License.
#* You may obtain a copy of the License at
#*
#*      http://www.apache.org/licenses/LICENSE-2.0
#*
#* Unless required by applicable law or agreed to in writing, software
#* distributed under the License is distributed on an "AS IS" BASIS,
#* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#* See the License for the specific language governing permissions and
#* limitations under the License.
#* ---license-end
#*/

@QoD @QoDSanity
Feature: Automated QoD System Integration Test

  @QoDSessionCreateGetDelete
  Scenario: Create QoD session, get QoD session and delete QoD Session
    Given Use the BaseURL
    When Create a new QoD session with mandatory parameters
    Then Response code is 201
    When Delete QoD session
    Then Response code is 204
    When Create a new QoD session with all parameters
    Then Response code is 201
    When Get QoD session
    Then Response code is 200
    When Delete QoD session
    Then Response code is 204

  @QoDInvalidGetSession
  Scenario: Get a QoD session for an unknown / expired session id
    Given Use the BaseURL
    When Create a new QoD session for an unknown or expired session id
    Then Response code is 404
    Then Response in message is QoD session not found

  @QoDInvalidCreateSession
  Scenario: QoD session for an invalid payload
    Given Use the BaseURL

    # Test with missing double quote in json payload
    When Create a new QoD session with missing double quote in json payload
    Then Response code is 400

    # Test with missing bracket in json payload
    When Create a new QoD session with missing bracket in json payload
    Then Response code is 400

    # Test with a wrong msisdn
    When Create a new QoD session with incorrect msisdn in json payload
    Then Response code is 400

    #Test with a wrong ip address
    When Create a new QoD session with incorrect ipaddress in json payload
    Then Response code is 400

    # Test with missing "qos" in json payload
    When Create a new QoD session with missing "qos" in json payload
    Then Response code is 400
