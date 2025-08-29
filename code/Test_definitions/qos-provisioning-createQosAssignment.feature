Feature: CAMARA QoS Provisioning API, v0.3.0 - Operation createQosAssignment
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * List of device identifier types which are not supported, among: phoneNumber, ipv4Address, ipv6Address.
  #   For this version, CAMARA does not allow the use of networkAccessIdentifier, so it is considered by default as not supported.
  #
  # Testing assets:
  # * A device object applicable for QoS Provisioning service
  # * A device object identifying a device commercialized by the implementation for which the service is not applicable, if any
  #
  # References to OAS spec schemas refer to schemas specified in qos-provisioning.yaml

  Background: Common createQosAssignment setup
    Given an environment at "apiRoot"
    And the resource "/qos-provisioning/v0.3/qos-assignments"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    # Properties not explicitly overwritten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/CreateAssignment"

  # Success scenarios

  @qos_provisioning_createQosAssignment_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request property "$.qosProfile" is set to a valid QoS Profile as returned by QoS Profiles API
    When the request "createQosAssignment" is sent
    Then the response status code is 201
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    # The response has to comply with the generic response schema which is part of the spec
    And the response body complies with the OAS schema at "/components/schemas/AssignmentInfo"
    # Additionally any success response has to comply with some constraints beyond the schema compliance
    And the response property "$.device" exists only if provided in the request body and with the same value
    And the response property "$.qosProfile" has the same value as in the request body
    And the response property "$.sink" exists only if provided in the request body and with the same value
    # sinkCredential not explicitly mentioned to be returned if present, as this is debatable for security concerns
    And the response property "$.startedAt" exists only if "$.status" is "AVAILABLE" and the value is in the past
    And the response property "$.statusInfo" exists only if "$.status" is "UNAVAILABLE"

  @qos_provisioning_createQosAssignment_02_1_sinkcredential_provided
  Scenario: Create QoS assignment with sink and valid sinkCredential
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request property "$.qosProfile" is set to a valid QoS Profile as returned by QoS Profiles API
    And the request property "$.sink" is set to a URL when events can be monitored
    And the request property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request property "$.sinkCredential.accessToken" is set to a valid access token accepted by the events receiver
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is set to a value long enough in the future
    When the request "createQosAssignment" is sent
    Then the response status code is 201

  @qos_provisioning_createQosAssignment_02_2_event_notification_sent
  Scenario: Event is received for QoS assignment outcome after providing sink
    # Assumes a valid QoS assignment with sinkCredential has been created
    Given a QoS assignment has been created successfully and includes a valid sink with sinkCredentials
    When the QoS assignment outcome is known
    Then an event is received at the address of the request property "$.sink"
    And the event header "Authorization" is set to "Bearer " + the value of the request property "$.sinkCredential.accessToken"
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "/components/schemas/EventStatusChanged"
    And the event body property "$.id" is unique
    And the event body property "$.type" is set to "org.camaraproject.qos-provisioning.v0.status-changed"
    And the event body property "$.data.assignmentId" has the same value as createQosAssignment response property "$.assignmentId"
    And the event body property "$.data.status" is "AVAILABLE" or "UNAVAILABLE"
    And the event body property "$.data.statusInfo" exists only if "$.data.status" is "UNAVAILABLE"

  @qos_provisioning_createQosAssignment_03_3_legged_missing_device
  Scenario: Device is not returned if not included in the creation request
    Given the header "Authorization" is set to a valid 3-legged access token associated to a valid testing device supported by the service
    And the request property "$.device" is not included
    When the request "createQosAssignment" is sent
    Then the response status code is 201
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/AssignmentInfo"
    And the response property "$.device" does not exist

  # Common error scenarios for management of input parameter device

  @qos_provisioning_createQosAssignment_C01.01_device_empty
  Scenario: The device value is an empty object
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is set to: {}
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_createQosAssignment_C01.02_device_identifiers_not_schema_compliant
  Scenario Outline: Some device identifier value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | device_identifier                | oas_spec_schema                             |
      | $.device.phoneNumber             | /components/schemas/PhoneNumber             |
      | $.device.ipv4Address             | /components/schemas/DeviceIpv4Addr          |
      | $.device.ipv6Address             | /components/schemas/DeviceIpv6Address       |
      | $.device.networkAccessIdentifier | /components/schemas/NetworkAccessIdentifier |

  # This scenario may happen e.g. with 2-legged access tokens, which do not identify a single device.
  @qos_provisioning_createQosAssignment_C01.03_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is compliant with the schema but does not identify a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_createQosAssignment_C01.04_unnecessary_device
  Scenario: Device not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @qos_provisioning_createQosAssignment_C01.05_missing_device
  Scenario: Device not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is not included
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @qos_provisioning_createQosAssignment_C01.06_unsupported_device
  Scenario: None of the provided device identifiers is supported by the implementation
    Given that some types of device identifiers are not supported by the implementation
    And the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" only includes device identifiers not supported by the implementation
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNSUPPORTED_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  # When the service is only offered to certain types of devices or subscriptions, e.g. IoT, B2C, etc.
  @qos_provisioning_createQosAssignment_C01.07_device_not_supported
  Scenario: Service not available for the device
    Given that the service is not available for all devices commercialized by the operator
    And a valid device, identified by the token or provided in the request body, for which the service is not applicable
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user-friendly text

  # Errors 400

  @qos_provisioning_createQosAssignment_400.1_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is set to any value which is not compliant with the schema at "/components/schemas/CreateAssignment"
    When the request "createQosAssignment" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_createQosAssignment_400.2_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "createQosAssignment" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_createQosAssignment_400.3_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to {}
    When the request "createQosAssignment" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # PLAIN and REFRESHTOKEN are considered in the schema so INVALID_ARGUMENT is not expected
  @qos_provisioning_createQosAssignment_400.7_invalid_sink_credential
  Scenario Outline: Invalid credential
    Given the request body property  "$.sinkCredential.credentialType" is set to "<unsupported_credential_type>"
    When the request "createQosAssignment" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

    Examples:
      | unsupported_credential_type |
      | PLAIN                       |
      | REFRESHTOKEN                |

  # Only "bearer" is considered in the schema so a generic schema validator may fail and generate a 400 INVALID_ARGUMENT without further distinction,
  # and both could be accepted
  @qos_provisioning_createQosAssignment_400.8_sink_credential_invalid_token
  Scenario: Invalid token
    Given the request body property  "$.sinkCredential.accessTokenType" is set to a value other than "bearer"
    When the request "createQosAssignment" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN" or "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # TBD if we need a dedicated code
  @qos_provisioning_createQosAssignment_400.9_non_existent_qos_profile
  Scenario: Non existent QoS profile
    Given the request body property "qosProfile" is set to a non-existent QoS Profile
    When the request "createQosAssignment" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @qos_provisioning_createQosAssignment_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "createQosAssignment" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @qos_provisioning_createQosAssignment_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "createQosAssignment" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @qos_provisioning_createQosAssignment_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "createQosAssignment" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Errors 403

  @qos_provisioning_createQosAssignment_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope qos-provisioning:qos-assignments:create
    When the request "createQosAssignment" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Errors 409

  @qos_provisioning_createQosAssignment_409.1_provisioning_conflict
  Scenario: Assignment conflict
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And a QoS assignment already exists for that device
    When the request "createQosAssignment" is sent
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "CONFLICT"
    And the response property "$.message" contains a user friendly text

  # Errors 422

  @qos_provisioning_createQosAssignment_422.1_qos_profile_not_applicable
  Scenario: QoS Profile not applicable for the QoS assignment
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the requested QoS Profile exists but is not applicable for the QoS assignment
    When the request "createQosAssignment" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "QOS_PROVISIONING.QOS_PROFILE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text