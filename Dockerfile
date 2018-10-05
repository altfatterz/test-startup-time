FROM openjdk:8-jre-alpine
ARG JAR_FILE
COPY ${JAR_FILE} app.jar

# https://blogs.oracle.com/java-platform-group/java-se-support-for-docker-cpu-and-memory-limits
# To tell the JVM to be aware of Docker memory limits in the absence of setting a maximum Java heap via -Xmx,
# there are two JVM command line options required, -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap.

ENTRYPOINT [ "java", "-noverify", "-XX:TieredStopAtLevel=1", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "/app.jar"]