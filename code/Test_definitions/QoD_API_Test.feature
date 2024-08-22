@quality_on_demand
Feature: CAMARA Quality on Demand  API, v0.10.2 - Session Operations
  # Input to be provided by the implementation to the tester
  # References to OAS spec schemas refer to schemas specifies in quality-on-demand.yaml, version 0.2.0


	Background: Common Quality on demand setup
    Given the resource "/quality-on-demand/v0.10.2/sessions" as QoD Mock URL                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the request body is set by default to a request body compliant with the schema

  @quality_on_demand_01_create_get_delete_mandatory_parameters
  Scenario: Create QoD session with mandatory parameters
    Given Use the QoD MOCK URL
    When Create a new QoD session with mandatory parameters
    Then Response code is 201
	And Response body contains "session-id"
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    When Get QoD session
    Then Response code is 200
	And Response body contains details for session
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
    When Delete existing QoD session
    Then Response code is 204
	And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
	

  @quality_on_demand_02_create_get_delete_all_parameters
  Scenario: Create QoD session with all parameters & Deletion of Session id
    Given Use the QoD MOCK URL
    When Create a new QoD session with all parameters
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    When Get QoD session
    Then Response code is 200
	And Response body contains details for session
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
    When Delete existing QoD session
    Then Response code is 204
	And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
	
	

  @quality_on_demand_03_CreateSessionDeleteInvalidSession
  Scenario: Delete a Invalid QoD session for session id
    Given Use the QoD MOCK URL
    When Create a new QoD session with mandatory parameters
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    When Delete Invalid QoD session
    Then Response code is 404
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text


  @quality_on_demand_04_InvalidCreateSession
  Scenario: QoD session with 5XX response
    # Test with end point not reachable
    Given Use the QoD MOCK URL with invalid scenario
    When Create a new QoD session along with all parameters
    Then Response code is 500
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 500
    And the response property "$.code" is "Internal Server Error"
    And the response property "$.message" contains a user friendly text
	


  @quality_on_demand_05_InvalidCreateSessionpayload
  Scenario: QoD session with invalid payload 4XX
    # Test with invalid Payload
    Given Use the QoD MOCK URL with invalid scenario
    When Create a new QoD session with parameters
    Then Response code is 400
	And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text
	
	
   @quality_on_demand_06_ExtendSessionDurationLessThanTwelveHour
  Scenario: Extend QoD active session for the total session duration of less than 12 hours
    Given Use the QOD BaseURL
    When Create a new QoD session with $.ipv4 and session duration of 60 seconds
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    Then The Session has a duration of 60 seconds
    Then The callback application receives the qosStatus AVAILABLE
    When Extend session for 300 seconds
    Then Response code is 200
    Then The Session has a duration between 301 and 360 seconds
    Then Wait 40 seconds
    When Get QoD session
    Then Response code is 200
	And Response body contains details for session
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
    When Delete QoD session
    Then Response code is 204
	And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
	
	@quality_on_demand_07_ExtendSessionDurationTwelveHour
  Scenario: Extend QoD active session for the total session duration of 12 hours
    Given Use the QOD BaseURL
    When Create a new QoD session with $.ipv4 and session duration of 43140 seconds
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    Then The Session has a duration of 43140 seconds
    Then The callback application receives the qosStatus AVAILABLE
    When Extend session for 60 seconds
    Then Response code is 200
    Then The Session has a duration between 43141 and 43200 seconds
    When Delete QoD session
    Then Response code is 204
	And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/SessionId"
	

  @quality_on_demand_08_ExtendSessionForEmptyJsonField
  Scenario: Extend session request for an empty json filed
    Given Use the QOD BaseURL
    When Create a new QoD session for $.ipv4
    Then Response code is 201
    When Extend session for an empty json body
    Then Response code is 400
	And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_09_ExtendSessionForInvalidJsonField
  Scenario: Extend session request for an invalid json
    Given Use the QOD BaseURL
    When Create a new QoD session for $.ipv4
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    When Request extend session for an invalid json payload
    Then Response code is 400
	And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_10_ExtendSessionBelowBoundery
  Scenario: Extend session request for below boundary value
    Given Use the QOD BaseURL
    When Create a new QoD session for $.ipv4 
    Then Response code is 201
    When Request extend session for below boundary duration value
    Then Response code is 400
	And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_11_ExtendSessionAboveBoundery
  Scenario: Extend session request for above boundary value
    Given Use the QOD BaseURL
    When Create a new QoD session for $.ipv4
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    When Request extend session for below boundary duration value
    Then Response code is 400
	And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_11_ExtendSessionForInvalidType
  Scenario: Extend session request for an invalid type
    Given Use the QOD BaseURL
    When Create a new QoD session for $.ipv4
    Then Response code is 201
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"
    When Request extend session for non-numeric duration value
    Then Response code is 400
	And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_12_InvalidGetSession
  Scenario: Get a QoD session for an unknown / expired session id
    Given Use the QOD BaseURL
    When Create a new QoD session for an unknown or expired session id
    Then Response code is 404
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
	
	
	@quality_on_demand_13_GetQoSSession
  Scenario: Extend session request for an invalid type
    Given Use the QOD URL "/retrieve-sessions"
    When Create a new QoD session for $.ipv4
    Then Response code is 200
	And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/CreateSession"

	
	
	# Generic 401 errors

  @quality_on_demand_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @quality_on_demand_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text


  @quality_on_demand_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
