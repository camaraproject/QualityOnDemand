# Overview

Telco QoS solution is element of modern 4G/5G Operator Networks deployments and based on well defined architectural framework.
The QoS framework described by the 3GPP spec defines components such as PDU Session, App/QoS Flows, Packet Filters and many others [].

<span class="colour" style="color: rgb(0, 0, 0);">The Quality-On-Demand (QoD) API for Stable Latency abstracts those detailed internals of QoS Telco framework, and provides to Developers and other Users</span>
<span class="colour" style="color: rgb(0, 0, 0);">interface to manage Latency exposed by Telco networks without necessity to have in-depth knowledge of the 5G System complexity.</span>

## 1\. Introduction

The API offers the Application Developers and Users to request for pre-defined latency "class" ensuring a stable connection to the Application Servicethrough prioritisation of data-plane communication links.

* Ability to prioritise an Data Communication links (App-Flows) to ensure request latency within the single App-Flow of the Application,
* Prioritise each App-Flow to ensure request latency of the Application,
* Choosing between different QoS Profiles of Latency classes (e.g. Small ,Medium, Large) for the App-Flow.

<span style="color: var(--vscode-unotes-wysList); font-family: var(--vscode-editor-font-family); font-size: 1em; font-weight: var(--vscode-editor-font-weight);">Once proper QoS Latency class is requested, Application users get a prioritised service even in the case of congestion.
The API will be used by Application developers to integrate traffic policies which can be defined statically or dynamically by Users to choose between Latency classes
to get a service more tailored for their specific use case.</span>
<br>
## 2\. Quick Start

The usage of the stable bandwidth API is based on Telco QoS sessions (abstracted by the API), QoS Latency Classes and input parameters which define data communication links.
Within the CAMARA Latency API, QoS session can be created, queried and deleted and appropriate QoS latency classes can be set to ensure requested "Latency".
CAMARA community for the purpose of the QoD API will define some sample QoS profiles classes but in real production those might be specific and defined according to Operator’s owned technology and configuration internals.

The Stable Latency API follows common design assumptions [] based on REST (resource predictable URL's, JSON-encoded responses, response codes, etc).

## 3\. Authentication and Authorization

It can be assumed that Authentication and Authorization method might differ among final implementations and be specific to operator and vendor technology.
For the purpose of the CAMARA, the authentication against the 5G latency API is done using the HTTP Header field key, and "Authorization" with the API key that will provided by the CAMARA Integrator.

## 4\. API Documentation

### 4.1 Details

The Application Developer uses the Latency API  to control the latency of the 5G network App-Flows/QoS sessions providedto Applications running on User Equipment (UE) mobile terminals.
Following diagram shows the interaction of the different components.

* Telco QoD Latency API component which is Telco Network Exposure Function to Application Developers and Users (UE terminals),
* 5G System Infrastructure, which provides QoS architectural and technological solution used by the QoD Latency API.

Following diagram shows the interaction of the different components.
<img src="./resources/QoD_latency_overview.png" alt="QoD_LM" title="QoD Latency Management" width="650" height="350">
Details how CAMARA QoS Latency profiles maps into Telco Operator QoS classes might differ but sample blueprint
proposed by the CAMARA is agreed [].
Following QoS-Latency spec is defined to enable API user (Developer) to request QoS Bandwidth class profile.

| **QoD Latency Profile** | **Details** |
| ------------------- | ------- |
| LOW\_Latency | API developer is requesting Telco QoS Session for the specified data communication link<br>with stable "latency" under congestion (e.g. throughput up-to 2Mbps). |
<br>
### 4.2 Endpoint-Definitions

<span class="colour" style="color:rgb(23, 43, 77)">The example Base-URL RESTful Stable Latency API endpoint is <span class="colour" style="color:rgb(53, 114, 176)">[[https://application-server.com/5g-latency\](https://application-server.com/5g-latency)](https://application-server.com/5g-latency%5D(https://application-server.com/5g-latency)). </span></span>
<span class="colour" style="color:rgb(23, 43, 77)"><span class="colour" style="color:rgb(36, 41, 47)">Following table defines API endpoints of exposed REST based for QoD Latency management operations. </span></span>

| **Endpoint** | **Operation** | **Description** |
| -------- | --------- | ----------- |
| POST<br>  \<base-url>/qos-senf/v1/sessions | **Create Latency Session** | <br>Create QoS Session to manage latency priorities |
| GET<br> \<base-url>/qos-senf/v1/sessions/{sessionId} | **Query for Bandwidth** | Querying for QoS "latency" session information details |
| DELETE<br> \<base-url>/qos-senf/v1/sessions/{sessionId} | **Delete Latency Session** | Deleting a QoS "latency" session |
<br>

#### QoD Create Latency QoS Session Operation

| **Create Latency QoS Session** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>/qos-senf/v1/sessions<br>**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br> No path parameters are defined.<br>**Request Body Parameters**<br> **duration (optional)**: Session duration in seconds. Maximal value of 24 hours is used if not set.<br> **ueAddr:** The IPv4 address of the user equipment. It can contain a single IP address or a range, using a mask.<br>  Format: \<address>[/\<mask>]<br>   - address : an IPv4 number in dotted-quad form 1.2.3.4. Only this exact IP number will match the flow control rule.<br>   - address/mask : an IP number as above with a mask width of the form 1.2.3.4/24.<br>    *In this case, all IP numbers from 1.2.3.0 to 1.2.3.255 will match. The bit width MUST be valid for the IP  version.*<br> **asAddr:** The IPv4 address of the application server. It can contain a single IP address or a range, using a mask.<br> <br> **uePort (optional):** A list of single ports or port ranges on the user equipment.<br>  Ports may be specified as <\{port\|port\-port\}\[\,ports\[\,\.\.\.\]\]\>\.<br>   The '-' notation specifies a range of ports (including boundaries).<br>   Example: '5010-5020,5021,5022'<br> **asPort (optional):** A list of single ports or port ranges on the application server.<br> **protocolIn:** The used transport protocol for the uplink.<br>  TCP - TCP protocol<br>  UDP - UDP protocol<br>  ANY - all protocols<br> **protocolOut :** The used transport protocol for the downlink.<br>  TCP - TCP protocol<br>  UDP - UDP protocol<br>  ANY - all protocols<br> **qos:** Qualifier for the requested latency profile.<br>  <span style="color: rgb(23, 43, 77); font-family: -apple-system, &quot;system-ui&quot;, &quot;Segoe UI&quot;, Roboto, Oxygen, Ubuntu, &quot;Fira Sans&quot;, &quot;Droid Sans&quot;, &quot;Helvetica Neue&quot;, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"></span>LOW\_LATENCY - to request the higher quality (see Details)<br> **notificationUri (optional):** URI of the callback receiver. Allows asynchronous delivery of session related events .<br><span class="s1">&nbsp; Example: '[<span class="s2">https://application-server.com/notifications</span>](https://application-server.com/notifications)'</span><br> **notificationAuthToken (optional):** Authentification token for callback API.<br>  Example: 'c8974e592c2fa383d4a3960714'<br><br>**Response**<br> **201: Session created**<br>  Response body:<br>   **duration:** Session duration in seconds.<br>   **ueAddr:** The ipv4 address of the user equipment.<br>   **asAddr:** The ipv4 address of the application server.<br>   **uePort (optional):** The requested port(s) on the user equipment.<br>   **asPort (optional):** The requested port(s) on the user equipment.<br>   **protocolIn:** The used transport protocol for the uplink.<br>   **protocolOut:** The used transport protocol for the downlink.<br>   **qos:** Qualifier of the requested throughput profile.<br>   **notificationUri (optional):** URI of the callback receiver.<br>   **notificationAuthToken (optional):** Authentication token for callback API.<br>   **id:** Session ID in UUID format.<br>    Example: 123e4567-e89b-12d3-a456-426614174000<br>   **startedAt:** Timestamp of session start in seconds since unix epoch.<br>    Example: 1639479600<br>   **expiresAt**: Timestamp of session expiration if the session was not deleted in seconds since unix epoch.<br><br> **400:** **Invalid input.**<br> **401:** **Un-authorized, missing or incorrect authentication.**<br> **405:** **Invalid input**<br> **500:** **Session not created**<br> **503:** **Service temporarily unavailable** |

#### QoD Query for Latency QoS Session

| **Quering QoS Session Latency information** |
| --------------------------------------- |
| **HTTP Request**<br> GET\<base-url>/qos-senf/v1/sessions/{sessionId}<br>**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br> sessionId: Session id that was obtained from the Create QoS Session operation.<br>**Request Body Parameters**<br> No request body parameters are defined.<br>**Response**<br><br> **200: Session information returned.**<br>  Response body:<br>   **duration:** Session duration in seconds.<br>   **ueAddr:** The ipv4 address of the user equipment.<br>   **asAddr:** The ipv4 address of the application server.<br>   **uePort (optional):** The requested port(s) on the user equipment.<br>   **asPort (optional):** The requested port(s) on the user equipment.<br>   **protocolIn:** The used transport protocol for the uplink.<br>   **protocolOut:** The used transport protocol for the downlink.<br>   **qos:** Qualifier of the requested Latency profile.<br>   **notificationUri (optional):** URI of the callback receiver.<br>   **notificationAuthToken (optional):** Authentication token for callback API.<br>   **id:** Session ID in UUID format.<br>   **startedAt:** Timestamp of session start in seconds since unix epoch.<br>   **expiresAt:** Timestamp of session expiration if the session was not deleted in seconds since unix epoch.<br><br> **401:** Un-authorised, missing or incorrect authentication.<br> **404:** Session not found.<br> **503:** Service temporarily unavailable. |
<br>

#### QoD Delete Latency QoS Session

| **Deleting QoS Latency session** |
| ---------------------------- |
| **HTTP Request**<br>  DELETE\<base-url>/qos-senf/v1/sessions/{sessionId}<br>**Query Parameters**<br>  No query parameters are defined.<br>**Path Parameters**<br>  sessionId: Session ID that need to terminated.<br>**Request Body Parameters**<br>  No request body parameters are defined.<br><br>**Response**<br> **204:** Session deleted<br> **401:** Un-authorized, missing or incorrect authentication.<br> **404:** Session not found |
<br>

### 4.3 Errors

Since CAMARA QoD API is based on REST design principles and blueprints, well defined community HTTP defined status
codes and families are followed [[https://restfulapi.net/http-status-codes/](https://restfulapi.net/http-status-codes/)] .
Details of HTTP based error/exception codes for the QoD API are described Section 5.2 of each API REST based method.

### 4.4 Policies
N/A

### 4.5 Code Snippets

| ***Listing 1. Sample usage of QoD Latency API*** |
| ------------------------------------------ |
| **#Following is sample JSON used to create QoS session to manage Latency  of the specified App-Flow  {**<br>  **"duration": 86400,**<br>  **"ueAddr": "172.10.0.1",**<br>  **"asAddr": "8.8.8.0/24",**<br>  **"uePorts": "5022",**<br>  **"asPorts": "5025",**<br>  **"protocolIn": "TCP",**<br>  **"protocolOut": "TCP",**<br>  **"qos": "LOW\_LATENCY",**<br><span class="s1">  **"notificationUri":** [<span class="s2">**https://application-server.com/notifications**</span>](https://application-server.com/notifications)**,**</span><br>  **"notificationAuthToken": "c8974e592c2fa383d4a3960714"**<br>**}** |

### 4.6 FAQ's

N/A

## 4.7 Terms

N/A

## 4.8 Release Notes

N/A