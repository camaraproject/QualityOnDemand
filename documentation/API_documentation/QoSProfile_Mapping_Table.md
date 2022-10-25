# QoS Profiles Mapping Table (REFERENCE DRAFT)

Here are two possible examples of mapping tables from QoS Profiles to provided connectivity characteristics. The second example describes a case, where the network is specially prepared in well define geographical areas for supporting Quality on Demand needs.

Example 1: Considering wide-area network usage.
| QOS Profiles labels | Network Service Description | Network Service Constraints |
|----------| --------- | ----------- |
| QOS\_E   | Latency stays stable under congestion (throughput upto 2Mbps). The application bitrate should not exceed 2Mbps. | The service is only provided, when the UE is located within the geographical area, as agreed in the Service Level Agreement.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_L   | DL upto 100Mbps (unlimited?). The 5G System throughput is prioritized up to 100Mbps. At high load, the throughput is capped at 100Mbps and can be degraded to lower effective throughput (without a minimum level).  | The service is only provided, when the UE is located within the home network. |
| QOS\_M   |DL upto 30Mbps. The 5G System throughput is prioritized up to 30Mbps. At high load, the throughput is capped at 30Mbps and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network. |
| QOS\_S   | DL upto 10Mbps. The 5G System throughput is dprioritized up to 10Mbps. At high load, the throughput is capped at 10Mbps and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network. |

**Note:**
This table QOS profile labels is only an example that can be used within Camara for validating the QoD APIs

Example 2: Considering confined area network usage.
| QOS Profiles labels | Network Service Description | Network Service Constraints |
|----------| --------- | ----------- |
| QOS\_E   | Latency stays stable under congestion (throughput upto 2Mbps). The application bitrate should not exceed 2Mbps. | The service is only provided, when the UE is located within the geographical area, as agreed in the Service Level Agreement.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_L   | The 5G System throughput is assured minimum bitrate of 20Mbps and up to 40Mbps. Higher bitrates are possible, but not assured | The service is only provided, when the UE is located in the geographical area as agreed as part of the Service Level Agreement. When the UE is located outside of the geographical area, the 5G System rejects the requested QOS profile. The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_M   | The 5G System throughput is assured for at least 5Mbps and up to 15Mbps. Higher bitrates are possible, but not assured | The service is only provided, when the UE is located in the geographical area as agreed as part of the Service Level Agreement. When the UE is located outside of the geographical area, the 5G System rejects the requested QOS profile. The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_S   | The 5G System throughput is assured for at least 500kbps and up to 1Mbps. Higher bitrates are possible, but not assured. | The service is only provided, when the UE is located in the geographical area as agreed as part of the Service Level Agreement. When the UE is located outside of the geographical area, the 5G System rejects the requested QOS profile. The access to the network service is restricted to a maximal number of simultaneous session. |

**Note:**
The link between the 5G System and the Enterprise network should be provisioned accordingly.