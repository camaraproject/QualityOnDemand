# API Readiness Checklist

Checklist for quality-on-demand v0.11.0 in r1.2

| Nr | API release assets  | alpha | release-candidate |  initial<br>public | stable<br> public | Status | Comments |
|----|----------------------------------------------|:-----:|:-----------------:|:-------:|:------:|:----:|----|
|  1 | API definition                               |   M   |         M         |    M    |    M   | Y    | [/code/API_definitions/quality-on-demand.yaml](/code/API_definitions/quality-on-demand.yaml) |
|  2 | Design guidelines from Commonalities applied |   O   |         M         |    M    |    M   | Y    |      |
|  3 | Guidelines from ICM applied                  |   O   |         M         |    M    |    M   | Y    |      |
|  4 | API versioning convention applied            |   M   |         M         |    M    |    M   | Y    |      |
|  5 | API documentation                            |   M   |         M         |    M    |    M   | Y    | inline in YAML |
|  6 | User stories                                 |   O   |         O         |    O    |    M   | Y    | [/documentation/API_documentation/QoD_User_Story.md](/documentation/API_documentation/QoD_User_Story.md) |
|  7 | Basic API test cases & documentation         |   O   |         M         |    M    |    M   | Y    | [/code/Test_definitions](/code/Test_definitions) |
|  8 | Enhanced API test cases & documentation      |   O   |         O         |    O    |    M   | N    |      |
|  9 | Test result statement                        |   O   |         O         |    O    |    M   | N    |      |
| 10 | API release numbering convention applied     |   M   |         M         |    M    |    M   | Y    |      |
| 11 | Change log updated                           |   M   |         M         |    M    |    M   | Y    | [/CHANGELOG.md](/CHANGELOG.md) |
| 12 | Previous public release was certified        |   O   |         O         |    O    |    M   |   Y    |   *   |

* GSMA certified implementation by China Unicom, multiple other implementation by operators  (source: https://www.open-gateway.com/operators-map as of 2024-08-16) 

To fill the checklist:
- in the line above the table, replace the api-name, api-version and the rx.y by their actual values for the current API version and release.
- in the Status column, put "Y" (yes) if the release asset is available or fulfilled in the current release, a "N" (no) or a "tbd". Example use of "tbd" is in case an alpha or release-candidate API version does not yet provide all mandatory assets for the release.
- in the Comments column, provide the link to the asset once available, and any other relevant comments.

Note: the checklists of a public API version and of its preceding release-candidate API version can be the same.

The documentation for the content of the checklist is here: [API Readiness Checklist](https://wiki.camaraproject.org/x/AgAVAQ)
