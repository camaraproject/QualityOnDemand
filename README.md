<a href="https://github.com/camaraproject/QualityOnDemand/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/blob/main/documentation/LICENSE.APACHE2.0" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/QualityOnDemand?style=plastic"></a>

# QualityOnDemand

Repository to describe, develop, document and test the QualityOnDemand API family

## Scope

* Service APIs for “Quality on Demand” (see APIBacklog.md)
* It provides the customer with the ability to:  
  * set quality for a flow within an access network connections (e.g. mobile device connection or fixed access between a home gateway and the service providers gateway router)
      * Session mode, for a specific duration
      * Provision mode, indefinitely for each time the device connects to the same access network
  * get notification if the network cannot fulfill  
* Describe, develop, document and test the APIs (with 1–2 Service Providers)  
* Started: October 2021

## Release Information

* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest public release**.


* **The latest public release is [r1.2](https://github.com/camaraproject/QualityOnDemand/tree/r1.2) with the following API definitions:**

  * **quality-on-demand v0.11.0**  
  [[YAML]](https://github.com/camaraproject/QualityOnDemand/blob/r1.2/code/API_definitions/quality-on-demand.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r1.2/code/API_definitions/quality-on-demand.yaml&nocors)
  [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r1.2/code/API_definitions/quality-on-demand.yaml)
  
  * **qos-profiles v0.11.0**  
  [[YAML]](https://github.com/camaraproject/QualityOnDemand/blob/r1.2/code/API_definitions/qos-profiles.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r1.2/code/API_definitions/qos-profiles.yaml&nocors)
  [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r1.2/code/API_definitions/qos-profiles.yaml)

  * qod-provisioning v0.1.0 (new, first initial version)  
  [[YAML]](https://github.com/camaraproject/QualityOnDemand/blob/r1.2/code/API_definitions/qod-provisioning.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r1.2/code/API_definitions/qod-provisioning.yaml&nocors)
  [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r1.2/code/API_definitions/qod-provisioning.yaml)

* Previous releases and pre-releases are available here: https://github.com/camaraproject/QualityOnDemand/releases
* For changes see [CHANGELOG.md](https://github.com/camaraproject/QualityOnDemand/blob/main/CHANGELOG.md)

* Provider implementations (PI) for previous releases are available within separate repositories:

  * [QualityOnDemand_PI1](https://github.com/camaraproject/QualityOnDemand_PI1) by Deutsche Telekom
  * [QualityOnDemand_PI2](https://github.com/camaraproject/QualityOnDemand_PI2) by Orange
  * [QualityOnDemand_PI3](https://github.com/camaraproject/QualityOnDemand_PI3) by Spry Fox Networks

## Contributing

* Meetings are held virtually 
  * Schedule: bi-weekly, Friday, 2 PM CET/CEST (13:00 UTC, 12:00 UTC during European DST). For date/time of the next meeting, see previous meeting minutes
  * [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/94112812156?password=f238d6af-c959-48d7-a862-abdb3c648e40)
  * Minutes: Access [meeting minutes](https://lf-camaraproject.atlassian.net/wiki/x/XCPe)
* Mailing List
  * Subscribe / unsubscribe to the mailing list of this Sub Project <https://lists.camaraproject.org/g/sp-qod>.
  * A message to the community of this Sub Project can be sent using <sp-qod@lists.camaraproject.org>.
