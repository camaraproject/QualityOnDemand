Feature: CAMARA QoS Provisioning API, v0.3.0 - Operation getQosAssignmentById
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * The assignmentId of an existing QoS assignment, and the request properties used for createQosAssignment
  #
  # References to OAS spec schemas refer to schemas specified in qos-provisioning.yaml

  Background: Common getQosAssignmentById setup
    Given an environment at "apiRoot"
    And the resource "/qos-provisioning/v0.3/qos-assignments/{assignmentId}"                                                              |
    # Unless indicated otherwise the QoS assignment must be created by the same API client given in the access token
    And the header "Authorization" is set to a valid access token granted to the same client that created the QoS assignment
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "assignmentId" is set by default to an existing QoS assignment ID

  # Success scenarios

  @qos_provisioning_getQosAssignmentById_01_get_existing_qos_assignment
  Scenario: Get an existing QoS assignment by assignmentId
    Given an existing QoS assignment created by operation createQosAssignment
    And the path parameter "assignmentId" is set to the value for that QoS assignment
    When the request "getQosAssignmentById" is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/AssignmentInfo"
    # Additionally any success response has to comply with some constraints beyond the schema compliance
    And the response property "$.device" exists only if provided for createQosAssignment and with the same value
    And the response property "$.qosProfile" has the value provided for createQosAssignment
    And the response property "$.sink" exists only if provided for createQosAssignment and with the same value
    # sinkCredential not explicitly mentioned to be returned if present, as this is debatable for security concerns
    And the response property "$.startedAt" exists only if "$.status" is not "REQUESTED" and the value is in the past
    And the response property "$.statusInfo" exists only if "$.status" is "UNAVAILABLE"

  @qos_provisioning_getQosAssignmentById_02_get_recent_unavailable
  Scenario: QoS assignment becoming "UNAVAILABLE" is not released for at least 360 seconds
    Given an existing QoS assignment deleted in the last 360 seconds
    And the path parameter "assignmentId" is set to the value for that QoS assignment
    When the request "getQosAssignmentById" is sent
    Then the response status code is 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/AssignmentInfo"
    And the response property "$.status" is "UNAVAILABLE"

  # Errors 400

  # 400 errors are not expected for this operation unless the implementation validates the format of assignmentId
  # 404 NOT_FOUND is an alternative if path parameter format is not validated
  @qos_provisioning_getQosAssignmentById_400.1_invalid_id
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the path parameter "assignmentId" has not a UUID format
    When the request "getQosAssignmentById" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @qos_provisioning_getQosAssignmentById_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is not sent
    When the request "getQosAssignmentById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @qos_provisioning_getQosAssignmentById_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "getQosAssignmentById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_getQosAssignmentById_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "getQosAssignmentById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Errors 403

  @qos_provisioning_getQosAssignmentById_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope qos-provisioning:qos-assignments:read
    When the request "getQosAssignmentById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_getQosAssignmentById_403.2_different_client_id
  Scenario: QoS assignment not created by the API client given in the access token
    # To test this, a token have to be obtained by a different client
    Given the header "Authorization" is set to a valid access token emitted to a client which did not created the QoS assignment
    When the request "getQosAssignmentById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Errors 404

  @qos_provisioning_getQosAssignmentById_404.1_not_found
  Scenario: assignmentId of a no existing QoS assignment
    Given the path parameter "assignmentId" is set to a random UUID
    When the request "getQosAssignmentById" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text