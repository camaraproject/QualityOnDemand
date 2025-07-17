Feature: CAMARA QoS Provisioning API, v0.3.0-rc.1 - Operation revokeQosAssignment
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # Testing assets:
    # * The AssignmentInfo of an existing QoS assignment
    # * The AssignmentInfo of an existing QoS assignment with status "AVAILABLE", and with provided values for "sink" and "sinkCredential"
    #
    # References to OAS spec schemas refer to schemas specified in qos-provisioning.yaml


    Background: Common revokeQosAssignment setup
        Given an environment at "apiRoot"
        And the resource "/qos-provisioning/v0.3rc1/qos-assignments/{assignmentId}"
        # Unless indicated otherwise the QoS assignment must be created by the same API client given in the access token
        And the header "Authorization" is set to a valid access token granted to the same client that created the QoS assignment
        And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
        And the path parameter "assignmentId" is set by default to an existing QoS assignment ID

    # Success scenarios

    @qos_provisioning_revokeQosAssignment_01_delete_existing_qos_assignment_sync
    Scenario: Delete an existing QoS assignment synchronously
        Given that implementation deletes QoS assignment synchronously
        And an existing QoS assignment created by operation createQosAssignment
        And the path parameter "assignmentId" is set to the value for that QoS assignment
        When the request "revokeQosAssignment" is sent
        Then the response status code is 204
        And the response header "x-correlator" has same value as the request header "x-correlator"

    @qos_provisioning_revokeQosAssignment_02_delete_existing_qos_assignment_async
    Scenario: Delete an existing QoS assignment asynchronously
        Given that implementation deletes QoS assignment asynchronously
        And an existing QoS assignment created by operation createQosAssignment
        And the path parameter "assignmentId" is set to the value for that QoS assignment
        When the request "revokeQosAssignment" is sent
        Then the response status code is 202
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/AssignmentInfo"
        # Additionally any success response has to comply with some constraints beyond the schema compliance
        And the response property "$.device" exists only if provided for createQosAssignment and with the same value
        And the response property "$.qosProfile" has the value provided for createQosAssignment
        And the response property "$.status" is "AVAILABLE"
        And the response property "$.statusInfo" is "DELETE_REQUESTED"
        And the response property "$.sink" exists only if provided for createQosAssignment and with the same value
        # sinkCredential not explicitly mentioned to be returned if present, as this is debatable for security concerns
        And the response property "$.startedAt" exists and the value is in the past

    @qos_provisioning_revokeQosAssignment_03_event_notification_sync
    Scenario: Event is received if the QoS assignment was AVAILABLE and sink was provided (synchronous deletion)
        Given that implementation deletes QoS assignment synchronously
        And an existing QoS assignment created by operation createQosAssignment with provided values for "sink" and "sinkCredential", and with status "AVAILABLE"
        And the path parameter "assignmentId" is set to the value for that QoS assignment
        When the request "revokeQosAssignment" is sent
        Then the response status code is 204
        And an event is received at the address of the "$.sink" provided for createQosAssignment
        And the event header "Authorization" is set to "Bearer: " + the value of "$.sinkCredential.accessToken" provided for createQosAssignment
        And the event header "Content-Type" is set to "application/cloudevents+json"
        And the event body complies with the OAS schema at "/components/schemas/EventStatusChanged"
        # Additionally any event body has to comply with some constraints beyond the schema compliance
        And the event body property "$.id" is unique
        And the event body property "$.type" is set to "org.camaraproject.qos-provisioning.v0.status-changed"
        And the event body property "$.data.assignmentId" as returned for createQosAssignment
        And the event body property "$.data.status" is "UNAVAILABLE"
        And the event body property "$.data.statusInfo" is "DELETE_REQUESTED"

    @qos_provisioning_revokeQosAssignment_04_event_notification_async
    Scenario: Event is received if the QoS assignment was AVAILABLE and sink was provided (asynchronous deletion)
        Given that implementation deletes QoS assignment asynchronously
        And an existing QoS assignment created by operation createQosAssignment with provided values for "sink" and "sinkCredential", and with status "AVAILABLE"
        And the path parameter "assignmentId" is set to the value for that QoS assignment
        When the request "revokeQosAssignment" is sent
        Then the response status code is 202
        And when the asynchronous deletion process is completed
        Then an event is received at the address of the "$.sink" provided for createQosAssignment
        And the event header "Authorization" is set to "Bearer: " + the value of "$.sinkCredential.accessToken" provided for createQosAssignment
        And the event header "Content-Type" is set to "application/cloudevents+json"
        And the event body complies with the OAS schema at "/components/schemas/EventStatusChanged"
        # Additionally any event body has to comply with some constraints beyond the schema compliance
        And the event body property "$.id" is unique
        And the event body property "$.type" is set to "org.camaraproject.qos-provisioning.v0.status-changed"
        And the event body property "$.data.assignmentId" as returned for createQosAssignment
        And the event body property "$.data.status" is "UNAVAILABLE"
        And the event body property "$.data.statusInfo" is "DELETE_REQUESTED"

    # Errors 400

    # 400 errors are not expected for this operation unless the implementation validates the format of assignmentId
    # 404 NOT_FOUND is an alternative if path parameter format is not validated
    @qos_provisioning_revokeQosAssignment_400.1_invalid_id
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the path parameter "assignmentId" has not a UUID format
        When the request "revokeQosAssignment" is sent
        Then the response status code is 404
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Generic 401 errors

    @qos_provisioning_revokeQosAssignment_401.1_no_authorization_header
    Scenario: No Authorization header
        Given the header "Authorization" is not sent
        When the request "revokeQosAssignment" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
    @qos_provisioning_revokeQosAssignment_401.2_expired_access_token
    Scenario: Expired access token
        Given the header "Authorization" is set to an expired access token
        When the request "revokeQosAssignment" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    @qos_provisioning_revokeQosAssignment_401.3_invalid_access_token
    Scenario: Invalid access token
        Given the header "Authorization" is set to an invalid access token
        When the request "revokeQosAssignment" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # Errors 403

    @qos_provisioning_revokeQosAssignment_403.1_missing_access_token_scope
    Scenario: Missing access token scope
        Given the header "Authorization" is set to an access token that does not include scope qos-provisioning:qos-assignments:delete
        When the request "revokeQosAssignment" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

    @qos_provisioning_revokeQosAssignment_403.2_different_client_id
    Scenario: QoS assignment not created by the API client given in the access token
        # To test this, a token have to be obtained by a different client
        Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoS assignment
        When the request "revokeQosAssignment" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

    # Errors 404

    @qos_provisioning_revokeQosAssignment_404.1_not_found
    Scenario: assignmentId of a no existing QoS assignment
        Given the path parameter "assignmentId" is set to a random UUID
        When the request "revokeQosAssignment" is sent
        Then the response status code is 404
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 404
        And the response property "$.code" is "NOT_FOUND"
        And the response property "$.message" contains a user friendly text
