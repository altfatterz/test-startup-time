FROM openjdk:8-jre-alpine
ARG JAR_FILE
COPY ${JAR_FILE} app.jar

# https://blogs.oracle.com/java-platform-group/java-se-support-for-docker-cpu-and-memory-limits
# ENV JVM_LIMIT_OPTS='-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:TieredStopAtLevel=1'

ENTRYPOINT [ "java", "-noverify", "-Xmx1024m", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-XX:TieredStopAtLevel=1", "-jar", "/app.jar"]