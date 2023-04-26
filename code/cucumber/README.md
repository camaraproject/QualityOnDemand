# QA - Tests - Quality on Demand

## Prerequisites

1. Ensure QoD App service is up and running on localhost on port 9091.
2. Ensure that scef/nef server is configured for being available on port 8081.

## Testing against QoD Service

### Start QoD via JAR-file

1. Please check Readme.md file of the QoD service.
2. Either you have a jar-file or it needs to be generated inside the QoD-service (```mvn package```).
3. The jar-file can be found at /core/target/senf-core-<qod-version>.jar
4. ```java --add-opens=java.base/java.net=ALL-UNNAMED -Dfile.encoding=UTF-8 -jar core/target/senf-core-<qod-version>.jar --spring.profiles.active=local --scef.server.apiroot=http://localhost:8081```

### Start QoD via IDE

If an IDE is used to start the QoD-service, then just a change to the spring-profile "local" is needed during the start.
The service will start per default configuration on port 9091 and connect to "NEF" to http://localhost:8081.

## Docker Camara Cucumber Tests

The following steps are needed to create and deploy docker image for camara cucumber tests:

1. ```mvn clean package```

2. ```docker build -t cucumber . ```

3. ```docker run -dp 9091:9091 -p cucumber```
