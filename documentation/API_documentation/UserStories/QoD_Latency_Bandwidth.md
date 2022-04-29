# QoD Stable Bandwidth and Latency API User Story
<br>
## Introduction

The goal of the document is to elaborate User Story of Quality-On-Demand API to be included in the Application Services deployed on top of the 4G/5G System Telco Infrastructure.
The Quality-On-Deamnd (QoD) API will be used by Application Vendors, Developers and End-Users to support flexible management of Latency and Bandwidth of any application which run in Mobile environment
utilising 4G/5G connectivity.

## Telco QoS Overview

There are many categories of Application Services such as IIoT applications, Gaming and other Smart solutions which will gain from Quality-On-Demand solutions.
Those Application Services will integrate Telco QoS management (i.e. latency and Bandwidth) via API’s to be included in Applications by Developers.
Using the API, also End-Users will be able to specify Latency and Bandwith via "User preferences" and Application Vendors can also be equiped with interface for QoS profiles management.

The QoD API will rely on Telco QoS framework which provides support for ensuring required latency and bandwidth when processing data plane packets with 4G/5G RAN data plane.
Several cases and actors are considered to manage QoS Latency and Throughput and only some of them will utilize QoD API while remaining will rely on static rules:

* **Subscribed QoS profile management**: In the scenario 5G System chooses and UE Subscribed QoS profile where all profiles are stored in the system.
The application is not required to configure any profiles since pre-configured QoS profiles are automatically applied to the application connection from the UE terminal.
*In the case QoD API, can be used for already established connection to change the QoS profile.*
* **Application-detection based QoS Latency/Throughput management:** Application Vendor will use assigned Application ID’s to associate pre-configured profile which Packet Flow Descriptors (PFD)
which include application data protocol information (IP addr, port number and URL). If the UPF detects a data flow that matches the preconfigured packet filters,
the 5G network automatically applies preconfigured QoS values to it. In such case on action on the Application is required since QoS profile assignment is triggered automatically
based on configured policies.
*In the case QoD API could be applicable to manage profiles of PFD/QoS and already established connections.*
* **UE Managed QoS Latency/Throughput management:** Once Application Client is being activated on the UE, QoS management module integrated within UE OS software or Application Client
will invoke Quality-On-Demand API to specify Latency or Throughput profile. The QoS management module with QoD integration provides complete flexibility for defining and modifying QoS
profiles of already established connections or those which will be established. To support such operation proper profiles, need to be configured within 5G System to fit UE subscription profile, network configuration and current network conditions.

## User Story Description

Quality-On-Demand API will provide REST based API to specify required Latency or Throughput for data traffic utilized by Application Services deployed on the 4G/5G System.
Following table elaborates details (such as roles,constraints, activities) of QoD API to support Latency and/or Bandwidth QoS profiles management.

| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As a API-User (Developer, Vendor, App End-User) I want to have possibility to adjust QoS profile data connection<br>for defined Application running on the UE terminal to adjust Latency/Bandwidth |
| ***Roles*** | 1.  Application Developer which integrates QoD API into Client Application to enable dynamic Latency/Bandwidth configuration<br>2.  Application End-User which can selectively adjust QoS Profile of data connection for selected application |
| ***NF Requirements*** | The 4G/5G System needs to be exposed by the SCEF/NEF exposure functions which provide capabilities of the Telco infrastructure<br>by the external API consumers such as QoD API.<br>The QoS management API need to support 3GPP standard [] or another proprietary interface partially aligned with the standard.<br> |
| ***Pre-conditions*** | There are several preconditions to support dynamic QoS profile management of Application data communication links (DL Downlinks/UL Up-Links) via QoD API.<br>1\. 5G System configured with QoS profiles and support QI identifiers mappings \[\]\.<br> The mapping might differ among operators/vendors and should expect that more detailed blueprints will be provided by other standardisation communities (e.g. GSMA).<br>2\. 5G System support for QoS management of Latency/Bandwidth need to be exposed by the NEF/SCEF\.<br>3\. UE terminals need to extend with QoD module to enable Application End\-User to invoke QoD API operations\.<br> The QoD module is integrated/customized by the Application Developer or can be distributed as standard library/SDK within UE software.<br>4\. QoD API authentication and other security aspects need to configured and provided to Developer/End\-User\. |
| ***Activities/Steps*** | **Starts when:** User decides to change Quality of the data connection link for throughput / latency profile based on “reservation”.<br>**Step 1:** User is being authenticated and QoS session is created and proper context established to operate on the “specified” data communication link (IP addr/port and protocol for uplink/downlink).<br>User is also returned the QoS  Session notification channel to be informed about related events<br>**Step 2:** User decides for the QoS profile flavor of Latency/Throughput within the QoS session and invokes the QoD API operation.<br>**Step 3:** QoD API backend communicates with 5G System NEF to modify the QoS session data communication link profile.<br>**Step 4:** In case of internal errors of the Step 3, User is informed about the error / reason and how to proceed further, and any other activities are canceled / reverted.<br>**Step 5:** In case of the Step 3 is successful, data connection link is modified for the request QoS profile flavor and user might expect quality according to profile.<br>Depend on the underlying 5G System technology and other internals some “adaptation time” might be required to have the data link with bandwidth/latency quality profile.<br>**Step 6:** In case of established session for the session some operations can be invoked : notification callbacks, session details  <br>**Ends when:** User decides to release the reserved resources for the QoS Session. |
| ***Post-conditions*** | Once the QoS session is released , QoS profile based on subscriber configuration is applied to the data communication link. |
| ***Exceptions*** | Several exceptions might occur during the QoD API operations<br>- Unauthorized: Not valid credentials or other security issues (lack of proper rights for example).<br>- Invalid input: Not valid input data to invoke operation (e.g. data communication link ID).<br>- Conflict: Internal configuration policies didn’t allow for operations. Other causes possible and might be specific to operator/vendor.<br>- Session-not-created: Due to other internal errors, QoS session can’t be created <span class="Apple-converted-space"> </span> |
<br>
\* Above table can be extenend/modified and new User stories added