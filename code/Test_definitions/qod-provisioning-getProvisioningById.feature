Feature: CAMARA QoD Provisioning API, v0.1.1 - Operation getProvisioningById
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The provisioningId of an existing QoD Provisiong, and the request properties used for createProvisioning
    #
    # References to OAS spec schemas refer to schemas specified in qod-provisioning.yaml, version 0.1.0

    Background: Common getProvisioningById setup
        Given an environment at "apiRoot"
        And the resource "/qod-provisioning/v0.1/device-qos/{provisioningId}"                                                              |
        # Unless indicated otherwise the QoD provisioning must be created by the same API client given in the access token
        And the header "Authorization" is set to a valid access token granted to the same client that created the QoD provisoning
        And the header "x-correlator" is set to a UUID value
        And the path parameter "provisoningId" is set by default to an existing QoD provisioning ID

    # Success scenarios

    @qod_provisioning_getProvisioningById_01_get_existing_qod_provisioning
    Scenario: Get an existing QoD Provisioning by provisioningId
        Given an existing QoD provisioning created by operation createProvisioning
        And the path parameter "provisoningId" is set to the value for that QoD provisioning
        When the request "getProvisioningById" is sent
        Then the response status code is 200
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/ProvisioningInfo"
        # Additionally any success response has to comply with some constraints beyond the schema compliance
        And the response property "$.device" exists only if provided for createProvisioning and with the same value
        And the response property "$.qosProfile" has the value provided for createProvisioning
        And the response property "$.sink" exists only if provided for createProvisioning and with the same value
        # sinkCredentials not explicitly mentioned to be returned if present, as this is debatible for security concerns
        And the response property "$.startedAt" exists only if "$.status" is not "REQUESTED" and the value is in the past
        And the response property "$.statusInfo" exists only if "$.status" is "UNAVAILABLE"

    @qod_provisioning_getProvisioningById_02_get_recent_unvailable
    Scenario: Provisioning becoming "UNAVAILABLE" is not released for at least 360 seconds
        Given an existing QoD provisioning deleted in the last 360 seconds
        And the path parameter "provisoningId" is set to the value for that QoD provisioning
        When the request "getProvisioningById" is sent
        Then the response status code is 200
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response body complies with the OAS schema at "/components/schemas/ProvisioningInfo"
        And the response property "$.status" is "UNAVAILABLE"

    # Errors 400

    # 400 errors are not expected for this operation unless the implementation validates the format of provisioningId
    # 404 NOT_FOUND is an alternative if path parameter format is not validated
    @qod_provisioning_getProvisioningById_400.1_invalid_id
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the path parameter "provisioningId" has not a UUID format
        When the request "getProvisioningById" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Generic 401 errors

    @qod_provisioning_getProvisioningById_401.1_no_authorization_header
    Scenario: No Authorization header
        Given the header "Authorization" is not sent
        When the request "getProvisioningById" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
    @qod_provisioning_getProvisioningById_401.2_expired_access_token
    Scenario: Expired access token
        Given the header "Authorization" is set to an expired access token
        When the request "getProvisioningById" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
        And the response property "$.message" contains a user friendly text

    @qod_provisioning_getProvisioningById_401.3_invalid_access_token
    Scenario: Invalid access token
        Given the header "Authorization" is set to an invalid access token
        When the request "getProvisioningById" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # Errors 403

    # TBD which code is more appropriate for this scenario
    @qod_provisioning_getProvisioningById_403.1_different_client_id
    Scenario: QoD provisioning not created by the API client given in the access token
        # To test this, a token have to be obtained by a different client
        Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoD provisioning
        When the request "getProvisioningById" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

    # Errors 404

    @qod_provisioning_getProvisioningById_404.1_not_found
    Scenario: provisioningId of a no existing QoD provisioning
        Given the path parameter "provisoningId" is set to a random UUID
        When the request "getProvisioningById" is sent
        Then the response status code is 404
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 404
        And the response property "$.code" is "NOT_FOUND"
        And the response property "$.message" contains a user friendly text
