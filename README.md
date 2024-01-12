<a href="https://github.com/camaraproject/QualityOnDemand/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/blob/main/documentation/LICENSE.APACHE2.0" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>

# QualityOnDemand
Repository to describe, develop, document and test the QualityOnDemand API family

## Scope

* Service APIs for “Quality on Demand” (see APIBacklog.md)
* It provides the customer with the ability to:  
  * set quality for access network connections (e.g. required latency, jitter, bit rate)  
  * get notification if network cannot fulfill  
  * NOTE: The scope of this API family should be limited the networks between the customer's device (e.g. UE, CPE or home gateway) and the gateway from the operator's network to other networks.
* Describe, develop, document and test the APIs (with 1-2 Service Providers)  
* Started: October 2021
* Location: virtually  

## Meetings
* Meetings are held virtually
* Schedule: bi-weekly, Friday, 2 PM CET/CEST (13:00 UTC, 12:00 UTC during European DST). For date/time of next meeting see previous [meeting minutes](https://github.com/camaraproject/QualityOnDemand/tree/main/documentation/MeetingMinutes).
* Meeting link: <a href="https://teams.microsoft.com/l/meetup-join/19%3ameeting_MGM3YTBjYWYtNGVmNy00Mjk1LWJhMTktZjI1M2NjNzg2ZDFh%40thread.v2/0?context=%7b%22Tid%22%3a%22bde4dffc-4b60-4cf6-8b04-a5eeb25f5c4f%22%2c%22Oid%22%3a%2237ff36be-0e4d-42c3-ac06-7b904f0f6b24%22%7d">Microsoft Teams Meeting</a> 

## Status and released versions
* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.

* **The Release Candidate for v0.10.0 of the Quality-On-Demand API is available. This upcoming release will contain the fourth alpha version of the QoD API**<br>Until the release there are bug fixes to be expected. The release candidate is suitable for implementors, but it is not recommended to use the API with customers in productive environments.
* The release candidate for v0.10.0 is available in the [release-0.10.0-rc branch](https://github.com/camaraproject/QualityOnDemand/tree/release-0.10.0-rc)
  - API definition v0.10.0-rc with inline documentation:
    - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/release-0.10.0-rc/code/API_definitions/qod-api.yaml&nocors)
    - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/release-0.10.0-rc/code/API_definitions/qod-api.yaml)
    - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/release-0.10.0-rc/code/API_definitions/qod-api.yaml)
  - For changes between v0.10.0-rc and v0.9.0 see the [CHANGELOG.md](https://github.com/camaraproject/QualityOnDemand/blob/main/CHANGELOG.md)

* The latest available and released version 0.9.0 is available within the [release-0.9.0 branch](https://github.com/camaraproject/QualityOnDemand/tree/release-0.9.0)
  - API definition v0.9.0 with inline documentation:
    - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/release-0.9.0/code/API_definitions/qod-api.yaml&nocors)
    - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/release-0.9.0/code/API_definitions/qod-api.yaml)
    - OpenAPI [YAML spec file](https://github.com/camaraproject/QualityOnDemand/blob/release-0.9.0/code/API_definitions/qod-api.yaml)
   
* The previous released version v0.8.1 is availabe within the [release-0.8.1 branch](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.1)

* Provider implementations (PI) are available within separate repositories:
  * [QualityOnDemand_PI1](https://github.com/camaraproject/QualityOnDemand_PI1) by Deutsche Telekom
  * [QualityOnDemand_PI2](https://github.com/camaraproject/QualityOnDemand_PI2) by Orange
  * [QualityOnDemand_PI3](https://github.com/camaraproject/QualityOnDemand_PI3) by Spry Fox Networks

## Contributorship and mailing list
* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/sp-qod>.
* A message to all Contributors of this Sub Project can be sent using <sp-qod@lists.camaraproject.org>.
