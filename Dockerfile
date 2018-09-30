FROM openjdk:8-jre-alpine
MAINTAINER Zoltan Altfatter <altfatterz@gmail.com>
ENTRYPOINT ["/usr/bin/java", "-jar", "/usr/share/myservice/myservice.jar"]
ARG JAR_FILE
ADD ${JAR_FILE} /usr/share/myservice/myservice.jar