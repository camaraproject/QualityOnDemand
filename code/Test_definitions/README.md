This directory contains the `.feature` files with test definitions for the 3 repository API(s).
There is a separate Feature file per API operation.

The test plan has to be enhanced and some scenarios still contains comments and questions to be resolved:

* For port ranges, the maximum is considered in the schema so a generic schema validator may generate a 400 INVALID_ARGUMENT without further distinction, instead of the specific 400 OUT_OF_RANGE, so both could be accepted
* For `sinkCredential.accessTokenType`, only `bearer` is considered in the schema so a generic schema validator may generate a 400 INVALID_ARGUMENT without further distinction, instead of the specific 400 INVALID_TOKEN, so both could be accepted
* When providing a non existent QoS Profile to create a session or provisioning, what code to return? 400 INVALID_ARGUMENT is proposed
* For expired tokens, both codes "UNAUTHENTICATED" or "AUTHENTICATION_REQUIRED" for 401 may be returned, depending on whether the access token can be refreshed or not
* Now that QoS Profiles may be restricted to certain devices, what code to return when the provided device in createSession is not suitable for the provided qosProfile. We may reuse 422 SERVICE_NOT_APPLICABLE
* When providing a path parameter, such sessionId or provisioningId, which is not compliant with the spec format (UUID), what code to return? Options are 400 INVALID_ARGUMENT or 404 NOT_FOUND if path parameter format is not checked previously
* For QoS Profile response validations, it is pending to check additional constraints, such as minDuration being less or equal than maxDuration, etc


