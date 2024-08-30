Feature: CAMARA Quality On Demand API, v0.11.0 - Operation createSession
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    # * List of device identifier types which are not supported, among: phoneNumber, ipv4Address, ipv6Address.
    #   For this version, CAMARA does not allow the use of networkAccessIdentifier, so it is considered by default as not supported.
    # * List of application server ip formats which are not supported, among ipv4 and ipv6.
    #
    # Testing assets:
    # * A device object applicable for Quality On Demand service.
    # * A device object identifying a device commercialized by the implementation for which the service is not applicable, if any.
    #
    # References to OAS spec schemas refer to schemas specifies in quality-on-demand.yaml, version 0.11.0

    Background: Common createSession setup
        Given an environment at "apiRoot"
        And the resource "/quality-on-demand/v0.11/sessions"
        And the header "Content-Type" is set to "application/json"
        And the header "Authorization" is set to a valid access token
        And the header "x-correlator" is set to a UUID value
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
        And the request body is set by default to a request body compliant with the schema at "/components/schemas/CreateSession"

    # Success scenarios

    @quality_on_demand_createSession_01_generic_success_scenario
    Scenario: Common validations for any sucess scenario
        # Valid testing device and default request body compliant with the schema
        Given a valid testing device supported by the service, identified by the token or provided in the request body
        And the request body property "$.applicationServer" is set to a valid application server
        And the request property "$.qosProfile" is set to a valid QoS Profile as returned by QoS Profiles API
        And the request body property "$.duration" is set to a valid duration for the selected QoS profile
        When the request "createSession" is sent
        Then the response status code is 201
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        # The response has to comply with the generic response schema which is part of the spec
        And the response body complies with the OAS schema at "/components/schemas/SessionInfo"
        # Additionally any success response has to comply with some constraints beyond the schema compliance
        And the response property "$.device" exists only if provided in the request body and with the same value
        And the response property "$.applicationServer" has the same value as in the request body
        And the response property "$.qosProfile" has the same value as in the request body
        And the response property "$.devicePorts" exists only if provided in the request body and with the same value
        And the response property "$.applicationServerPorts" exists only if provided in the request body and with the same value
        And the response property "$.sink" exists only if provided in the request body and with the same value
        # sinkCredentials not explicitly mentioned to be returned if present, as this is debatible for security concerns
        And the response property "$.startedAt" exists only if "$.qosStatus" is "AVAILABLE" and the value is in the past
        And the response property "$.expiresAt" exists only if "$.qosStatus" is not "REQUESTED" and the value is later than "$.startedAt"
        And the response property "$.statusInfo" exists only if "$.qosStatus" is "UNAVAILABLE"

    @quality_on_demand_createSession_02_event_notification
    Scenario: Events are received after a QoS session change if sink is provided
        # Valid testing device and default request body compliant with the schema
        Given a valid testing device supported by the service, identified by the token or provided in the request body
        And the request body property "$.applicationServer" is set to a valid application server
        And the request property "$.qosProfile" is set to a valid QoS Profile as returned by QoS Profiles API
        And the request body property "$.duration" is set to a valid duration for the selected QoS profile
        And the request property "$.sink" is set to a URL when events can be monitored
        And the request property "$.sinkCredentials.credentialType" is set to "ACCESSTOKEN"
        And the request property "$.sinkCredentials.accessTokenType" is set to "bearer"
        And the request property "$.sinkCredentials.accessToken" is set to a valid access token accepted by the events receiver
        When the request "createSession" is sent
        Then the response status code is 201
        # There is no specific limit defined for the process to end
        And an event is received at the address of the request property "$.sink"
        And the event header "Authorization" is set to "Bearer: " + the value of the request property "$.sinkCredentials.accessToken"
        And the event header "Content-Type" is set to "application/cloudevents+json"
        And the event body complies with the OAS schema at "/components/schemas/EventQosStatusChanged"
        # Additionally any event body has to comply with some constraints beyond the schema compliance
        And the event body property "$.id" is unique
        And the event body property "$.type" is set to "org.camaraproject.qod.v0.qos-status-changed"
        And the event body property "$.data.sessionId" has the same value as createSession response property "$.sessionId"
        And the event body property "$.data.qosStatus" is "AVAILABLE" or "UNAVAILABLE"
        And the event body property "$.data.statusInfo" exists only if "$.data.qosStatus" is "UNAVAILABLE"

    @quality_on_demand_createSession_03_3_legged_missing_device
    Scenario: Device is not returned if not included in the creation
        # Valid testing device and default request body compliant with the schema
        Given the header "Authorization" is set to a valid 3-legged access token associated to a valid testing device supported by the service
        And the request property "$.device" is not included
        When the request "createSession" is sent
        Then the response status code is 201
        And the response header "Content-Type" is "application/json"
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response body complies with the OAS schema at "/components/schemas/SessionInfo"
        And the response property "$.device" does not exist

    # Errors 400

    @quality_on_demand_createSession_400.1_schema_not_compliant
    Scenario: Invalid Argument. Generic Syntax Exception
        Given the request body is set to any value which is not compliant with the schema at "/components/schemas/CreateSession"
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_400.2_no_request_body
    Scenario: Missing request body
        Given the request body is not included
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_400.3_empty_request_body
    Scenario: Empty object as request body
        Given the request body is set to {}
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_400.4_empty_property
    Scenario Outline: Error response for empty property in request body
        Given the request body property "<required_property>" is set to {}
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

        Examples:
            | required_property        |
            | $.device                 |
            | $.applicationServer      |
            | $.devicePorts            |
            | $.applicationServerPorts |
            | $.sinkCredential         |

    @quality_on_demand_createSession_400.5_device_identifiers_not_schema_compliant
    # Test every type of identifier even if not supported by the implementation
    Scenario Outline: Some device identifier value does not comply with the schema
        Given the request body property "<device_identifier>" does not comply with the OAS schema at "<oas_spec_schema>"
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

        Examples:
            | device_identifier          | oas_spec_schema                             |
            | $.device.phoneNumber       | /components/schemas/PhoneNumber             |
            | $.device.ipv4Address       | /components/schemas/NetworkAccessIdentifier |
            | $.device.ipv6Address       | /components/schemas/DeviceIpv4Addr          |
            | $.device.networkIdentifier | /components/schemas/DeviceIpv6Address       |

    # The maximum is considered in the schema so a generic schema validator may fail and generate a 400 INVALID_ARGUMENT without further distinction,
    # and both could be accepted
    @quality_on_demand_createSession_400.6_out_of_range_port
    Scenario Outline: Out of range port
        Given the request body property "<port_property>" is set to a value not between between 0 and 65536
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "OUT_OF_RANGE" or "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

        Examples:
            | port_property                        |
            | $.device.ipv4Address.publicPort      |
            | $.devicePorts.ranges.from            |
            | $.devicePorts.ranges.to              |
            | $.devicePorts.ports[*]               |
            | $.applicationServerPorts.ranges.from |
            | $.applicationServerPorts.ranges.to   |
            | $.applicationServerPorts.ports[*]    |

    # PLAIN and REFRESHTOKEN are considered in the schema so INVALID_ARGUMENT is not expected
    @quality_on_demand_createSession_400.7_invalid_sink_credential
    Scenario Outline: Invalid credential
        Given the request body property  "$.sinkCredential.credentialType" is set to "<unsupported_credential_type>"
        When the request "createSession" is sent
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
    @quality_on_demand_createSession_400.8_sink_credential_invalid_token
    Scenario: Invalid token
        Given the request body property  "$.sinkCredential.accessTokenType" is set to a value other than "bearer"
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_TOKEN" or "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_400.9_non_existent_qos_profile
    Scenario: Error response for invalid qos profile in request body
        Given the request body property "qosProfile" is set to a non existent qos Profile
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_400.10_invalid_duration
    Scenario: Error response when duration is not valid for selected qos profile
        Given the request body property "duration" is set to an invalid duration for the selected qosProfile
        When the request "createSession" is sent
        Then the response status code is 400
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 400
        And the response property "$.code" is "INVALID_ARGUMENT"
        And the response property "$.message" contains a user friendly text

    # Generic 401 errors

    @quality_on_demand_createSession_401.1_no_authorization_header
    Scenario: Error response for no header "Authorization"
        Given the header "Authorization" is not sent
        And the request body is set to a valid request body
        When the request "createSession" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # In this case both codes could make sense depending on whether the access token can be refreshed or not
    @quality_on_demand_createSession_401.2_expired_access_token
    Scenario: Error response for expired access token
        Given the header "Authorization" is set to an expired access token
        And the request body is set to a valid request body
        When the request "createSession" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_401.3_invalid_access_token
    Scenario: Error response for invalid access token
        Given the header "Authorization" is set to an invalid access token
        And the request body is set to a valid request body
        When the request "createSession" is sent
        Then the response status code is 401
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 401
        And the response property "$.code" is "UNAUTHENTICATED"
        And the response property "$.message" contains a user friendly text

    # Errors 403

    @quality_on_demand_createSession_403.1_device_token_mismatch
    Scenario: Inconsistent access token context for the device
        # To test this, a token have to be obtained for a different device
        Given the request body property "$.device" is set to a valid testing device
        And the header "Authorization" is set to a valid access token emitted for a different device
        When the request "createSession" is sent
        Then the response status code is 403
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 403
        And the response property "$.code" is "INVALID_TOKEN_CONTEXT"
        And the response property "$.message" contains a user friendly text

    # Errors 404

    # Typically with a 2-legged access token
    @quality_on_demand_createSession_404.1_device_not_found
    Scenario: Some identifier cannot be matched to a device
        Given that the device cannot be identified from the access token
        And the request body property "$.device" is compliant with the request body schema but does not identify a valid device
        When the request "createSession" is sent
        Then the response status code is 404
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 404
        And the response property "$.code" is "DEVICE_NOT_FOUND"
        And the response property "$.message" contains a user friendly text

    # Errors 409

    @quality_on_demand_createSession_409.1_session_conflict
    Scenario: Session in conflict
        Given a valid testing device supported by the service, identified by the token or provided in the request body
        And a QoD session already exists for that device
        When the request "createSession" is sent
        Then the response status code is 409
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 409
        And the response property "$.code" is "CONFLICT"
        And the response property "$.message" contains a user friendly text

    # Errors 422

    # UNSUPPORTED_DEVICE_IDENTIFIERS is in the Commonalities guidelines (document) but it is not yet considered in the API spec
    @quality_on_demand_createSession_422.1_device_identifiers_unsupported
    Scenario: None of the provided device identifiers is supported by the implementation
        Given that some type of device identifiers are not supported by the implementation
        And the request body property "$.device" only includes device identifiers not supported by the implementation
        When the request "createSession" is sent
        Then the response status code is 422
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 422
        And the response property "$.code" is "UNSUPPORTED_DEVICE_IDENTIFIERS"
        And the response property "$.message" contains a user friendly text

    # This scenario is under discussion
    @quality_on_demand_createSession_422.2_device_identifiers_mismatch
    Scenario: Device identifiers mismatch
        Given that al least 2 types of device identifiers are supported by the implementation
        And the request body property "$.device" includes several identifiers, each of them identifying a valid but different device
        When the request "createSession" is sent
        Then the response status code is 422
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 422
        And the response property "$.code" is "DEVICE_IDENTIFIERS_MISMATCH"
        And the response property "$.message" contains a user friendly text

    @quality_on_demand_createSession_422.3_device_not_supported
    Scenario: Service not available for the device
        Given that service is not supported for all devices commercialized by the operator
        And the service is not applicable for the device identified by the token or provided in the request body
        When the request "createSession" is sent
        Then the response status code is 422
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 422
        And the response property "$.code" is "DEVICE_NOT_APPLICABLE"
        And the response property "$.message" contains a user friendly text

    # Typically with a 2-legged access token
    @quality_on_demand_createSession_422.4_unidentifiable_device
    Scenario: Device not included and cannot be deducted from the access token
        Given the header "Authorization" is set to a valid access which does not identifiy a single device
        And the request body property "$.device" is not included
        When the request "createSession" is sent
        Then the response status code is 422
        And the response header "x-correlator" has same value as the request header "x-correlator"
        And the response header "Content-Type" is "application/json"
        And the response property "$.status" is 422
        And the response property "$.code" is "UNIDENTIFIABLE_DEVICE"
        And the response property "$.message" contains a user friendly text
