FROM gcr.io/distroless/java:11 as build
COPY core/target/*.jar app.jar
EXPOSE 9091
EXPOSE 9092
USER 65534:65534
ENTRYPOINT ["java","-jar","-Djava.security.egd=file:/dev/./urandom", "-Dlogging.file.path=/log", "-Dspring.profiles.active=prod", "app.jar"]

