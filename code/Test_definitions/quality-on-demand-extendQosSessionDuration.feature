Feature: CAMARA Quality On Demand API, v0.11.0 - Operation extendQosSessionDuration
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing session with qosStatus "AVAILABLE"
    # * The sessionId of an existing session with qosStatus "UNAVAILABLE"
    #
    # References to OAS spec schemas refer to schemas specifies in quality-on-demand.yaml, version 0.11.0-rc.1

    Background: Common extendQosSessionDuration setup
        Given an environment at "apiRoot"
        And the resource "/quality-on-demand/v0.11/sessions/{sessionId}/extend"
        And the header "Content-Type" is set to "application/json"
        And the header "Authorization" is set to a valid access token
        And the header "x-correlator" is set to a UUID value
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
        And the request body is set by default to a request body compliant with the schema at "/components/schemas/ExtendSessionDuration"
        And the path parameter "sessionId" is set by default to a existing QoS session sessionId

    # Success scenarios

    @quality_on_demand_extendQosSessionDuration_01_generic_success_scenario
    Scenario: Common validations for any sucess scenario
        # Valid testing device and default request body compliant with the schema
        Given an existing QoS session created by operation createSession with qosStatus "AVAILABLE"
        And the path parameter "sessionId" is set to the value for that QoS session
        And the request body property "$.requestedAdditionalDuration" is set to a valid additional session duration
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 200
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/SessionInfo"
        And the response property "$.device" exists only if provided for createSession and with the same value
        And the response property "$.applicationServer" has the same value as in the request body
        And the response property "$.qosProfile" has the value provided for createSession
        And the response property "$.devicePorts" exists only if provided for createSession and with the same value
        And the response property "$.applicationServerPorts" exists only if provided for createSession and with the same value
        And the response property "$.sink" exists only if provided for createSession and with the same value
        # Implementations may not grant the requested extensions but they duration can not be reduced in any case
        And the response property "$.duration" is not lower than request property "$.requestedAdditionalDuration"

    @quality_on_demand_extendQosSessionDuration_02_exceed_max_duration
    Scenario: Extended duration cannot exceed the maxDuration for the QoS profile
        # Valid testing device and default request body compliant with the schema
        Given an existing QoS session created by operation createSession with qosStatus "AVAILABLE"
        And the path parameter "sessionId" is set to the value for that QoS session
        And the "maxDuration" for the QoS profile of the session as returned by "qos-profiles" API
        And the request body property "$.requestedAdditionalDuration" is set to a value that added to the existing QoS session "duration" exceeds the "maxDuration" for the QoS Profile
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 200
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/SessionInfo"
        And the response property "$.duration" does not exceed the "maxDuration" for the QoS Profile

    # To be discussed. Behaviour when the qosStatus of the session is REQUESTED
    @quality_on_demand_extendQosSessionDuration_03_requestedSession
    Scenario: Response extending duration for unavailable session
        Given an existing QoS session created by operation createSession with qosStatus "REQUESTED"
        And the path parameter "sessionId" is set to the value for that QoS session
        And the request body is set to a valid request body
        When the request "extendQosSessionDuration" is sent
        Then the response status code is TBD
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"

    # To be discussed. Behaviour when the qosStatus of the session is UNAVAILABLE
    @quality_on_demand_extendQosSessionDuration_04_unavailableSession
    Scenario: Response extending duration for unavailable session
        Given an existing QoS session created by operation createSession with qosStatus "UNAVAILABLE"
        And the path parameter "sessionId" is set to the value for that QoS session
        And the request body is set to a valid request body
        When the request "extendQosSessionDuration" is sent
        Then the response status code is TBD
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"

    # Errors 400

    @quality_on_demand_extendQosSessionDuration_400.1_schema_not_compliant
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the request body is set to any value which is not compliant with the schema at "/components/schemas/extendQosSessionDuration"
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # 404 NOT_FOUND is an alternative if path parameter format is not validated
    @quality_on_demand_extendQosSessionDuration_400.2_invalid_session_id
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the path parameter "sessionId" has not a UUID format
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_extendQosSessionDuration_400.3_no_request_body
    Scenario: Missing request body
        Given the request body is not included
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_extendQosSessionDuration_400.4_empty_request_body
    Scenario: Empty object as request body
        Given the request body is set to {}
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Generic 401 errors

    @quality_on_demand_extendQosSessionDuration_401.1_no_authorization_header
    Scenario: Error response for no header "Authorization"
        Given the header "Authorization" is not sent
        And the request body is set to a valid request body
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
    @quality_on_demand_extendQosSessionDuration_401.2_expired_access_token
    Scenario: Error response for expired access token
        Given the header "Authorization" is set to an expired access token
        And the request body is set to a valid request body
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_extendQosSessionDuration_401.3_invalid_access_token
    Scenario: Error response for invalid access token
        Given the header "Authorization" is set to an invalid access token
        And the request body is set to a valid request body
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text


    # Errors 403

    @quality_on_demand_extendQosSessionDuration_403.1_session_token_mismatch
    Scenario: QoS session not created by the API client given in the access token
        # To test this, a token have to be obtained for a different client
        Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoS session        And the header "Authorization" is set to a valid access token emitted for a different device
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

    # Errors 404

    @quality_on_demand_extendQosSessionDuration_404.1_not_found
    Scenario: sessionId of a no existing QoS session
        Given the path parameter "sessionId" is set to a random UUID
        And the request body is set to a valid request body
        When the request "extendQosSessionDuration" is sent
        Then the response status code is 404
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 404
        And the response property "$.code" is "NOT_FOUND"
        And the response property "$.message" contains a user friendly text
