```bash
mvn clean package
```

```bash
java -noverify -XX:TieredStopAtLevel=1 -jar target/test-startup-time-0.0.1-SNAPSHOT.jar
```

```
Started TestStartupTimeApplication in 1.548 seconds (JVM running for 1.98)

```

```bash
mvn dockerfile:build

docker run altfatterz/test-startup-time
```



Resources:

https://github.com/spotify/dockerfile-maven
https://github.com/dsyer/spring-boot-micro-apps/