FROM openjdk:8-jre-alpine
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-noverify", "-XX:TieredStopAtLevel=1", "-jar", "/app.jar"]