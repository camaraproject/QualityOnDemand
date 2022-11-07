# QoS Profiles Mapping Table (REFERENCE DRAFT)

Here are two possible examples of mapping tables from QoS Profiles to provided connectivity characteristics. The intention of the examples is to illustrate a different usages of the defined QoS Profile labels. The first example focuses on a wide area network usage. The second example describes a case, where the network is specially prepared in well define geographical areas for supporting Quality on Demand needs.

## Example 1: Considering wide-area network usage.
| QOS Profile labels | Network Service Description | Network Service Constraints |
|----------| --------- | ----------- |
| QOS\_E   | Latency stays stable under congestion (throughput upto 500kbps). The application bitrate should not exceed 500kbps. | The service is only provided, when the UE is located within the geographical area, according to the agreement with the CSP.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_L   | The 5G System throughput is prioritized up to 20Mbps. At high load, the throughput is capped at 20Mbps and can be degraded to lower effective throughput (without a minimum level).  | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session.|
| QOS\_M   | The 5G System throughput is prioritized up to 8Mbps. At high load, the throughput is capped at 8Mbps and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network. |
| QOS\_S   | The 5G System throughput is dprioritized up to 4Mbps. At high load, the throughput is capped at 4Mbps and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network. |

**Note:**
The QOS profile labels in the table can be used within Camara for validating the QoD APIs.

## Example 2: Considering confined area network usage.
| QOS Profile labels | Network Service Description | Network Service Constraints |
|----------| --------- | ----------- |
| QOS\_E   | Latency stays stable under congestion (throughput upto 500kbps). The application bitrate should not exceed 500kbps. | The service is only provided, when the UE is located within the geographical area, according to the agreement with the CSP.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_L   | The 5G System throughput is statistically assured minimum bitrate of 10Mbps and up to 20Mbps. Higher bitrates are possible, but not assured | The service is only provided, when the UE is located in the geographical area (according to the agreement with the CSP). When the UE is located outside of the geographical area, the 5G System rejects the requested QOS profile.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_M   | The 5G System throughput is statistically assured for at least 5Mbps and up to 10Mbps. Higher bitrates are possible, but not assured | The service is only provided, when the UE is located in the geographical area (according to the agreement with the CSP). When the UE is located outside of the geographical area, the 5G System rejects the requested QOS profile.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_S   | The 5G System throughput is statistically assured for at least 500kbps and up to 1Mbps. Higher bitrates are possible, but not assured. | The service is only provided, when the UE is located in the geographical area (according to the agreement with the CSP). When the UE is located outside of the geographical area, the 5G System rejects the requested QOS profile.<br>The access to the network service is restricted to a maximal number of simultaneous session. |

**Note:**
The link between the 5G System and the Enterprise network should be provisioned accordingly.
