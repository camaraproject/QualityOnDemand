# QA - Tests - Quality on Demand

## Prerequisites

1. Ensure QoD App service is up and running on localhost on port 9091.
2. Ensure that scef/nef server is configured for being available on port 8081.


Command for starting service locally using jar file :-
Please check Readme.md file for QoD service


The following steps are needed to create and deploy docker image for camara cucumber tests:

1. ```mvn clean package```

2. ```docker build -t cucumber .```

3. ```docker run -dp 9091:9091 -p cucumber```
