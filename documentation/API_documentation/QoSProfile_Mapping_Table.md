# QoS Profiles Mapping Table (REFERENCE DRAFT)

Here is one possible example of mapping table from QoS Profiles to provided connectivity characteristics. The intention of the examples is to illustrate the principle usage of the defined QoS Profile labels. It focus on connectivity characteristics in a wide area network usage.

It is generally assumed that there exists an agreement between the API Invoker and the communication service provider (CSP, which defines the service levels, conditions and restrictions. The agreement is not further detailed out here. In this sense the table below can be considered only as an example.

## Example: Considering wide-area network usage

| QOS Profile labels | Network Service Description | Network Service Constraints |
|----------| --------- | ----------- |
| QOS\_E   | Latency stays stable under congestion (throughput up to a certain limit, e.g. 500kbps). The application bitrate should not exceed the limit. | The service is only provided, when the UE is located within the geographical area, according to the agreement with the CSP.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_L   | The 5G System throughput is prioritized up to certain higher limit (e.g. 20Mbps), or without an explicit limit. At high load, the throughput may be capped at the limit and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_M   | The 5G System throughput is prioritized up to certain medium limit (e.g. 8Mbps). At high load, the throughput may be capped at the limit and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session. |
| QOS\_S   | The 5G System throughput is prioritized up to certain lower limit (e.g. 4Mbps). At high load, the throughput may be capped at the limit and can be degraded to lower effective throughput (without a minimum level). | The service is only provided, when the UE is located within the home network.<br>The access to the network service is restricted to a maximal number of simultaneous session. |

**Note:**
The QOS profile labels in the table can be used within Camara for validating the QoD APIs.

## ExtendedQosProfile

This is a revised proposal based on feedback.

![QoS Profile Design - get-only (2)](https://user-images.githubusercontent.com/1365512/227522409-10471fb7-ea91-4061-961c-bc07a70bcc4f.svg)

### id: string (required)

The id is a unique string for the QoS profile following the UUID format.

### name: string (required)

The name is a descriptive string for the profile.  This is not unique.

## status: QosProfileStatusEnum (required)

The status is the current state for the QoS profile with one of the following values:

* Active - This profile is active and available to be used.
* Inactive - This profile is not available and can not be used at this time.
* Deprecated - This profile may be in use, but can not be added to new QoS sessions.

### targetMinimumUpstreamRate: Rate (Optional)

This is the target minimum upstream rate for this profile.

### maxUpstreamRate: Rate (Optional)

This is the maximum sustained upstream rate for this profile.  If this is undefined, then the maxUpstream rate will not change.

If this rate is lower than the current provisioned maximum sustained rate, then the current rate is used.

### maxUpstreamBurstRate: Rate (Optional)

This is the maximum burst upstream rate for this profile.  If this is undefined, then the maxUpstream rate will not change.

If this rate is lower than the current provisioned maximum rate, then the current maximum burst rate is used.

### targetMinimumDownstreamRate: Rate (Optional)

This is the target or minimum downstream rate for this profile.

### maxDownstreamRate: Rate (Optional)

This is the maximum sustained downstream rate for this profile.  If this is undefined, then the maxUpstream rate will not change.

If this rate is lower than the current provisioned maximum sustained rate, then the current rate is used.

### maxDownstreamBurstRate: Rate (Optional)

This is the maximum burst downstream rate for this profile.  If this is undefined, then the maxUpstream rate will not change.

If this rate is lower than the current provisioned maximum rate, then the current maximum burst rate is used.

### minDuration: Duration  (Optional)

The minium period of time that this profile can be allocated.

### maxDuration: Duration (Optional)

The maximum period of time that this profile can be allocated.

### priority: float (required)

The priority of the traffic.  This is a float between 1 and 10.  The lower the value the higher the priority.

### packetDelayBudget: Duration (Optional)

The packet delay budget defines an upper bound for the time that a packet may be delayed between the user device and the core network.  This is the round trip latency of the access network, and doesn't include any transit or other network elements.

### jitter: Duration (Optional)

Jitter refers to the variation in the time it takes for none queue building packets to travel across a network measured in milliseconds (ms). In terms of maximum deviation for round trip latency on a network, jitter can be defined as the difference between the highest and lowest latency values experienced by the 99th percentile of traffic.

To be more specific, if we consider the round trip latency values of the 99th percentile of traffic, jitter is the measure of how much these values deviate from the average round trip latency for this percentile. A low jitter value indicates that the latency values are relatively consistent, whereas a high jitter value implies that there is a significant variation in latency times, which can negatively impact the performance of real-time applications such as VoIP, video conferencing, and online gaming.

### packetErrorLossRate: int  (Optional)

This is a negative integer for the the exponent for the loss rate.  Where a loss rate of '-5' would mean that no more than 10<sup>−5</sup> packets will be lost.

### Examples

#### Conversational voice

```json
{
  id:"123e4567-e89b-12d3-a456-426614174000",
  name:"QCI_1_voice",
  status:"Active",
  targetMinimumUpstreamRate:{ value:128 unit:"Kbps"},
  targetMinimumDownstreamRate: { value:128 unit:"Kbps"},
  priority: 2.0,
  DelayBudget: { value:100 unit:"ms"},
  packetErrorLossRate: 2
}
```

#### OTT Streaming Video with Buffering

```json
{
  id:"123e4567-e89b-12d3-a456-426614174000",
  name:"QCI_6_buffered_video",
  status:"Active",
  maxUpstreamRate:{ value:512 unit:"Kbps"},
  maxDownstreamRate: { value:512 unit:"Kbps"},
  priority: 6.0,
  DelayBudget: { value:300 unit:"ms"},
  packetErrorLossRate: 6
}
```
