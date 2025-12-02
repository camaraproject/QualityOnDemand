<a href="https://github.com/camaraproject/QualityOnDemand/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/blob/main/documentation/LICENSE.APACHE2.0" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/QualityOnDemand/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/QualityOnDemand?style=plastic"></a>
<a href="https://github.com/camaraproject/Governance/blob/main/ProjectStructureAndRoles.md" title="Incubating API Repository"><img src="https://img.shields.io/badge/Incubating%20API%20Repository-green?style=plastic"></a>

# QualityOnDemand

Incubating API Repository to evolve and maintain the definitions and documentation of QualityOnDemand Service API(s) within the Sub Project [Connectivity Quality Management](https://lf-camaraproject.atlassian.net/wiki/x/hAClB)

* API Repository [wiki page](https://lf-camaraproject.atlassian.net/wiki/x/XCPe)

## Scope

* Service APIs for “Quality on Demand” (see APIBacklog.md)
* The Service APIs provide the API consumer with the ability to:
  * retrieve the possible quality options (profiles) from the network (qos-profiles)
  * set the quality for a connection of a mobile device or a home device within the access network
    * dynamically, for a selected session of a specific duration (quality-on-demand)
    * provisioned, applying the same quality each time the device connects to the network (qod-provisioning)
  * get a notification if the network cannot fulfill the requested quality profile (quality-on-demand, qod-provisioning)
* Describe, develop, document and test the APIs (with 1–2 Service Providers)  
* Started: October 2021
* Incubating stage since: February 2025

<!-- CAMARA:RELEASE-INFO:START -->
<!-- The following section is automatically maintained by the CAMARA project-administration tooling: https://github.com/camaraproject/project-administration -->

## Release Information

> [!NOTE]
> Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.

* **NEW**: The latest public release is [r3.2](https://github.com/camaraproject/QualityOnDemand/releases/tag/r3.2) (Fall25), with the following API versions:
  * **qos-profiles v1.1.0**
  [[YAML]](https://github.com/camaraproject/QualityOnDemand/blob/r3.2/code/API_definitions/qos-profiles.yaml)
  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r3.2/code/API_definitions/qos-profiles.yaml&nocors)
  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r3.2/code/API_definitions/qos-profiles.yaml)
  * **qos-provisioning v0.3.0**
  [[YAML]](https://github.com/camaraproject/QualityOnDemand/blob/r3.2/code/API_definitions/qos-provisioning.yaml)
  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r3.2/code/API_definitions/qos-provisioning.yaml&nocors)
  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r3.2/code/API_definitions/qos-provisioning.yaml)
  * **quality-on-demand v1.1.0**
  [[YAML]](https://github.com/camaraproject/QualityOnDemand/blob/r3.2/code/API_definitions/quality-on-demand.yaml)
  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r3.2/code/API_definitions/quality-on-demand.yaml&nocors)
  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/QualityOnDemand/r3.2/code/API_definitions/quality-on-demand.yaml)
* The latest public release is always available here: https://github.com/camaraproject/QualityOnDemand/releases/latest
* Other releases of this repository are available in https://github.com/camaraproject/QualityOnDemand/releases
* For changes see [CHANGELOG.md](https://github.com/camaraproject/QualityOnDemand/blob/main/CHANGELOG.md)

_The above section is automatically synchronized by CAMARA project-administration._
<!-- CAMARA:RELEASE-INFO:END -->

## Contributing

* Meetings are held virtually
  * Schedule: bi-weekly, Friday, 13:00 UTC (14:00 CET, 15:00 CEST). For date/time of the next meeting, see previous meeting minutes
  * [Registration / Join](https://zoom-lfx.platform.linuxfoundation.org/meeting/94112812156?password=f238d6af-c959-48d7-a862-abdb3c648e40)
  * Minutes: Access [meeting minutes](https://lf-camaraproject.atlassian.net/wiki/x/XCPe)
* Mailing List
  * Subscribe / unsubscribe to the mailing list of this Sub Project <https://lists.camaraproject.org/g/sp-cqm>.
  * A message to the community of this Sub Project can be sent using <sp-cqm@lists.camaraproject.org>.
