Camara Quality-On-Demand (QoD) documentation provides information about User Story, Interface definition and sample how-to.
The QoD API relies on the telco QoS framework which ensures support for latency and throughput when processing packets of 4G/5G based data connections (App-Flows).

Goal of the QoD API is simplification of operations required by developers and capabilities consumers to manage QoS sessions for App-Flows.
Following documents describes rationale on how to integrate Telco QoS and expose QoD API to developers.

**User Story** [document](/documentation/API_documentation/QoD_Latency_Bandwidth_User_Story) describes rationale for using the QoD API and basic assumptions applicable to developers and end-users of services
deployed on top of the 4G/5G system telecom infrastructure.

**QoD API’s definitions** elaborate interfaces definitions and provide details important for developers (quick-start, how-to, error details and sample code)

* **QoD Latency** [document](/documentation/API_documentation/QoD_Stable_Latency_API) describes API used by developers to request stable latency for App-Flows,
* **QoD Throughput** [document](/documentation/API_documentation/QoD_Stable_Bandwidth_API) describes API used by developers to request stable throughput for App-Flows.

We expect some changes and new API’s definition in future, so the list is not closed and improvements or enhancements can be expected.