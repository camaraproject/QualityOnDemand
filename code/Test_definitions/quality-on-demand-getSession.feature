Feature: CAMARA Quality On Demand API, vwip - Operation getSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing QoS session, and the request properties used for createSession
    #
    # References to OAS spec schemas refer to schemas specifies in quality-on-demand.yaml

    Background: Common getSession setup
        Given an environment at "apiRoot"
        And the resource "/quality-on-demand/vwip/sessions/{sessionId}"
        # Unless indicated otherwise the session must be created by the same API client given in the access token
        And the header "Authorization" is set to a valid access token
        And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
        And the path parameter "sessionId" is set by default to a existing QoS session sessionId

    # Success scenarios

    @quality_on_demand_getSession_01_get_existing_session
    Scenario: Get an existing QoD session by sessionId
        Given an existing QoS session created by operation createSession
        And the path parameter "sessionId" is set to the value for that QoS session
        When the request "getSession" is sent
        Then the response status code is 200
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/SessionInfo"
        # Additionally any success response has to comply with some constraints beyond the schema compliance
        And the response property "$.device" exists only if provided for createSession and with the same value
        And the response property "$.applicationServer" has the same value as in the request body
        And the response property "$.qosProfile" has the value provided for createSession
        And the response property "$.devicePorts" exists only if provided for createSession and with the same value
        And the response property "$.applicationServerPorts" exists only if provided for createSession and with the same value
        And the response property "$.sink" exists only if provided for createSession and with the same value
        # sinkCredential not explicitly mentioned to be returned if present, as this is debatable for security concerns
        And the response property "$.startedAt" exists only if "$.qosStatus" is "AVAILABLE" and the value is in the past
        And the response property "$.expiresAt" exists only if "$.qosStatus" is not "REQUESTED" and the value is later than "$.startedAt"
        And the response property "$.statusInfo" exists only if "$.qosStatus" is "UNAVAILABLE"

    @quality_on_demand_getSession_02_get_recent_unvailable
    Scenario: QOS Session becoming "UNAVAILABLE" is not released for at least 360 seconds
        Given an existing QoS session deleted in the last 360 seconds
        And the path parameter "sessionId" is set to the value for that QoS session
        When the request "getSession" is sent
        Then the response status code is 200
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response body complies with the OAS schema at "/components/schemas/SessionInfo"
        And the response property "$.status" is "UNAVAILABLE"

    # Errors 400

    # 400 errors are not expected for this operation unless the implementation validates the format of sessionId
    # 404 NOT_FOUND is an alternative if path parameter format is not validated
    @quality_on_demand_getSession_400.1_invalid_session_id
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the path parameter "sessionId" has not a UUID format
        When the request "getSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Generic 401 errors

    @quality_on_demand_getSession_401.1_no_authorization_header
    Scenario: Error response for no header "Authorization"
        Given the header "Authorization" is not sent
        When the request "getSession" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
    @quality_on_demand_getSession_401.2_expired_access_token
    Scenario: Error response for expired access token
        Given the header "Authorization" is set to an expired access token
        When the request "getSession" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_getSession_401.3_invalid_access_token
    Scenario: Error response for invalid access token
        Given the header "Authorization" is set to an invalid access token
        When the request "getSession" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # Errors 403

    @quality_on_demand_getSession_403.1_missing_access_token_scope
    Scenario: Missing access token scope
        Given the header "Authorization" is set to an access token that does not include scope quality-on-demand:sessions:read
        When the request "getSession" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_getSession_403.2_session_token_mismatch
    Scenario: QoS session not created by the API client given in the access token
        # To test this, a token have to be obtained for a different client
        Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoS session
        When the request "getSession" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

    # Errors 404

    @quality_on_demand_getSession_404.1_not_found
    Scenario: sessionId of a no existing QoS session
        Given the path parameter "sessionId" is set to a random UUID
        When the request "getSession" is sent
        Then the response status code is 404
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 404
        And the response property "$.code" is "NOT_FOUND"
        And the response property "$.message" contains a user friendly text
