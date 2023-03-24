Readme file for QoD API's basic cucumber tests.


 Assumptions:-
1) As per current implemetation ,we assume QoD API service is deployed and running on BASE_URL(Parameter used in AppConfig for FQDN).
2) All dependency are successfully downloaded.

 Steps  :-
1) Update BASE_URL with FQDN(Parameter used in AppConfig.java file).
2) Update msisdn with real devices values (In cucumber /src/test/java/stepDefinitions/AppConfig.java File).

- Reports will get generated after every run in location /cucumber/target/cucumber-reports/ .Sample files are attached for reference.
- Plan to integrate mockserver with our test cases so that they can run independently.
