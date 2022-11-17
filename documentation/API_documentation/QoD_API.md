# Overview

<span class="colour" style="color:rgb(0, 0, 0)">The Quality-On-Demand (QoD) API provides programmable interface for developers and other users (capabilities consumers) to request stable latency or throughput managed by Telco networks without the necessity to have an in-depth knowledge of the 4G/5G system or the overall complexity of the Telecom Systems [[1]](#1).</span> 

## 1\. Introduction

Industrial (IoT), VR/Gaming, broadcasting, autonomous driving and many others scenarios demand network communication quality and are sensitive to any change in transmission conditions. Being able to request a stable latency (reduced jitter) or stable throughput from the network can improve user experience substantially.

The QoD API offers the application developers the capability to request for stable latency (reduced jitter) or throughput for a specified App-Flow between User Equipment (application clients) and Application Servers (backend services). The developer has a pre-defined set of Quality of Service (QoS) Profiles which they could choose from depending on their latency or throughput requirements.

<img src="./resources/QoD_overview.PNG" alt="QoD_LM" title="QoD API Overview">

## 2\. Quick Start

The usage of the API is based on QoS sessions, which can be created (based on available QoS profiles), queried and deleted.
The deletion of a requested session can be triggered by the user or can be triggered automatically. The automatic process is triggered either when the user specified duration of a QoS session has reached its limit or the default session expiration time has been reached (within an example provider implementation it is set to 24hrs).

Before starting to use the API, the developer needs to know about the below specified details:

**Base-URL**
The RESTful QoD API endpoint

**Authentication**
Security access keys such as OAuth 2.0 client credentials used by Client applications to invoke the QoD API.

**QoS Profile**
Latency or throughput requirements of the application mapped to relevant QoS profile class.

**Identifier for the the user equipment (UE)**
At least one identifier for the user equipment out of four options: IPv4 address, IPv6 address, MSISDN, or external ID [[5]](#5) assigned by the Mobile Operator for the user equipment

**Identifier for the application server (AS)**
IPv4 and/or IPv6 address of the application server (application backend)

**App-Flow**
The precise IP flow the developer wants to prioritize and have stable latency or throughput for. This flow is in the current API version determined by the IP addresses of the user equipment and the application server. And can be further described with ports or port-ranges. Future version of the API might allow more detailed flow descriptions.

**Duration** 
Number of seconds for which the QoD session should be created. This parameter is optional and if not specified, the session is either deleted on user request or if default expiration limit has been reached (24 hours in one of the example provider implementations).

**Notification URL and token**
Developers have a chance to specify callback URL on which notifications (eg. session termination) regarding the session can be received from the service provider. This is an optional parameter.

Sample API invocations are presented in Section 4.6.

## 3\. Authentication and Authorization

The QoD Service API makes use of the client credentials grant which is applicable for server to server use cases involving trusted partners
or clients without any protected user data involved.
In this method the API invoker client is registered as a confidential client with an authorization grant type of client_credentials [[3]](#3).

## 4\. API Documentation

### 4.1 API Version

0.8.0

### 4.2 Details

The usage of the QoD API is based on QoS profile classes and parameters which define App-Flows.
Based on the API, QoS sessions can be created, queried, and deleted. Once an offered QoS profile class is requested, application users get a prioritized service with stable latency or throughput even in the case of congestion. The QoD API has the following characteristics:

* A specified App-Flow is prioritized to ensure stable latency or throughput for that flow
* The prioritized App-Flow is described by providing information such as user equipment (UE) IP address (or other UE identifier) & application server (AS) IP addresses and port/port-ranges
* The developer can optionally specify the duration for which they need the prioritized App-flow
* Stable latency or throughput is requested by selecting from the list of QoS profiles made available by the service provider (e.g. QOS_E) to map latency and throughput requirements
* The developer can optionally also specify callback URL on which notifications for the session can be sent <br>

Following diagram shows the interaction between different components

<br>

<img src="./resources/QoD_details.PNG" alt="QoD_LM" title="QoD Management API">

The below table shows one possible example how QoS profiles are mapped to connectivity characteristics. They are subject to agreements between the communication service provider and the API invoker. This sample is taken from from the reference draft within the CAMARA project [[2]](#2).

| **QoD profile** | **Details** |
| ------------------- | ------- |
| QOS_E | Enhanced communication class where latency stays stable under congestion (throughput upto 500kbps). The application bitrate should not exceed 500kbps. |
| QOS_S | Small class of throughput profile - for example The 5G System throughput is prioritized up to 20Mbps. At high load, the throughput is capped at 20Mbps and can be degraded to lower effective throughput (without a minimum level). |
| QOS_M | Medium class of throughput profile - for example throughput is prioritized up to 8Mbps. At high load, the throughput is capped at 8Mbps and can be degraded to lower effective throughput (without a minimum level). |
| QOS_L | Large class of throughput profile - for example throughput is prioritized up to 4Mbps. At high load, the throughput is capped at 4Mbps and can be degraded to lower effective throughput (without a minimum level). |

### 4.3 Endpoint Definitions

Following table defines API endpoints of exposed REST based for QoD management operations.

| **Endpoint** | **Operation** | **Description** |
| -------- | --------- | ----------- |
| POST<br>  \<base-url>/qod-api/v0/sessions | **Create QoD Session** | Create QoS Session to manage latency/throughput priorities |
| GET<br> \<base-url>/qod-api/v0/sessions/{sessionId} | **Query for QoD Session** | Querying for QoD session information details |
| DELETE<br> \<base-url>/qod-api/v0/sessions/{sessionId} | **Delete QoD Session** | Deleting a QoD session |
<br>

#### QoD Create QoS Session Operation

| **Create QoD Session** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>/qod-api/v0/sessions<br>**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br> No path parameters are defined.<br>**Request Body Parameters**<br> **duration (optional)**: Session duration in seconds. Maximal value of 24 hours is used if not set. e.g. 86400<br> **ueId:** The identifier for the user equipment(device). The developer can choose to provide the below specified user equipment identifiers:<br>  - IPv4 address (supports mask) e.g. 192.168.0.1/24<br> - ipv6 address (supports mask) e.g. 2001:db8:85a3:8d3:1319:8a2e:370:7344<br> - msisdn (including country code and optionally could be prefixed by "+" sign) e.g. 004912345678923 <br> - externalId [[5]](#5)  assigned by the Mobile network Operator for the user equipment. e.g. 123456789@domain.com <br>NOTE: the communication service provider (CSP) might support only a subset of these options. The API invoker can provide multiple identifiers to be compatible across different CSPs. In this case the identifiers MUST belong to the same UE<br> **asId:** The identifier used for application server. The developer can choose from the below application server identifiers: <br> - ipv4 address (supports mask) e.g. 192.168.0.1/24 <br> - ipv6 address (supports mask) e.g. 2001:db8:85a3:8d3:1319:8a2e:370:7344 <br> **uePorts (optional):** A list of single ports or port ranges on the user equipment.<br> e.g. "uePorts": {"ranges": [{"from": 5010,"to": 5020}],"ports": [5060,5070]} <br>  **asPorts (optional):** A list of single ports or port ranges on the application server. e.g. "asPorts": {"ranges": [{"from": 5010,"to": 5020}],"ports": [5060,5070]}<br>  **qos:** Qualifier for the requested latency/throughput profile. e.g. QOS_E <br> **notificationUri (optional):** URI of the callback receiver. Allows asynchronous delivery of session related events. e.g. '[https://application-server.com/notifications](https://application-server.com/notifications)'</span><br> **notificationAuthToken (optional):** Authentication token for callback API. e.g. c8974e592c2fa383d4a3960714 <br><br>**Response**<br> **200: Session created**<br>  Response body:<br> **duration:** Session duration in seconds.<br> **ueId:** The identifier of the user equipment <br>   **asId:** The identifer of the application server.<br>   **uePorts (optional):** The requested port(s) on the user equipment.<br>   **asPorts (optional):** The requested port(s) on the application server.<br>  **qos:** Qualifier of the requested throughput profile.<br>   **notificationUri (optional):** URI of the callback receiver.<br>   **notificationAuthToken (optional):** Authentication token for callback API.<br>   **id:** Session ID in UUID format.<br> e.g. 123e4567-e89b-12d3-a456-426614174000<br>   **startedAt:** Timestamp of session start, in seconds since Unix epoch.<br> e.g. 1639479600<br>   **expiresAt**: Timestamp of session expiration if the session was not deleted, in seconds since Unix epoch. e.g. 1639566000 <br><br> **400:** **Invalid input.**<br> **401:** **Un-authorized. <br> **403:** Forbidden.**<br> **409:** **Conflict.**<br> **500:** **Server Error.**<br> **503:** **Service temporarily unavailable.** |
<br>

#### QoD Query for QoS Session

| **Quering QoS Session information** |
| --------------------------------------- |
| **HTTP Request**<br> GET\<base-url>/qod-latency-api/v0/sessions/{sessionId}<br>**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br> sessionId: Session id that was obtained from the Create QoS Session operation.<br>**Request Body Parameters**<br> No request body parameters are defined.<br>**Response**<br><br> **200: Session information returned.**<br>  Response body:<br> **ueId:** The identifier of the user equipment.<br>   **asId:** The identifier of the application server.<br>   **uePorts (optional):** The requested port(s) on the user equipment.<br>   **asPort (optional):** The requested port(s) on the application server.<br>   **qos:** Qualifier of the requested QoS profile.<br>   **notificationUri (optional):** URI of the callback receiver.<br>   **notificationAuthToken (optional):** Authentication token for callback API.<br>   **id:** Session ID in UUID format.<br>   **startedAt:** Timestamp of session start in seconds since Unix epoch.<br>   **expiresAt:** Timestamp of session expiration if the session was not deleted in seconds since Unix epoch.<br><br> **401:** Un-authorized. <br> **403:** Forbidden. <br> **404:** Session not found.<br> **503:** Service temporarily unavailable. |
<br>

#### QoD Delete QoS Session

| **Deleting QoS session** |
| ---------------------------- |
| **HTTP Request**<br>  DELETE\<base-url>/qod-api/v0/sessions/{sessionId}<br>**Query Parameters**<br>  No query parameters are defined.<br>**Path Parameters**<br>  sessionId: Session ID that needs to be terminated.<br>**Request Body Parameters**<br>  No request body parameters are defined.<br><br>**Response**<br> **204:** Session deleted<br> **401:** Un-authorized. <br> **403:** Forbidden.<br> **404:** Session not found.<br> **503:** Service temporarily unavailable.|

### 4.4 Errors

Since CAMARA QoD API is based on REST design principles and blueprints, well defined HTTP status codes and families specified by community are followed [[4]](#4).

Details of HTTP based error/exception codes for the QoD API are described in Section 4.3 of each API REST based method.
Following table provides an overview of common error names, codes, and messages applicable to QoD API.

| No | Error Name | Error Code | Error Message |
| --- | ---------- | ---------- | ------------- |
|1	|400 |	INVALID_INPUT |	"Expected property is missing: ueId.msisdn" |
|2	|400 |	INVALID_INPUT |	"Expected property is missing: ueId.ipv4addr" |
|3	|400 |	INVALID_INPUT |	"Expected property is missing: ueId.ipv4addr or ueId.ipv6addr" |
|4	|400 |	INVALID_INPUT |	"Expected property is missing: uePorts" |
|5	|400 |	INVALID_INPUT |	"Expected property is missing: qos" |
|6	|400 |	INVALID_INPUT |	"Ranges not allowed: uePorts" |
|7	|401 |	UNAUTHORIZED |	"No authorization to invoke operation" |
|8	|403 |	FORBIDDEN |	"Operation not allowed" |
|9	|404 |	NOT_FOUND |	"Session Id does not exist" |
|10	|409 |	CONFLICT |	"Another session is created for the same UE" |
|11	|500 |	INTERNAL |	"Session could not be created" |
|12	|503 |	SERVICE_UNAVAILABLE |	"Service unavailable" |

### 4.5 Policies

N/A

### 4.6 Code Snippets
<br>
<span class="colour" style="color:rgb(36, 41, 47)">Snippet 1, elaborates REST based API call with "*curl"* to create a QoS session for sample streaming service with following parameters: </span>

* QoS session with QoS-profile "QOS_E" mapping,
* App-Flow is specified for UE-Terminal identifier (ueId=2001:db8:85a3:8d3:1319:8a2e:370:7344), Application server identifier (asId=54.204.25.0/28) and Port number (asPorts=33001).

Please note, the credentials for API authentication purposes need to be adjusted based on target security system configuration.

| Snippet 1. Create QoS session  |
| ----------------------------------------------- |
| curl -X 'POST' `https://sample-base-url/qod-api/v0/sessions`   <br>    -H 'accept: application/json' <br>    -H 'Content-Type: application/json'<br>    -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbG...."<br>    -d '{<br>     "ueId": {"ipv6Addr": "2001:db8:85a3:8d3:1319:8a2e:370:7344"},<br>     "asId": {"ipv4Addr": "54.204.25.0/28"},<br>     "asPorts": "33001",<br>     "qos": "QOS_E",<br>     "notificationUri": `https://your-callback-server.com/notifications`,<br>     "notificationAuthToken": "c8974e592c2fa383d4a3960714"<br>   }' |
<br>
Snippet 2, elaborates sample QoS notification "SESSION_TERMINATION" message distributed from QoD backend to client callback function.

| Snippet 2. Sample QoS session notification |
| ------------------------------------------ |
| {<br>   "sessionId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",   "event": "SESSION_TERMINATED"<br>} |

### 4.7 FAQ's

(FAQs will be added in a later version of the documentation)

### 4.8 Terms

N/A

### 4.9 Release Notes

N/A

## References

<a name="1">[1] 3GPP TS 23.501: System architecture for the 5G System (5GS); Stage 2 (Release 17), V17.4.0 (2022-03)<br>
<a name="2">[2] [CAMARA QoS Profiles Mapping Table (REFERENCE DRAFT)](https://github.com/camaraproject/QualityOnDemand/blob/main/code/API_definitions/QoSProfile_Mapping_Table.md) <br>
<a name="3">[3] [CAMARA Commonalities : Authentication and Authorization Concept for Service APIs](https://github.com/camaraproject/WorkingGroups/blob/main/Commonalities/documentation/Working/CAMARA-AuthN-AuthZ-Concept.md) <br>
<a name="4">[4] [HTTP Status codes spec](https://restfulapi.net/http-status-codes/) <br>
<a name="5">[5] [GPSI external identifier](https://github.com/camaraproject/WorkingGroups/blob/main/Commonalities/documentation/UE-Identification.md)
