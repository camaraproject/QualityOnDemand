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
  * set quality for a mobile connection (e.g. required latency, jitter, bit rate)  
  * get notification if network cannot fulfill  
  * NOTE: The scope of this API family should be limited (at least at a first stage) to 4G and 5G.  
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: October 2021
* Location: virtually  

## Meetings
* Meetings are held virtually
* Schedule: bi-weekly, Friday, 2 PM CET/CEST (13:00 UTC, 12:00 UTC during European DST). For date/time of next meeting see previous [meeting minutes](https://github.com/camaraproject/QualityOnDemand/tree/main/documentation/MeetingMinutes).
* Meeting link: <a href="https://teams.microsoft.com/l/meetup-join/19%3ameeting_MGM3YTBjYWYtNGVmNy00Mjk1LWJhMTktZjI1M2NjNzg2ZDFh%40thread.v2/0?context=%7b%22Tid%22%3a%22bde4dffc-4b60-4cf6-8b04-a5eeb25f5c4f%22%2c%22Oid%22%3a%2237ff36be-0e4d-42c3-ac06-7b904f0f6b24%22%7d">Microsoft Teams Meeting</a> 

## Status and released versions
* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.
* **The latest available release and version of Quality-On-Demand (QoD) API is 0.8.1. This is the second alpha version of the API.** There are bug fixes to be expected and incompatible changes in upcoming releases. It is suitable for implementors, but it is not recommended to use the API with customers in productive environments.
* Version 0.8.1 of the API is available within the [release-0.8.1 branch](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.1):
  * API [definition](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.1/code/API_definitions)
  * API [documentation](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.1/documentation/API_documentation)
  * For changes see [CHANGELOG.md](https://github.com/camaraproject/QualityOnDemand/blob/main/CHANGELOG.md)
* The previous version v0.8.0 of the QoD API is available within the [release-0.8.0 branch](https://github.com/camaraproject/QualityOnDemand/tree/release-0.8.0)
* Provider implementations (PI) will be provided within separate repositories:
  * [QualityOnDemand_PI1](https://github.com/camaraproject/QualityOnDemand_PI1) by Deutsche Telekom
  * [QualityOnDemand_PI2](https://github.com/camaraproject/QualityOnDemand_PI2) by Orange
  * [QualityOnDemand_PI3](https://github.com/camaraproject/QualityOnDemand_PI3) by Spry Fox Networks

## Contributorship and mailing list
* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/sp-qod>.
* A message to all Contributors of this Sub Project can be sent using <sp-qod@lists.camaraproject.org>.
