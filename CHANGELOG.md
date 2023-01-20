# Changelog QualityOnDemand

## Table of Contents

- [v0.8.0](#v080)
- [v0.1.0 - Initial contribution](#v010---initial-contribution)

Version number 0.2.x to 0.7.x were intentionally not used to avoid conflicts with local implementations.

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**


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
