Feature: CAMARA Quality On Demand API, vwip - Operation retrieveSessionsByDevice
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    # * List of device identifier types which are not supported, among: phoneNumber, ipv4Address, ipv6Address.
    #   For this version, CAMARA does not allow the use of networkAccessIdentifier, so it is considered by default as not supported.
    #
    # Testing assets:
    # * A device object applicable for Quality On Demand service with an QoS Sessions associated, and the request properties used for createSession
    # * A device object applicable for Quality On Demand service with NO QoS Sessions associated
    # * A device object identifying a device commercialized by the implementation for which the service is not applicable, if any.
    #
    # References to OAS spec schemas refer to schemas specifies in quality-on-demand.yaml, version wip

    Background: Common retrieveSessionsByDevice setup
        Given an environment at "apiRoot"
        And the resource "/quality-on-demand/vwip/retrieve-sessions"
        And the header "Content-Type" is set to "application/json"
        And the header "Authorization" is set to a valid access token
        And the header "x-correlator" is set to a UUID value
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
        And the request body is set by default to a request body compliant with the schema at "/components/schemas/RetrieveSessionsInput"

    # Success scenarios

    @quality_on_demand_retrieveSessionsByDevice_01_get_existing_session_by_device
    Scenario: Get an existing QoD session by device
        Given a valid testing device supported by the service, identified by the token or provided in the request body, with QoS active sessions associated
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 200
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/RetrieveSessionsOutput"
        # Additionally any success response has to comply with some constraints beyond the schema compliance
        And the response property "$.device" exists only if provided for createSession and with the same value
        And the response property "$.applicationServer" has the same value as in the request body
        And the response property "$.qosProfile" has the value provided for createSession
        And the response property "$.devicePorts" exists only if provided for createSession and with the same value
        And the response property "$.applicationServerPorts" exists only if provided for createSession and with the same value
        And the response property "$.sink" exists only if provided for createSession and with the same value
        # sinkCredentials not explicitly mentioned to be returned if present, as this is debatible for security concerns
        And the response property "$.startedAt" exists only if "$.qosStatus" is "AVAILABLE" and the value is in the past
        And the response property "$.expiresAt" exists only if "$.qosStatus" is not "REQUESTED" and the value is later than "$.startedAt"
        And the response property "$.statusInfo" exists only if "$.qosStatus" is "UNAVAILABLE"

    @quality_on_demand_retrieveSessionsByDevice_02_sessions_not_found
    Scenario: Device has not QoS sessions
        # Valid testing device and default request body compliant with the schema
        Given a valid testing device supported by the service, identified by the token or provided in the request body with no QoS active sessions associated
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 200
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response body is []

    # Common error scenarios for management of input parameter device

    @quality_on_demand_retrieveSessionsByDevice_C01.01_device_empty
    Scenario: The device value is an empty object
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" is set to: {}
        When the HTTP "POST" request is sent
        Then the response status code is 400
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text


    @quality_on_demand_retrieveSessionsByDevice_C01.02_device_identifiers_not_schema_compliant
    Scenario Outline: Some device identifier value does not comply with the schema
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
        When the HTTP "POST" request is sent
        Then the response status code is 400
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text
        
        Examples:
            | device_identifier          | oas_spec_schema                             |
            | $.device.phoneNumber       | /components/schemas/PhoneNumber             |
            | $.device.ipv4Address       | /components/schemas/DeviceIpv4Addr          |
            | $.device.ipv6Address       | /components/schemas/DeviceIpv6Address       |
            | $.device.networkIdentifier | /components/schemas/NetworkAccessIdentifier |

  
    # This scenario may happen e.g. with 2-legged access tokens, which do not identify a single device.
    @quality_on_demand_retrieveSessionsByDevice_C01.03_device_not_found
    Scenario: Some identifier cannot be matched to a device
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" is compliant with the schema but does not identify a valid device
        When the HTTP "POST" request is sent
        Then the response status code is 404
        And the response property "$.status" is 404
        And the response property "$.code" is "IDENTIFIER_NOT_FOUND"
        And the response property "$.message" contains a user friendly text


    @quality_on_demand_retrieveSessionsByDevice_C01.04_unnecessary_device
    Scenario: Device not to be included when it can be deduced from the access token
        Given the header "Authorization" is set to a valid access token identifying a device
        And the request body property "$.device" is set to a valid device
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
        And the response property "$.message" contains a user-friendly text


    @quality_on_demand_retrieveSessionsByDevice_C01.05_missing_device
    Scenario: Device not included and cannot be deduced from the access token
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And the request body property "$.device" is not included
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "MISSING_IDENTIFIER"
        And the response property "$.message" contains a user-friendly text


    @quality_on_demand_retrieveSessionsByDevice_C01.06_unsupported_device
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
    @quality_on_demand_retrieveSessionsByDevice_C01.07_device_not_supported
    Scenario: Service not available for the device
        Given that the service is not available for all devices commercialized by the operator
        And a valid device, identified by the token or provided in the request body, for which the service is not applicable
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
        And the response property "$.message" contains a user-friendly text


    # Several identifiers provided but they do not identify the same device
    # This scenario may happen with 2-legged access tokens, which do not identify a device
    @quality_on_demand_retrieveSessionsByDevice_C01.08_device_identifiers_mismatch
    Scenario: Device identifiers mismatch
        Given the header "Authorization" is set to a valid access token which does not identify a single device
        And at least 2 types of device identifiers are supported by the implementation
        And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
        When the HTTP "POST" request is sent
        Then the response status code is 422
        And the response property "$.status" is 422
        And the response property "$.code" is "IDENTIFIER_MISMATCH"
        And the response property "$.message" contains a user friendly text

    # Errors 400

    @quality_on_demand_retrieveSessionsByDevice_400.1_schema_not_compliant
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the request body is set to any value which is not compliant with the schema at "/components/schemas/retrieveSessionsByDevice"
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_retrieveSessionsByDevice_400.2_no_request_body
    Scenario: Missing request body
        Given the request body is not included
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_retrieveSessionsByDevice_400.3_empty_request_body
    Scenario: Empty object as request body
        Given the request body is set to {}
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Generic 401 errors

    @quality_on_demand_retrieveSessionsByDevice_401.1_no_authorization_header
    Scenario: Error response for no header "Authorization"
        Given the header "Authorization" is not sent
        And the request body is set to a valid request body
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
    @quality_on_demand_retrieveSessionsByDevice_401.2_expired_access_token
    Scenario: Error response for expired access token
        Given the header "Authorization" is set to an expired access token
        And the request body is set to a valid request body
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_retrieveSessionsByDevice_401.3_invalid_access_token
    Scenario: Error response for invalid access token
        Given the header "Authorization" is set to an invalid access token
        And the request body is set to a valid request body
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # Errors 403

    @quality_on_demand_retrieveSessionsByDevice_403.1_missing_access_token_scope
    Scenario: Missing access token scope
        Given the header "Authorization" is set to an access token that does not include scope qod-provisioning:device-qos:retrieve-by-device
        When the request "retrieveSessionsByDevice" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "PERMISSION_DENIED"
        And the response property "$.message" contains a user friendly text

