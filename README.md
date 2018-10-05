```bash
mvn clean package
```

```bash
java -jar target/test-startup-time-0.0.1-SNAPSHOT.jar

...
2018-10-05 10:02:11.744  INFO 64642 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 3.444 seconds (JVM running for 4.038)
```

```bash
java -noverify -XX:TieredStopAtLevel=1 -jar target/test-startup-time-0.0.1-SNAPSHOT.jar
```
...
2018-10-05 10:04:25.233  INFO 64751 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 2.411 seconds (JVM running for 2.828)
```
Started TestStartupTimeApplication in 2.157 seconds (JVM running for 2.565)
```

Using `Docker for Mac` with `ENTRYPOINT` (see `Dockerfile`) 
```bash
ENTRYPOINT [ "java", "-noverify", "-XX:TieredStopAtLevel=1", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "/app.jar"]
```

```bash
mvn clean package dockerfile:build
docker run -p 8080:8080 altfatterz/test-startup-time
...
2018-10-05 08:23:49.686  INFO 1 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 2.172 seconds (JVM running for 2.538)
```

# Running with Kubernetes using minikube

1. Start minikube 

```bash
minikube start --memory 4096
```

2. Reusing  the Docker daemon

```bash
eval $(minikube docker-env)
```

3. Build the Docker image

```bash
mvn clean package dockerfile:build
```

4. Run it first using the Docker environment from `minikube`. 
Turns out to be a bit slower compared to the docker environment from `Docker for Mac`

```bash
docker run -p 8080:8080 altfatterz/test-startup-time
...
2018-10-05 08:27:22.257  INFO 1 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 2.607 seconds (JVM running for 3.03)
``` 

5. Create a Deployment with a single pod.

```bash
kubectl create -f test-startup-time-deployment.yml
```

Similar startup time:

```bash
kubectl logs test-startup-time-f97f5bcd-sbkms

2018-10-05 08:46:21.032  INFO 1 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 2.87 seconds (JVM running for 3.332)
```

6. Create a Deployment with 3 pods

First clean the deployment:
```bash
kubectl delete deployment test-startup-time
```

```bash
kubectl create -f test-startup-time-3-deployment.yml
```

```bash
kubectl logs test-startup-time-f97f5bcd-hd948
2018-10-05 08:49:40.668  INFO 1 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 7.702 seconds (JVM running for 8.847)
```

Interesting that the time now increased almost to 3 times.



Resources:

https://github.com/spotify/dockerfile-maven
https://github.com/dsyer/spring-boot-micro-apps/
http://dolszewski.com/spring/faster-spring-boot-startup/
https://blog.shanelee.name/2017/07/15/jvm-microservice-with-spring-boot-docker-and-kubernetes/
https://github.com/bygui86/enthusiast-producer-service
```bash
java -XX:+PrintFlagsFinal -version
```

