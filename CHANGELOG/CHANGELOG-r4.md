# Changelog QualityOnDemand

<!-- TOC:START -->
## Table of Contents
- **[r4.3](#r43)**
- [r4.2](#r42)
- [r4.1](#r41)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r4.3

## Release Notes

This public release contains the definition and documentation of
* qos-provisioning 0.4.0
* quality-on-demand 1.2.0

The API definition(s) are based on
* Commonalities r4.4 (0.9.0)
* Identity and Consent Management r4.2 (0.5.0)

The qos-profiles API is no longer part of this repository. It is maintained and released in the [QoSProfiles](https://github.com/camaraproject/QoSProfiles) repository; its last public release from this repository was qos-profiles 1.1.0 in r3.2, followed by the release candidate 1.2.0-rc.3 in r4.1.

## qos-provisioning 0.4.0

**qos-provisioning 0.4.0 is an initial public version of this API.**

Changes documented below are compared to version 0.3.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.3/code/API_definitions/qos-provisioning.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.3/code/API_definitions/qos-provisioning.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.3/code/API_definitions/qos-provisioning.yaml)

### Breaking changes

* `sinkCredential.credentialType` now accepts `ACCESSTOKEN` and `PRIVATE_KEY_JWT`; `PLAIN` and `REFRESHTOKEN` are no longer accepted, by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580
  * API consumers that followed the 0.3.0 definition are not affected: it already required `credentialType` to be `ACCESSTOKEN`.

### Added

* `PRIVATE_KEY_JWT` as sink credential type for notifications, with the `422 PRIVATE_KEY_JWT_NOT_CONFIGURED` error when no JWK Set was pre-shared with the API provider, by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580

### Changed

* Aligned with CAMARA Commonalities r4.4 (0.9.0) by @jlurien and @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/580 and https://github.com/camaraproject/QualityOnDemand/pull/619
  * QoS status change notifications follow the common CloudEvents model
  * Request inputs carry explicit length and range limits, e.g. `x-correlator` (256 characters), `assignmentId` (36), device identifiers and `sink` (2048); `device.ipv4Address.publicPort` must be at least 1 (`0` was allowed before but is not a usable port). No request that conforms to the documented semantics is rejected
  * `accessToken` and `accessTokenType` of `sinkCredential` are write-only: they are accepted in requests and no longer returned in responses
  * Added the info.description sections on authorization and authentication, additional error responses and request body strictness
* Clarified that retrieving or revoking a QoS assignment requires an access token for the same API client and, for three-legged tokens, the same subject as was used to create the assignment, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/623
* Clarified the definition of a QoS Profile and how it is selected by name (`qosProfile`); the `qos-profiles` API is now referenced in the QoSProfiles repository, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/642
* Aligned the test definitions with the Commonalities r4.4 test template, by @jlurien and @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/580 and https://github.com/camaraproject/QualityOnDemand/pull/619
* Added test scenarios for request body strictness (`createQosAssignment`, `getQosAssignmentByDevice`) and for creating a QoS assignment with a `PRIVATE_KEY_JWT` sink credential, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/650

### Fixed

* The `data` object of `org.camaraproject.qos-provisioning.v0.status-changed` events now lists `status` as required property, matching the actual property name (was `qosStatus`), by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580
* Removed the redundant `format: string` from the `QosProfileName` schema by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/549
* Editorial corrections in the API description by @Kevsy, @tlohmar and @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/515, https://github.com/camaraproject/QualityOnDemand/pull/547 and https://github.com/camaraproject/QualityOnDemand/pull/595

### Removed

* The `PLAIN` and `REFRESHTOKEN` sink credential types and the `PlainCredential` and `RefreshTokenCredential` schemas by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580 (see Breaking changes)

## quality-on-demand 1.2.0

**quality-on-demand 1.2.0 is a minor update of this API.**

Changes documented below are compared to version 1.1.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.3/code/API_definitions/quality-on-demand.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.3/code/API_definitions/quality-on-demand.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.3/code/API_definitions/quality-on-demand.yaml)

### Breaking changes

* `sinkCredential.credentialType` now accepts `ACCESSTOKEN` and `PRIVATE_KEY_JWT`; `PLAIN` and `REFRESHTOKEN` are no longer accepted, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579
  * API consumers that followed the 1.1.0 definition are not affected: it already required `credentialType` to be `ACCESSTOKEN`.

### Added

* Application servers can be identified by a list of up to 16 single IPv4 and/or IPv6 addresses, in addition to a subnet, by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/522 and https://github.com/camaraproject/QualityOnDemand/pull/587
* `PRIVATE_KEY_JWT` as sink credential type for notifications, with the `422 PRIVATE_KEY_JWT_NOT_CONFIGURED` error on `createSession` when no JWK Set was pre-shared with the API provider, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579

### Changed

* A `qosProfile` that matches the `QosProfileName` schema but does not exist now returns `404 NOT_FOUND` on `createSession`; `400 INVALID_ARGUMENT` remains for names that do not match the schema. The 1.1.0 test definitions expected `400 INVALID_ARGUMENT` in both cases, by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/637
* `createSession` may return `201` with `qosStatus` `UNAVAILABLE` and `statusInfo` `NETWORK_TERMINATED` when the network determines during creation that the requested QoS cannot be provided, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/576
* Error responses list only the codes that can occur for each operation, by @maxl2287 and @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/578 and https://github.com/camaraproject/QualityOnDemand/pull/622
  * the `400` response of `getSession` and `deleteSession` returns only `INVALID_ARGUMENT` (no longer `OUT_OF_RANGE`)
  * the `404` response of `retrieveSessionsByDevice` returns only `IDENTIFIER_NOT_FOUND` (no longer `NOT_FOUND`)
* Aligned with CAMARA Commonalities r4.4 (0.9.0) by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579 and https://github.com/camaraproject/QualityOnDemand/pull/619
  * QoS status change notifications follow the common CloudEvents model
  * Request inputs carry explicit length and range limits, e.g. `x-correlator` (256 characters), `sessionId` (36), device identifiers, `sink` (2048) and port lists. Port numbers must be at least 1 (`0` was allowed before but is not a usable port). `duration` and `requestedAdditionalDuration` are bounded only by the 32-bit integer range; the effective limit is the `maxDuration` of the QoS Profile. No request that conforms to the documented semantics is rejected. The `retrieveSessionsByDevice` response returns at most 100 sessions
  * `accessToken` and `accessTokenType` of `sinkCredential` are write-only: they are accepted in requests and no longer returned in responses
  * Added the info.description sections on authorization and authentication, additional error responses and request body strictness
* Clarified that retrieving, extending or deleting a QoS session requires an access token for the same API client and, for three-legged tokens, the same subject as was used to create the session, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/623
* Clarified the definition of a QoS Profile, that the session applies the characteristics of the selected QoS Profile, and that the `qos-profiles` API is now in the QoSProfiles repository, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/642
* Aligned the test definitions with the Commonalities r4.4 test template, adding `429`, invalid `x-correlator` and application server list scenarios, by @hdamker and @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/579, https://github.com/camaraproject/QualityOnDemand/pull/587 and https://github.com/camaraproject/QualityOnDemand/pull/619
* Added test scenarios for request body strictness (`createSession`, `extendQosSessionDuration`, `retrieveSessionsByDevice`) and for creating a QoS session with a `PRIVATE_KEY_JWT` sink credential, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/650

### Fixed

* Added explicit response examples for `extendQosSessionDuration` by @mohdfarhanakram in https://github.com/camaraproject/QualityOnDemand/pull/538
* Removed the redundant `format: string` from the `QosProfileName` schema by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/549
* Editorial corrections in the API description (consistent use of "API consumer" and "QoS Session", removed a redundant sentence on authentication) by @tlohmar and @AxelNennker in https://github.com/camaraproject/QualityOnDemand/pull/547, https://github.com/camaraproject/QualityOnDemand/pull/574 and https://github.com/camaraproject/QualityOnDemand/pull/551
* Corrected the event type expected by the `createSession` and `deleteSession` event test scenarios to `org.camaraproject.quality-on-demand.v1.qos-status-changed` (was `org.camaraproject.qod.v1.qos-status-changed`), by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/649

### Removed

* The `PLAIN` and `REFRESHTOKEN` sink credential types and the `PlainCredential` and `RefreshTokenCredential` schemas by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579 (see Breaking changes)

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/r3.2...r4.3

# r4.2

## Release Notes

This release candidate contains the definition and documentation of
* qos-provisioning 0.4.0-rc.2
* quality-on-demand 1.2.0-rc.4

The API definition(s) are based on
* Commonalities r4.4 (0.9.0)
* Identity and Consent Management r4.2 (0.5.0)

## qos-provisioning 0.4.0-rc.2

**qos-provisioning 0.4.0-rc.2 is a release-candidate version of this API.**

Changes documented below are compared to version 0.4.0-rc.1.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.2/code/API_definitions/qos-provisioning.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.2/code/API_definitions/qos-provisioning.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.2/code/API_definitions/qos-provisioning.yaml)

### Breaking changes

* N/A

### Added

* N/A

### Changed

* N/A

### Fixed

* Align quality-on-demand and qos-provisioning with Commonalities r4.4 by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/619
  * Fix schema reference notation in feature files
* docs: align session access NOTES with Design Guide section 6.7 by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/623
  * Clarify that, for assignment retrieval or deletion, the access token must identify the same API client and, if 3-legged, the same subject as was used to create the assignment

### Removed

* N/A

## quality-on-demand 1.2.0-rc.4

**quality-on-demand 1.2.0-rc.4 is a release-candidate version of this API.**

Changes documented below are compared to version 1.2.0-rc.3.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.2/code/API_definitions/quality-on-demand.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.2/code/API_definitions/quality-on-demand.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.2/code/API_definitions/quality-on-demand.yaml)

### Breaking changes

* N/A

### Added

* N/A

### Changed

* N/A

### Fixed

* Align quality-on-demand and qos-provisioning with Commonalities r4.4 by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/619
  * Fix schema reference notation in feature files
* docs: align session access NOTES with Design Guide section 6.7 by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/623
  * Clarify that, for session retrieval, modification or deletion, the access token must identify the same API client and, if 3-legged, the same subject as was used to create the session

### Removed

* Replace DeviceNotFound404 error with common IdentifierNotFound404 for operation retrieveSessionsByDevice by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/622
  * Remove the 404 NOT_FOUND error as a possibility for POST /retrieve-sessions

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/r4.1...r4.2

# r4.1

## Release Notes

This release candidate contains the definition and documentation of
* qos-profiles 1.2.0-rc.3
* qos-provisioning 0.4.0-rc.1
* quality-on-demand 1.2.0-rc.3

The API definition(s) are based on
* Commonalities r4.3 (0.8.0)
* Identity and Consent Management r4.2 (0.5.0)

## qos-profiles 1.2.0-rc.3

**qos-profiles 1.2.0-rc.3 is a release-candidate version of this API.**

Changes documented below are compared to version 1.1.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.1/code/API_definitions/qos-profiles.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.1/code/API_definitions/qos-profiles.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.1/code/API_definitions/qos-profiles.yaml)

### Breaking changes

* N/A

### Added

* N/A

### Changed

* Aligned the API and its test definitions with CAMARA Commonalities r4.3 (0.8.0) by @RandyLevensalor in https://github.com/camaraproject/QualityOnDemand/pull/575
  * Common definitions are reused via `$ref` into `code/common/CAMARA_common.yaml` (`openId`, `x-correlator`, `Device`, `ErrorInfo`, and the generic 400/401/404/429 error responses); the 403, 404 and 422 responses of this API remain local code subsets, as the common definitions list codes that cannot occur here
  * Added the mandatory `info.description` sections (authorization and authentication, additional error responses, request body strictness) and set `x-camara-commonalities` to `0.8.0`
  * Added `maxLength` and `maxItems` constraints to `QosProfile.description`, `Availability` and its `networks` array, `countryName`, and the `retrieveQoSProfiles` 200 response array
  * Aligned both test definition files with the r4.3 sample service template and added `429` and invalid `x-correlator` scenarios

### Fixed

* Corrected the `targetMinDownstreamRate` description by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/543
* Removed the redundant `format: string` from the `QosProfileName` schema by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/549
* Standardized on the term `API consumer` (replacing `developer`) throughout the API description by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/547
* Used the term `QoS Session` systematically throughout the API description by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/574

### Removed

* N/A

## qos-provisioning 0.4.0-rc.1

**qos-provisioning 0.4.0-rc.1 is a release-candidate version of this API.**

Changes documented below are compared to version 0.3.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.1/code/API_definitions/qos-provisioning.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.1/code/API_definitions/qos-provisioning.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.1/code/API_definitions/qos-provisioning.yaml)

### Breaking changes

* The sink credential model is narrowed from `PLAIN`, `ACCESSTOKEN`, `REFRESHTOKEN` to `ACCESSTOKEN`, `PRIVATE_KEY_JWT`, following `SinkCredential` in `CAMARA_event_common.yaml` of Commonalities r4.3, by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580
  * Listed for awareness: the `PLAIN` and `REFRESHTOKEN` values, and the `PlainCredential` and `RefreshTokenCredential` schemas, were part of the published 0.3.0 schema and are no longer accepted.
  * A previously compliant API consumer is not affected. The 0.3.0 definition already stated that `sinkCredential.credentialType` MUST be set to `ACCESSTOKEN`, so no well-behaving client sent the removed values. Assessed against the previous public API contract, as required by the CAMARA API Design Guide, the change does not restrict well-behaving clients.

### Added

* Added the `PRIVATE_KEY_JWT` sink credential type and the corresponding `PRIVATE_KEY_JWT_NOT_CONFIGURED` 422 error code by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580

### Changed

* Aligned the API and its test plan with CAMARA Commonalities r4.3 (0.8.0) by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580
  * `Device`, `DeviceResponse`, `ErrorInfo`, the `x-correlator` parameter and header, and the generic error responses are reused via `$ref` into `code/common/CAMARA_common.yaml`; the API-specific `CreateAssignment400`, `AssignmentConflict409` and `CreateAssignment422` responses remain local
  * `CloudEvent`, `SinkCredential` and `AccessTokenCredential` are reused via `$ref` into `code/common/CAMARA_event_common.yaml`, with the event expressed as a CloudEvent subtype carrying its own event type enum
  * Added the mandatory `info.description` sections (authorization and authentication, additional error responses, request body strictness) and set `x-camara-commonalities` to `0.8.0`
  * Added `maxLength` constraints to `AssignmentId`, `BaseAssignmentInfo.sink` and `AssignmentInfo.startedAt`

### Fixed

* Corrected the required property of `EventStatusChanged.data` from `qosStatus` to `status`, matching the actual property name, by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580
* Added the missing `type` on the `CloudEvent` and `Status` schemas by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/555
* Removed the redundant `format: string` from the `QosProfileName` schema by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/549
* Corrected the typo "ssignment" to "assignment" by @Kevsy in https://github.com/camaraproject/QualityOnDemand/pull/515
* Standardized on the term `API consumer` (replacing `developer`) throughout the API description by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/547
* Corrected the `externalDocs.description` wording by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/595

### Removed

* Removed the `PlainCredential` and `RefreshTokenCredential` schemas and the `PLAIN` and `REFRESHTOKEN` credential types by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/580 (see breaking changes above)

## quality-on-demand 1.2.0-rc.3

**quality-on-demand 1.2.0-rc.3 is a release-candidate version of this API.**

Changes documented below are compared to version 1.1.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.1/code/API_definitions/quality-on-demand.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r4.1/code/API_definitions/quality-on-demand.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/r4.1/code/API_definitions/quality-on-demand.yaml)

### Breaking changes

* The sink credential model is narrowed from `PLAIN`, `ACCESSTOKEN`, `REFRESHTOKEN` to `ACCESSTOKEN`, `PRIVATE_KEY_JWT`, following `SinkCredential` in `CAMARA_event_common.yaml` of Commonalities r4.3, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579
  * Listed for awareness: the `PLAIN` and `REFRESHTOKEN` values, and the `PlainCredential` and `RefreshTokenCredential` schemas, were part of the published 1.1.0 schema and are no longer accepted.
  * A previously compliant API consumer is not affected. The 1.1.0 definition already stated that `sinkCredential.credentialType` MUST be set to `ACCESSTOKEN`, so no well-behaving client sent the removed values. Assessed against the previous public API contract, as required by the CAMARA API Design Guide, the change does not restrict well-behaving clients.

### Added

* Allowed application servers to be identified by a list of single IPv4 and IPv6 addresses, in addition to a contiguous set of addresses within a subnet, and added test cases for it, by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/522 and https://github.com/camaraproject/QualityOnDemand/pull/587
* Added the `PRIVATE_KEY_JWT` sink credential type and the corresponding `PRIVATE_KEY_JWT_NOT_CONFIGURED` 422 error code on `createSession` by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579

### Changed

* Aligned the API and its test definitions with CAMARA Commonalities r4.3 (0.8.0) by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579
  * `openId`, `x-correlator`, `Device`, `DeviceResponse`, `ErrorInfo` and the generic error responses are reused via `$ref` into `code/common/`; the API-specific code subset error responses remain local
  * Added the mandatory `info.description` sections (authorization and authentication, additional error responses, request body strictness) and set `x-camara-commonalities` to `0.8.0`
  * Added `maxLength`, `maxItems`, `minimum`, `maximum`, `format` and `pattern` constraints to the remaining local schemas. `duration` intentionally keeps no API level maximum, as the limit is the `maxDuration` of the QoS Profile
  * Aligned the QoS status change notifications to the CloudEvents model, consuming the shared `CloudEvent` and `SinkCredential` from `code/common/CAMARA_event_common.yaml`
  * The `sinkCredential.credentialType` enum is narrowed to `ACCESSTOKEN` and `PRIVATE_KEY_JWT` (see breaking changes above)
  * `Port` now references the common schema with `minimum: 1`; the previous local copy allowed `0`, which is not a usable flow port. Assessed against the previous public API contract, this makes a domain-limited bound machine-readable and rejects no request a well-behaving client would send
  * Aligned the five test definition files, adding `429` and invalid `x-correlator` scenarios
* Added dedicated 400 error responses for `getSession` and `deleteSession`, so that error codes which cannot occur on those operations are no longer documented, by @maxl2287 in https://github.com/camaraproject/QualityOnDemand/pull/578
* Clarified that `createSession` may return `201` with `qosStatus` `UNAVAILABLE` and `statusInfo` `NETWORK_TERMINATED` when the network determines during session creation that the requested QoS cannot be provided, and broadened the `NETWORK_TERMINATED` description accordingly, by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/576

### Fixed

* Added explicit response examples for the extend session endpoint by @mohdfarhanakram in https://github.com/camaraproject/QualityOnDemand/pull/538
* Added the missing `type` on the `CloudEvent` schema by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/555
* Removed the redundant `format: string` from the `QosProfileName` schema by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/549
* Standardized on the term `API consumer` (replacing `developer`) throughout the API description by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/547
* Used the term `QoS Session` systematically throughout the API description by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/574
* Removed a redundant sentence on authentication, which is covered by the dedicated section, by @AxelNennker in https://github.com/camaraproject/QualityOnDemand/pull/551

### Removed

* Removed the `PlainCredential` and `RefreshTokenCredential` schemas and the `PLAIN` and `REFRESHTOKEN` credential types by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/579 (see breaking changes above)

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/r3.2...r4.1

