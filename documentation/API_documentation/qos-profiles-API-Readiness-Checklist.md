# API Readiness Checklist

Checklist for qos-profiles v1.0.0 in r2.2

| Nr | API release assets  | alpha | release-candidate |  initial<br>public | stable<br> public | Status | Reference information |
|----|----------------------------------------------|:-----:|:-----------------:|:-------:|:------:|:----:|----|
|  1 | API definition                               |   M   |         M         |    M    |    M   |  Y   | [/code/API_definitions/qos-profiles.yaml](/code/API_definitions/qos-profiles.yaml) |
|  2 | Design guidelines from Commonalities applied |   O   |         M         |    M    |    M   |  Y   | [r2.3](https://github.com/camaraproject/Commonalities/releases/tag/r2.3)     |
|  3 | Guidelines from ICM applied                  |   O   |         M         |    M    |    M   |  Y   | [r2.3](https://github.com/camaraproject/IdentityAndConsentManagement/releases/tag/r2.3)     |
|  4 | API versioning convention applied            |   M   |         M         |    M    |    M   |  Y   |      |
|  5 | API documentation                            |   M   |         M         |    M    |    M   |  Y   | inline within YAML |
|  6 | User stories                                 |   O   |         O         |    O    |    M   |  Y   | [/documentation/API_documentation/QoSProfile_User_Story.md](/documentation/API_documentation/QoSProfile_User_Story.md) |
|  7 | Basic API test cases & documentation         |   O   |         M         |    M    |    M   |  Y   | [/code/Test_definitions](/code/Test_definitions) |
|  8 | Enhanced API test cases & documentation      |   O   |         O         |    O    |    M   |  Y   | [/code/Test_definitions](/code/Test_definitions) |
|  9 | Test result statement                        |   O   |         O         |    O    |    M   |  Y   |  see [issue #418](https://github.com/camaraproject/QualityOnDemand/issues/418)    |
| 10 | API release numbering convention applied     |   M   |         M         |    M    |    M   |  Y   |      |
| 11 | Change log updated                           |   M   |         M         |    M    |    M   |  Y   | [/CHANGELOG.md](/CHANGELOG.md) |
| 12 | Previous public release was certified        |   O   |         O         |    O    |    M   |  Y   | see (1) |

((1) GSMA certified implementation of previous version by China Unicom, multiple implementation by other operators  (source: https://www.open-gateway.com/operators-map as of 2025-02-25) 

To fill the checklist:
- in the line above the table, replace the api-name, api-version and the rx.y by their actual values for the current API version and release.
- in the Status column, put "Y" (yes) if the release asset is available or fulfilled in the current release, a "N" (no) or a "tbd". Example use of "tbd" is in case an alpha or release-candidate API version does not yet provide all mandatory assets for the release.
- in the Reference information column, provide the relative links (from the API repository home folder) to the release asset once available, the applicable release numbers (not versions) of Commonalities and ICM, and any other relevant links or information.
- For the point 12: The Reference information comment shall reference a note (e.g. "see (1)") under the checklist table to be added that states the certified company(s) as can be found on the following link: [GSMA Open Gateway Portal](https://open-gateway.gsma.com/).

Note: the checklists of a public API version and of its preceding release-candidate API version can be the same.

The documentation for the content of the checklist is here: see API Readiness Checklist section in the [API Release Process](https://lf-camaraproject.atlassian.net/wiki/x/jine).
