Feature: CAMARA QoS Profiles API, vwip - Operation retrieveQoSProfiles
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * List of device identifier types which are not supported, among: phoneNumber, ipv4Address, ipv6Address.
  #   For this version, CAMARA does not allow the use of networkAccessIdentifier, so it is considered by default as not supported.
  #
  # Testing assets:
  # * The name of an existing QoS profile
  # * If some QoS Profile is restricted for some devices, provide the QoS profile name and device
  # * A device object identifying a device commercialized by the implementation for which the service is not applicable, if any

  # References to OAS spec schemas refer to schemas specifies in qos-profiles.yaml

  Background: Common retrieveQoSProfiles setup
    Given an environment at "apiRoot"
    And the resource "/qos-profiles/vwip/retrieve-qos-profiles"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    # Properties not explicitly overwritten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/QosProfileDeviceRequest"

    # Success scenarios

  @qos_profiles_retrieveQoSProfiles_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    Given a request body compliant with the schema at "/components/schemas/QosProfileDeviceRequest"
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the the response array, if any, complies with the OAS schema at "/components/schemas/QosProfile"
    # TBC: Add additional constraints, such as max* properties must be higher than min* equivalent properties, etc

  @qos_profiles_retrieveQoSProfiles_02_filter_by_name_only
  Scenario: Retrieve QoS profiles only by name
    Given the request body property "$.name" is set to an existing QoS profile name
    And the request body properties "$.device" and "$.status" are not included
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response array has only one item which complies with the OAS schema at "/components/schemas/QosProfile"
    And the response property "$[0].name" value is equal to the request body property "$.name"

  @qos_profiles_retrieveQoSProfiles_03_filter_by_status_only
  Scenario Outline: Retrieve QoS profiles only by status
    Given the request body property "$.status" is set to the value <status>
    And the request body properties "$.device" and "$.name" are not included
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the the response array, if any, complies with the OAS schema at "/components/schemas/QosProfile"
    And each item of the the response array, if any, has property "$[*].status" equal to <status>

    Examples:
      | status     |
      | ACTIVE     |
      | INACTIVE   |
      | DEPRECATED |

  @qos_profiles_retrieveQoSProfiles_04_return_restricted_profiles
  Scenario: Return QoS Profiles restricted to certain devices
    Given that implementation has QoS Profiles restricted to certain devices
    And a device suitable for the restricted QoS Profiles is provided in the request body or identified by the access token
    And the request body properties "$.name" and "$.status" are not included
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the the response array complies with the OAS schema at "/components/schemas/QosProfile"
    And the restricted QoS Profiles is returned in the response

  @qos_profiles_retrieveQoSProfiles_05_not_return_restricted_profiles
  Scenario: Do not return restricted QoS Profiles restricted to certain devices
    Given that implementation has QoS Profiles restricted to certain devices
    And no device is provided in the request body or identified by the access token
    And the request body properties "$.name" and "$.status" are not included
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the the response array complies with the OAS schema at "/components/schemas/QosProfile"
    And no restricted QoS Profile is included in the response

  @qos_profiles_retrieveQoSProfiles_06_device_qos_profiles_not_found
  Scenario: Device has not QoS profiles associated
    Given a device for which the service is not applicable, provided in the request body or identified by the access token
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is []

  # Common error scenarios for management of input parameter device

  @qos_profiles_retrieveQoSProfiles_C01.01_device_empty
  Scenario: The device value is an empty object
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is set to: {}
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_retrieveQoSProfiles_C01.02_device_identifiers_not_schema_compliant
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
  @qos_profiles_retrieveQoSProfiles_C01.03_device_not_found
  Scenario: Some identifier cannot be matched to a device
    Given the header "Authorization" is set to a valid access token which does not identify a single device
    And the request body property "$.device" is compliant with the schema but does not identify a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_retrieveQoSProfiles_C01.04_unnecessary_device
  Scenario: Device not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a device
    And the request body property "$.device" is set to a valid device
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user-friendly text

  @qos_profiles_retrieveQoSProfiles_C01.06_unsupported_device
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
  @qos_profiles_retrieveQoSProfiles_C01.07_device_not_supported
  Scenario: Service not available for the device
    Given that the service is not available for all devices commercialized by the operator
    And a valid device, identified by the token or provided in the request body, for which the service is not applicable
    When the HTTP "POST" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user-friendly text

  # Errors 400

  @qos_profiles_retrieveQoSProfiles_400.1_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is set to any value which is not compliant with the schema at "/components/schemas/QosProfileDeviceRequest"
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_retrieveQoSProfiles_400.2_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @qos_profiles_retrieveQoSProfiles_401.1_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    And the request body is set to a valid request body
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @qos_profiles_retrieveQoSProfiles_401.2_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_retrieveQoSProfiles_401.3_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 403 errors

  @qos_profiles_retrieveQoSProfiles_403.1_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope qos-profiles:read
    When the request "retrieveQoSProfiles" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text