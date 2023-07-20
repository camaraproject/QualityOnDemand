# Changelog QualityOnDemand

## Table of Contents

- [v0.9.0](#v090)
- [v0.9.0-rc](#v090-rc)
- [v0.8.1](#v081)
- [v0.8.0](#v080)
- [v0.1.0 - Initial contribution](#v010---initial-contribution)

Version numbers 0.2.x to 0.7.x were intentionally not used to avoid conflicts with local implementations.

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

# v0.9.0

**This is the third alpha version of the Quality-On-Demand (QoD) API.**

- [API definition with inline documentation](https://github.com/camaraproject/QualityOnDemand/releases/tag/release-0.9.0/code/API_definitions)

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
