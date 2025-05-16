Feature: CAMARA QoD Provisioning API, vwip - Operation revokeProvisioning
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The ProvisioningInfo of an existing QoD Provisioning
    # * The ProvisioningInfo of an existing QoD Provisioning with status "AVAILABLE", and with provided values for "sink" and "sinkCredential"
    #
    # References to OAS spec schemas refer to schemas specified in qod-provisioning.yaml

  Background: Common revokeProvisioning setup
    Given an environment at "apiRoot"
    And the resource "/qod-provisioning/vwip/device-qos/{provisioningId}"
        # Unless indicated otherwise the QoD provisioning must be created by the same API client given in the access token
    And the header "Authorization" is set to a valid access token granted to the same client that created the QoD provisioning
    And the header "x-correlator" is set to a UUID value
    And the path parameter "provisioningId" is set by default to an existing QoD provisioning ID

    # Success scenarios

  @qod_provisioning_revokeProvisioning_01_delete_existing_qod_provisioning_sync
  Scenario: Delete an existing QoD Provisioning synchronously
    Given that implementation deletes QoD provisioning synchronously
    And an existing QoD provisioning created by operation createProvisioning
    And the path parameter "provisioningId" is set to the value for that QoD provisioning
    When the request "revokeProvisioning" is sent
    Then the response status code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  @qod_provisioning_revokeProvisioning_02_delete_existing_qod_provisioning_async
  Scenario: Delete an existing QoD Provisioning asynchronously
    Given that implementation deletes QoD provisioning asynchronously
    And an existing QoD provisioning created by operation createProvisioning
    And the path parameter "provisioningId" is set to the value for that QoD provisioning
    When the request "revokeProvisioning" is sent
    Then the response status code is 202
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
        # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/ProvisioningInfo"
        # Additionally any success response has to comply with some constraints beyond the schema compliance
    And the response property "$.device" exists only if provided for createProvisioning and with the same value
    And the response property "$.qosProfile" has the value provided for createProvisioning
    And the response property "$.status" is "AVAILABLE"
    And the response property "$.statusInfo" is "DELETE_REQUESTED"
    And the response property "$.sink" exists only if provided for createProvisioning and with the same value
        # sinkCredentials not explicitly mentioned to be returned if present, as this is debatable for security concerns
    And the response property "$.startedAt" exists and the value is in the past

  @qod_provisioning_revokeProvisioning_03_event_notification_sync
  Scenario: Event is received if the provisioning was AVAILABLE and sink was provided (synchronous deletion)
    Given that implementation deletes QoD provisioning synchronously
    And an existing QoD provisioning created by operation createProvisioning with provided values for "sink" and "sinkCredential", and with status "AVAILABLE"
    And the path parameter "provisioningId" is set to the value for that QoD provisioning
    When the request "revokeProvisioning" is sent
    Then the response status code is 204
    And an event is received at the address of the "$.sink" provided for createProvisioning
    And the event header "Authorization" is set to "Bearer: " + the value of "$.sinkCredentials.accessToken" provided for createProvisioning
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "/components/schemas/EventStatusChanged"
        # Additionally any event body has to comply with some constraints beyond the schema compliance
    And the event body property "$.id" is unique
    And the event body property "$.type" is set to "org.camaraproject.qod-provisioning.v0.status-changed"
    And the event body property "$.data.provisioningId" as returned for createProvisioning
    And the event body property "$.data.status" is "UNAVAILABLE"
    And the event body property "$.data.statusInfo" is "DELETE_REQUESTED"

  @qod_provisioning_revokeProvisioning_04_event_notification_async
  Scenario: Event is received if the provisioning was AVAILABLE and sink was provided (asynchronous deletion)
    Given that implementation deletes QoD provisioning asynchronously
    And an existing QoD provisioning created by operation createProvisioning with provided values for "sink" and "sinkCredential", and with status "AVAILABLE"
    And the path parameter "provisioningId" is set to the value for that QoD provisioning
    When the request "revokeProvisioning" is sent
    Then the response status code is 202
    And when the asynchronous deletion process is completed
    And an event is received at the address of the "$.sink" provided for createProvisioning
    And the event header "Authorization" is set to "Bearer: " + the value of "$.sinkCredentials.accessToken" provided for createProvisioning
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "/components/schemas/EventStatusChanged"
        # Additionally any event body has to comply with some constraints beyond the schema compliance
    And the event body property "$.id" is unique
    And the event body property "$.type" is set to "org.camaraproject.qod-provisioning.v0.status-changed"
    And the event body property "$.data.provisioningId" as returned for createProvisioning
    And the event body property "$.data.status" is "UNAVAILABLE"
    And the event body property "$.data.statusInfo" is "DELETE_REQUESTED"

    # Errors 400

    # 400 errors are not expected for this operation unless the implementation validates the format of provisioningId
    # 404 NOT_FOUND is an alternative if path parameter format is not validated
  @qod_provisioning_revokeProvisioning_400.1_invalid_id
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the path parameter "provisioningId" has not a UUID format
    When the request "revokeProvisioning" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    # Generic 401 errors

  @qod_provisioning_revokeProvisioning_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is not sent
    When the request "revokeProvisioning" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @qod_provisioning_revokeProvisioning_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "revokeProvisioning" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
    And the response property "$.message" contains a user friendly text

  @qod_provisioning_revokeProvisioning_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "revokeProvisioning" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

    # Errors 403

  @qod_provisioning_revokeProvisioning_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope qod-provisioning:device-qos:delete
    When the request "revokeProvisioning" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @qod_provisioning_revokeProvisioning_403.2_different_client_id
  Scenario: QoD provisioning not created by the API client given in the access token
        # To test this, a token have to be obtained by a different client
    Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoD provisioning
    When the request "revokeProvisioning" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    # Errors 404

  @qod_provisioning_revokeProvisioning_404.1_not_found
  Scenario: provisioningId of a no existing QoD provisioning
    Given the path parameter "provisioningId" is set to a random UUID
    When the request "revokeProvisioning" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text