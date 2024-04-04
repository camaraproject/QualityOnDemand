# Changelog QualityOnDemand

## Table of Contents

- **[v0.10.1](#v0101)**
- [v0.10.0](#v0100)
- [v0.10.0-rc2](#v0100-rc2)
- [v0.10.0-rc](#v0100-rc)
- [v0.9.0](#v090)
- [v0.9.0-rc](#v090-rc)
- [v0.8.1](#v081)
- [v0.8.0](#v080)
- [v0.1.0 - Initial contribution](#v010---initial-contribution)

Version numbers 0.2.x to 0.7.x were intentionally not used to avoid conflicts with local implementations.

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

# v0.10.1

** v0.10.1 is a patch release of v0.10.0 of the Quality-On-Demand (QoD) API. Please read also the notes and changes for v0.10.0 release**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.1/code/API_definitions/qod-api.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.1/code/API_definitions/qod-api.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/v0.10.1/code/API_definitions/qod-api.yaml)
 
### Fixed

* Updated the documentation to address the lack of `statusInfo` in `SessionInfo` temporary by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/269
  * Note: The parameter `statusInfo` will be added to `SessionInfo` within next regular release
* Fixed maximum duration in session info and improved documentation by @emil-cheung in https://github.com/camaraproject/QualityOnDemand/pull/277
  * Improved the documentation of "Extend the duration of an active session"
  * Improved the datatype "SessionInfo" to remove the maximum limit of duration

### Further changes within the project

* Added configuration for linting ruleset by @rartych in https://github.com/camaraproject/QualityOnDemand/pull/270
* Updated the project scope in the README.md by @RandyLevensalor in https://github.com/camaraproject/QualityOnDemand/pull/255

# v0.10.0

**This release contains the fourth alpha version of the Quality-On-Demand (QoD) API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.0/code/API_definitions/qod-api.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.0/code/API_definitions/qod-api.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/v0.10.0/code/API_definitions/qod-api.yaml)

### Please note:

- **This release contains significant changes compared to v0.9.0, and the QoD API is not backward compatible**
  - Within notifications the schema `EventNotification`has been replace by `CloudEvent` in accordance with the updated CAMARA Design Guidelines
  - If within `device` an IPv6 address is used it must be a single IPv6 address (out of the prefix used by the device)
- This release includes changes to be compliant with the [Design Guidelines](https://github.com/camaraproject/Commonalities/blob/release-0.2.0/documentation/API-design-guidelines.md#10-security) and other documents in [release v0.2 of CAMARA Commonalities](https://github.com/camaraproject/Commonalities/tree/release-0.2.0)
- This is another v0.x release and further releases before the first stable major v1.x release might introduce breaking changes (e.g. API changes to align with Commonalities updates)

### Main Changes

* Aligned event notification with CloudEvent spec which will allow API consumers and implementators to use standard libraries and tools which are available to handle CloudEvents (https://cloudevents.io/)
* Added a new operation `/sessions/{sessionId}/extend` which allows to extend the duration of an active session 

### Added

* Added new endpoint to extend duration of an active session by @emil-cheung in https://github.com/camaraproject/QualityOnDemand/pull/216
* Introduced of linting with Megalinter and Swagger Editor Validator by @RandyLevensalor, @maxl2287 and @ravindrapalaskar17 in https://github.com/camaraproject/QualityOnDemand/pull/206, https://github.com/camaraproject/QualityOnDemand/pull/207, https://github.com/camaraproject/QualityOnDemand/pull/212, and  https://github.com/camaraproject/QualityOnDemand/pull/215
* Added global tags element  by @rartych in https://github.com/camaraproject/QualityOnDemand/pull/227
* Added a new error example for DurationOutOfRangeForQoSProfile by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/259

### Changed

* Align event notification with CloudEvents spec by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/224
* Moved "description" out of "allOf" declaration by @maxl2287 in https://github.com/camaraproject/QualityOnDemand/pull/205
  * Note: this change shouldn't have an impact for API consumers but is relevant for implementations of the API.
* Single IP addresses in Device model specified with standard formats instead of patterns by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/237
* Moved "basePath" /qod/v0 to "url"-property and introduced "apiroot" in definition of server  @maxl2287 in https://github.com/camaraproject/QualityOnDemand/pull/252
* Added statusInfo 'DELETE_REQUESTED' for qosStatus 'UNAVAILABLE' and clarified notification events in documentation by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/258

### Fixed

* NA
  
### Removed

* NA

## New Contributors
* @ravindrapalaskar17 made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/215
* @rartych made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/227

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.9.0...v0.10.0

# v0.10.0-rc2

**This is the second release candidate of v0.10.0 - containing the upcoming fourth alpha version of the Quality-On-Demand (QoD) API**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.0-rc2/code/API_definitions/qod-api.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.0-rc2/code/API_definitions/qod-api.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/v0.10.0-rc2/code/API_definitions/qod-api.yaml)

## Changes compared to [v0.10.0-rc](#v0100-rc)

* Added a new error example for DurationOutOfRangeForQoSProfile by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/259
* Moved "basePath" /qod/v0 to "url"-property and introduced "apiroot" in definition of server  @maxl2287 in https://github.com/camaraproject/QualityOnDemand/pull/252
* Added a note to maxDuration parameter within qosProfile schema about the limit of 86400 seconds by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/256
* Added statusInfo 'DELETE_REQUESTED' for qosStatus 'UNAVAILABLE' and clarified notification events in documentation by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/258:
  * notifications will be sent for all changes of QosStatus, even if initiated by the client.
  * what will happen when qosStatus changes from 'AVAILABLE' to 'UNAVAILABLE' due to 'NETWORK_TERMINATED'
 
**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.10.0-rc...v0.10.0-rc2

# v0.10.0-rc

**This is the first release candidate of v0.10.0 - containing the upcoming fourth alpha version of the Quality-On-Demand (QoD) API**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.0-rc/code/API_definitions/qod-api.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.10.0-rc/code/API_definitions/qod-api.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/v0.10.0-rc/code/API_definitions/qod-api.yaml)

## Please note:

- **This release will contain significant changes compared to v0.9.0, and it is not backward compatible**
  - Within notifications the schema `EventNotification`has been replace by `CloudEvent` in accordance with the updated CAMARA Design Guidelines
  - If within `device` an IPv6 address is used it must be a single IPv6 address (out of the prefix used by the device)
- **This is only the pre-release, it should be considered as a draft of the upcoming release v0.10.0**
  - The pre-release is meant for implementors, but it is not recommended to use the API with customers in productive environments.

### Main Changes

* Aligned event notification with CloudEvent spec which will allow API consumers and implementators to use standard libraries and tools which are available to handle CloudEvents (https://cloudevents.io/)
* Added a new operation `/sessions/{sessionId}/extend` which allows to extend the duration of an active session 


### Added

* Added new endpoint to extend duration of an active session by @emil-cheung in https://github.com/camaraproject/QualityOnDemand/pull/216
* Introduced of linting with Megalinter and Swagger Editor Validator by @RandyLevensalor, @maxl2287 and @ravindrapalaskar17 in https://github.com/camaraproject/QualityOnDemand/pull/206, https://github.com/camaraproject/QualityOnDemand/pull/207, https://github.com/camaraproject/QualityOnDemand/pull/212, and  https://github.com/camaraproject/QualityOnDemand/pull/215
* Added global tags element  by @rartych in https://github.com/camaraproject/QualityOnDemand/pull/227

### Changed

* Align event notification with CloudEvents spec by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/224
* Moved "description" out of "allOf" declaration by @maxl2287 in https://github.com/camaraproject/QualityOnDemand/pull/205
  * Note: this change shouldn't have an impact for API consumers but is relevant for implementations of the API.
* Aligned with changes in https://github.com/camaraproject/Template_Lead_Repository on test definitions by @rartych in https://github.com/camaraproject/QualityOnDemand/pull/233
* Single IP addresses in Device model specified with standard formats instead of patterns by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/237

### Fixed

* NA
  
### Removed

* NA

## New Contributors
* @ravindrapalaskar17 made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/215
* @rartych made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/227

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.9.0...v0.10.0-rc


# v0.9.0

**This is the third alpha version of the Quality-On-Demand (QoD) API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.9.0/code/API_definitions/qod-api.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/v0.9.0/code/API_definitions/qod-api.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/v0.9.0/code/API_definitions/qod-api.yaml)

## Please note:

- **This release contains significant breaking changes compared to v0.8.1, and it is not backward compatible**
  - Especially a lot of the parameter names changed in line with the agreed glossary within CAMARA Commonalities
- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.

### Added

* Introduced `qosStatus` and corresponding notification event to fix issue #38 by @emil-cheung in https://github.com/camaraproject/QualityOnDemand/pull/67
* Added basic tests with Cucumber framework using Java and Maven implementation by @mdomale in https://github.com/camaraproject/QualityOnDemand/pull/134
* Added new methods to get service provider defined QoS Profile by @RandyLevensalor in https://github.com/camaraproject/QualityOnDemand/pull/138
* Scopes specified and OAuth2 authorizationCode flow added as security mechanism, for operations dealing with QoD sessions by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/163
* Added new model `EventQosStatus` by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/167

### Changed

* Aligned error format with CAMARA design guidelines by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/104
* Renamed properties to new terms agreed in CAMARA Commonalitites by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/129
* Updated method for identifying devices by IPv4 address by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/139
* Updated of the notification event related fields based on the CAMARA design guideline by @akoshunyadi in https://github.com/camaraproject/QualityOnDemand/pull/155
* CAMARA documentation is now embedded within the OAS definition, and not separate by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/151

### Fixed

* Added error code 501 "Not Implemented" by @dfischer-tech in https://github.com/camaraproject/QualityOnDemand/pull/124
* Added inheritance between Event and QosStatusChangedEvent and simplified notification payload model by @patrice-conil in https://github.com/camaraproject/QualityOnDemand/pull/177
  
### Removed

* Removed format lines from Datatypes `Ipv4Address` and `Ipv6Address` by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/177
* Removed markdown documentation (now embedded within the OAS definition, see above)

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.8.1...v0.9.0

# v0.9.0-rc

**This is the release candidate of v0.9.0 - the (third alpha (tbc)) release of the Quality-On-Demand (QoD) API**

- [API definition with inline documentation](https://github.com/camaraproject/QualityOnDemand/blob/v0.9.0-rc/code/API_definitions/qod-api.yaml)

## Please note:

- **This release contains significant changes compared to v0.8.1, and it is not backward compatible**
  - Especially a lot of the parameter names changed in line with the agreed glossary within CAMARA Commonalities
- **This is only the pre-release, it should be considered as a draft of the upcoming release v0.9.0**
- The pre-release is meant for implementors, but it is not recommended to use the API with customers in productive environments.

### Added

* Introduced `qosStatus` and corresponding notification event to fix issue #38 by @emil-cheung in https://github.com/camaraproject/QualityOnDemand/pull/67
* Added basic tests with Cucumber framework using Java and Maven implementation by @mdomale in https://github.com/camaraproject/QualityOnDemand/pull/134
* Added new methods to get service provider defined QoS Profile by @RandyLevensalor in https://github.com/camaraproject/QualityOnDemand/pull/138
* Scopes specified and OAuth2 authorizationCode flow added as security mechanism, for operations dealing with QoD sessions by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/163
* Added new model `EventQosStatus` by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/167


### Changed

* Aligned error format with CAMARA design guidelines by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/104
* Renamed properties to new terms agreed in CAMARA Commonalitites by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/129
* Updated method for identifying devices by IPv4 address by @eric-murray in https://github.com/camaraproject/QualityOnDemand/pull/139
* Updated of the notification event related fields based on the CAMARA design guideline by @akoshunyadi in https://github.com/camaraproject/QualityOnDemand/pull/155
* CAMARA documentation is now embedded within the OAS definition, and not separate by @jlurien in https://github.com/camaraproject/QualityOnDemand/pull/151

### Fixed

* Added error code 501 "Not Implemented" by @dfischer-tech in https://github.com/camaraproject/QualityOnDemand/pull/124

### Removed

* Removed format lines from Datatypes `Ipv4Address` and `Ipv6Address` by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/153
* Removed markdown documentation (now embedded within the OAS definition, see above)

## New Contributors
* @jlurien made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/104
* @dfischer-tech made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/124
* @maheshc01 made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/132
* @eric-murray made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/139
* @mdomale made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/134
* @RandyLevensalor made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/138

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.8.1...v0.9.0-rc

# v0.8.1

**This is the second alpha release of the Quality-On-Demand (QoD) API**
- API [definition](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.1/code/API_definitions)
- API [documentation](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.1/documentation/API_documentation)

## Please note:

- **This minor release contains minor fixes of v0.8.0, but is not backward compatible to v0.8.0**
- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.

### Added

* Added Generic error 500 to remaining procedures by @SfnUser in https://github.com/camaraproject/QualityOnDemand/pull/86

### Changed

* Update from notificationsUri to notificationsUrl by @maxl2287 in https://github.com/camaraproject/QualityOnDemand/pull/89
* Update and rename QoD_Latency_Bandwidth_User_Story.md  by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/103

### Fixed

* Fixed two typos in qod-api.yaml by @SfnUser in https://github.com/camaraproject/QualityOnDemand/pull/77

### Removed

## New Contributors
* @maxl2287 made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/89
* @SfnUser made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/77

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.8.0...v0.8.1

# v0.8.0

**This is the first alpha version of the Quality-On-Demand (QoD) API.** 
- API [definition](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.0/code/API_definitions)
- API [documentation](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.0/documentation/API_documentation)

## Please note:

- This is an alpha version, it should be considered as a draft.
- There are bug fixes to be expected and incompatible changes in upcoming versions. 
- The release is suitable for implementors, but it is not recommended to use the API with customers in productive environments.
- Version numbers 0.2.x to 0.7.x were used in private versions during the development of the API and are here not used to avoid conflicts with local implementations.
- Provider implementations (PI) will be provided within separate repositories:
  - [QualityOnDemand_PI1](https://github.com/camaraproject/QualityOnDemand_PI1) by Deutsche Telekom
  - [QualityOnDemand_PI2](https://github.com/camaraproject/QualityOnDemand_PI2) by Orange

## What's Changed
* Contribution of the QoD-API spec v0.8.0 by @akoshunyadi in https://github.com/camaraproject/QualityOnDemand/pull/54
* Improvements for QoSProfile_Mapping_Table.md by @tlohmar in https://github.com/camaraproject/QualityOnDemand/pull/62 and @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/73
* Update qod api documentation to 0.8.0 by @shilpa-padgaonkar in https://github.com/camaraproject/QualityOnDemand/pull/71
* Editorial updates of documentation QoD_API.md by @hdamker, @kaikreuzer, and @mariobodemann
* Delete code/API_code directory by @hdamker in https://github.com/camaraproject/QualityOnDemand/pull/93

## New Contributors
* @akoshunyadi made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/54
* @tlohmar made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/62

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/v0.1.0...v0.8.0

# v0.1.0 - Initial contribution

**Initial contribution of two API definitions for Quality on Demand (stable bandwidth and stable latency)**, including initial documentation and implementation code.

## Please note 
- this "release" is only tagged to document the history of the API, it is not intended to be used by implementors or API customers
- it was implemented by Deutsche Telekom within lab environment and tested against two NEF implementations
- going forward the implementation [code](https://github.com/camaraproject/QualityOnDemand/tree/50e81e0c4a6a7431c0a7f50c26415caf935be6df/code/API_code) will not be part of releases of QoD API. Instead it will be provided within separate repositories (QualityOnDemand_PIx).

## What's Changed
* Qod latency api spec 0.1.0 contribution by @shilpa-padgaonkar in https://github.com/camaraproject/QualityOnDemand/pull/24
* Qod bandwidth api spec 0.1.0 contribution by @shilpa-padgaonkar in https://github.com/camaraproject/QualityOnDemand/pull/25
* Code contribution for release 0.1.0 by @anjagerlach in https://github.com/camaraproject/QualityOnDemand/pull/28
* Create QoD-API-Readiness-Checklist.md by @shilpa-padgaonkar in https://github.com/camaraproject/QualityOnDemand/pull/30

## New Contributors
* @T-sm made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/10
* @anjagerlach made their first contribution in https://github.com/camaraproject/QualityOnDemand/pull/28

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/commits/v0.1.0
