#/*- ---license-start
#* CAMARA Project
#* ---
#* Copyright (C) 2022 - 2023 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC
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

  @QQoDSessionCreateGetDelete
  Scenario: Create QoD session with mandatory parameters
    Given Use the QoD MOCK URL
    When Create a new QoD session with mandatory parameters
    Then Response code is 201
    When Get QoD session
    Then Response code is 200
    When Delete existing QoD session
    Then Response code is 204

  @QoDSessionCreateGetDeleteAllparams
  Scenario: Create QoD session with all parameters & Deletion of Session id
    Given Use the QoD MOCK URL
    When Create a new QoD session with all parameters
    Then Response code is 201
    When Get QoD session
    Then Response code is 200
    When Delete existing QoD session
    Then Response code is 204

  @QoDCreateSessionDeleteInvalidSession
  Scenario: Delete a Invalid QoD session for session id
    Given Use the QoD MOCK URL
    When Create a new QoD session with mandatory parameters
    Then Response code is 201
    When Delete Invalid QoD session
    Then Response code is 404


  @QoDInvalidCreateSession
  Scenario: QoD session with 5XX response
    # Test with end point not reachable
    Given Use the QoD MOCK URL with invalid scenario
    When Create a new QoD session along with all parameters
    Then Response code is 500


  @QoDInvalidCreateSessionpayload
  Scenario: QoD session with invalid payload 4XX
    # Test with invalid Payload
    Given Use the QoD MOCK URL with invalid scenario
    When Create a new QoD session with parameters
    Then Response code is 400



