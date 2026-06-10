Feature: CAMARA QoS Profiles API, vwip - Operation getQosProfile
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * The name of an existing QoS profile
  #
  # References to OAS spec schemas refer to schemas specified in qos-profiles.yaml,
  # unless the path points to "../common/CAMARA_common.yaml", in which case the
  # schema is the one synced from CAMARA Commonalities.

  Background: Common getQosProfile setup
    Given an environment at "apiRoot"
    And the resource "/qos-profiles/vwip/qos-profiles/{name}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "../common/CAMARA_common.yaml#/components/schemas/XCorrelator"
    And the path param "name" is set by default to an existing QoS profile name

  ############################ Happy Path Scenarios #############################################

  @qos_profiles_getQosProfile_01_generic_success_scenario
  Scenario: Common validations for any success scenario
    # Valid testing device and default request body compliant with the schema
    Given an existing QoS profile
    And the path parameter "name" is set to the value for that QoS profile
    When the request "getQosProfile" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the response array complies with the OAS schema at "/components/schemas/QosProfile"
    And the response property "$.name" value is equal to path param "name"
    # TBC: Add additional constraints, such as max* properties must be higher than min* equivalent properties, etc

  ############################ Error Scenarios #############################################

  # Syntax Error scenarios

  @qos_profiles_getQosProfile_400.01_name_does_not_match_regex
  Scenario: Path parameter name doesn't match the defined regular expression
    Given path parameter "name" does not match the regular expression "^[a-zA-Z0-9_.-]+$"
    When the request "getQosProfile" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_getQosProfile_400.02_invalid_name_length
  Scenario: Path parameter name has an invalid length
    Given path parameter "name" has a length not between 3 and 256
    When the request "getQosProfile" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_getQosProfile_400.03_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "../common/CAMARA_common.yaml#/components/schemas/XCorrelator"
    When the request "getQosProfile" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  # Service Error scenarios

  ## Authentication/Authorization errors

  # Generic 401 errors

  @qos_profiles_getQosProfile_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "getQosProfile" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # In this case both codes could make sense depending on whether the access token can be refreshed or not
  @qos_profiles_getQosProfile_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "getQosProfile" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @qos_profiles_getQosProfile_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "getQosProfile" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 403 errors

  @qos_profiles_getQosProfile_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "qos-profiles:read"
    When the request "getQosProfile" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  # Generic 404 errors

  @qos_profiles_getQosProfile_404.01_not_found
  Scenario: name of a non-existing QoS profile
    Given the path parameter "name" is set to a random string compliant with the pattern
    When the request "getQosProfile" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 429 errors

  @qos_profiles_getQosProfile_429.01_too_many_requests
  # To test this scenario the environment has to be configured to reject requests reaching the threshold limit set.
  Scenario: Request is rejected due to threshold policy
    Given a valid request for "getQosProfile"
    And the header "Authorization" is set to a valid access token
    And the threshold of requests has been reached
    When the request "getQosProfile" is sent
    Then the response status code is 429
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text
