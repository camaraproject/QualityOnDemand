# Changelog QualityOnDemand

<!-- TOC:START -->
## Table of Contents
- [r4.1](#r41)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

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

