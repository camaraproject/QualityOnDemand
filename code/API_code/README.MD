# Development of Quality on Demand APIs

## Get started

### Prerequisites

Make sure Maven 3 or greater and JDK 11 are installed on your system.

### How to run locally

Please ensure, that the prerequisites are fulfilled.
To run a QoD API locally, you have to follow these steps:
* Build
* Create Database
* Start QoD API

#### Build

Build the project by running ```mvn clean package```

#### Create Database

The QoD API needs a Redis database to persist the session data. 
Therefore you can use a local instance of Redis DB or start Redis from Docker container:
* start Redis from Docker container by running ```docker run --name qos-redis -p 6379:6379 -d redis```
* local instance on Windows: https://github.com/zkteco-home/redis-windows
* local instance on Linux: https://redis.io/docs/getting-started/installation/install-redis-on-linux/

#### Start QoD API

For information about how to configure the QoD API, please refer to the next section "Configuration".

Start the qod-api service from terminal or from an IDE or with docker
* from terminal:```java -Dspring.profiles.active=local -jar core/target/senf-core-<current version>.jar```
* from an IDE: Application can also be started directly from an IDE like IntelliJ, Eclipse, etc. by passing VM
  option ```-Dspring.profiles.active=local``` in the "Run Configuration"
* with docker: 
  * ```docker build -t qod-api . ```
  * ```docker run -dp 9091:9091 -p 9092:9092 qod-api```

## Configuration

The configuration can be adapted here: core/src/main/resources/application.yml

The below table lists the environment variables that are used to configure the application properly. This reference 
implementation for the QoD API makes use of the AsSessionWithQoS API (https://www.3gpp.org/ftp/Specs/latest/Rel-17) 
which is usually made available as a part of a NEF/SCEF system. All variables in the below table starting with "SCEF" 
can be understood as NEF/SCEF.

| ENV                              | Description                                                                                                               |
|----------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| SERVER_PORT                      | TCP/IP port listened on by application                                                                                    |
| MANAGEMENT_SERVER_PORT           | TCP/IP port listened on by application management facilities                                                              |
| SCEF_SERVER_APIROOT              | SCEF endpoint API root URL                                                                                                |
| SCEF_SERVER_SCSASID              | ID of SCS or AS providing SCEF endpoint                                                                                   |
| SCEF_SERVER_SUPPORTEDFEATURES    | A list of supported features used as described in subclause 5.8. (3GPP)                                                   |
| SCEF_AUTH_OAUTH_TOKEN            | OAuth authentication token for calling SCEF endpoint                                                                      |
| SCEF_NOTIFICATIONS_URL           | URL for delivering (POST) notifications from SCEF, it should include the path /3gpp-as-session-with-qos/v1/notifications  |
| QOD_QOS_REFERENCES               | QoS reference for predefined specific QoS parameter set                                                               |
| SPRING_REDIS_HOST                | Redis server host                                                                                                         |
| SPRING_REDIS_PORT                | Port where the Redis server is listening                                                                                  |
| EXPIRATION_TIME-BEFORE-HANDLING  | How many seconds before expiration, should an ExpiredSessionTask be created                                               |
| EXPIRATION_TRIGGER-INTERVAL      | How often should the ExpiredSessionMonitor check for (almost) expired sessions                                            |
| EXPIRATION_LOCK-TIME             | How many seconds the session should be locked for the processing of the deletion task                                     |
| MASK-SENSIBLE-DATA               | If set to true, sensible data is masked in response body                                                                  |
| ALLOW-MULTIPLE-UEADDR            | If set to true, network segments are allowed for ueAddr                                                                   |

## Validations

The QoD reference implementation has been qualified against the following network service vendors:

| System Name        | Vendor       | Camara Testing Member  | Qualified  |
|--------------------|--------------|------------------------|------------|
| 5G-NEF OpenLab     | Nokia        | DT                     | Yes        |
| 5G-NEF             | Ericsson     | DT                     | Yes        |

We actively ask other Camara members to validate this implementation against their available backend network services and 
share the results with the community.

## Contribution

Contribution and feedback is always welcome. For information how to contribute, please refer to our 
[Contribution Guideline](https://github.com/camaraproject/Governance/blob/main/CONTRIBUTING.md)

## License

Copyright (c) 2022 Contributors | Deutsche Telekom AG to CAMARA a Series of LF Projects, LLC

All contributors / copyright owners license this file to you under the Apache License, Version 2.0 (the "License"); you 
may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.