# QoS Profiles Mapping Table (REFERENCE DRAFT)

Here is one possible example of mapping table from QoS Profiles to provided connectivity characteristics. The intention of the examples is to illustrate the principle usage of the defined QoS Profile labels. It focus on connectivity characteristics in a wide area network usage.

It is generally assumed that there exists an agreement between the API Invoker and the communication service provider (CSP, which defines the service levels, conditions and restrictions. The agreement is not further detailed out here. In this sense the table below can be considered only as an example. 

## Example: Considering wide-area network usage.
| QOS Profile labels | Network Service Description | Network Service Constraints |
|----------| --------- | ----------- |
| QOS\_E   | Latency stays stable under congestion (throughput upto 500kbps). The application bitrate should not exceed 500kbps. | The service is only provided, when the UE is located within the geographical area, according to the agreement with the CSP.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_L   | The 5G System throughput is prioritized up to 20Mbps. At high load, the throughput is capped at 20Mbps and can be degraded to lower effective throughput (without a minimum level).  | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_M   | The 5G System throughput is prioritized up to 8Mbps. At high load, the throughput is capped at 8Mbps and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_S   | The 5G System throughput is dprioritized up to 4Mbps. At high load, the throughput is capped at 4Mbps and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session. |

**Note:**
The QOS profile labels in the table can be used within Camara for validating the QoD APIs.
