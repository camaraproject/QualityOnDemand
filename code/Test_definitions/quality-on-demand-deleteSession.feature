Feature: CAMARA Quality On Demand API, vwip - Operation deleteSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The sessionId of an existing session.
    # * The sessionId of an existing session with status "AVAILABLE", and with provided values for "sink" and "sinkCredential".
    # * The sessionId of an existing session with status "UNAVAILABLE", and with provided values for "sink" and "sinkCredential".
    #
    # References to OAS spec schemas refer to schemas specifies in quality-on-demand.yaml

  Background: Common deleteSession setup
    Given an environment at "apiRoot"
    And the resource "/quality_on_demand/vwip/sessions/{sessionId}"
        # Unless indicated otherwise the QoD provisioning must be created by the same API client given in the access token
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the path parameter "sessionId" is set by default to a existing QoS session sessionId

    # Success scenarios

  @quality_on_demand_deleteSession_01_delete_existing_qod_session
  Scenario: Delete an existing QoD session
    Given an existing QoS session created by operation createSession
    And the path parameter "sessionId" is set to the value for that QoS session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @quality_on_demand_deleteSession_02_event_notification
  Scenario: Event is received if the session was AVAILABLE and sink was provided
    Given an existing QoS session created by operation createProvisioning with provided values for "sink" and "sinkCredential", and with status "AVAILABLE"
    And the path parameter "sessionId" is set to the value for that QoS session
    When the request "deleteSession" is sent
    Then the response status code is 204
    And an event is received at the address of the "$.sink" provided for createSession
    And the event header "Authorization" is set to "Bearer: " + the value of the property "$.sinkCredentials.accessToken" provided for createSession
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "/components/schemas/EventQosStatusChanged"
        # Additionally any event body has to comply with some constraints beyond the schema compliance
    And the event body property "$.id" is unique
    And the event body property "$.type" is set to "org.camaraproject.qod.v1.qos-status-changed"
    And the event body property "$.data.sessionId" as returned for createProvisioning
    And the event body property "$.data.qosStatus" is "UNAVAILABLE"
    And the event body property "$.data.statusInfo" is "DELETE_REQUESTED"

    # Errors 400

    # 400 errors are not expected for this operation unless the implementation validates the format of sessionId
    # 404 NOT_FOUND is an alternative if path parameter format is not validated
  @quality_on_demand_deleteSession_400.1_invalid_session_id
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the path parameter "sessionId" has not a UUID format
    When the request "deleteSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @quality_on_demand_deleteSession_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "deleteSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @quality_on_demand_deleteSession_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "deleteSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_deleteSession_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "deleteSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Generic 403 errors

  @quality_on_demand_deleteSession_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope quality-on-demand:sessions:delete
    When the request "deleteSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @quality_on_demand_deleteSession_403.2_session_token_mismatch
  Scenario: QoS session not created by the API client given in the access token
        # To test this, a token have to be obtained for a different client
    Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoS session
    When the request "deleteSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @quality_on_demand_deleteSession_404.1_not_found
  Scenario: sessionId of a no existing QoS session
    Given the path parameter "sessionId" is set to a random UUID
    When the request "deleteSession" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text