Analyzing startup time of a very simple Spring Boot app running 

- using `java -jar`, 
- using `Docker` 
- using `Kubernetes` (minikube)

The app is using recommendations from Dave Syer ([@david_syer](https://twitter.com/david_syer)) to make it start faster. See [https://twitter.com/ntschutta/status/1045326765437202432](https://twitter.com/ntschutta/status/1045326765437202432)  
The app is using [Undertow](http://undertow.io/)

#### 1. Clone and build:

```bash
git clone https://github.com/altfatterz/test-startup-time
cd test-startup-time
mvn clean package
```

#### 2. Simple `java -jar` run:
```bash
java -jar target/test-startup-time-0.0.1-SNAPSHOT.jar

...
Started TestStartupTimeApplication in 3.444 seconds (JVM running for 4.038)
```

#### 3. Improve the startup time:

```bash
java -noverify -XX:TieredStopAtLevel=1 -jar target/test-startup-time-0.0.1-SNAPSHOT.jar
...
Started TestStartupTimeApplication in 2.411 seconds (JVM running for 2.828)
```

#### 4. Using `Docker for Mac` with `ENTRYPOINT` (see `Dockerfile`) 
```bash
ENTRYPOINT [ "java", "-noverify", "-XX:TieredStopAtLevel=1", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "/app.jar"]
```

```bash
mvn clean package dockerfile:build
docker run -p 8080:8080 altfatterz/test-startup-time
...
Started TestStartupTimeApplication in 2.172 seconds (JVM running for 2.538)
```

#### 5. Running with Kubernetes using minikube

1. First start minikube: 

```bash
minikube start --memory 4096
```

2. Reuse the Docker daemon:

```bash
eval $(minikube docker-env)
```

3. Build the Docker image

```bash
mvn clean package dockerfile:build
```

4. Run it first using the Docker environment from `minikube`.
 
It turns out to be a bit slower compared to the docker environment from `Docker for Mac`

```bash
docker run -p 8080:8080 altfatterz/test-startup-time
...
Started TestStartupTimeApplication in 2.607 seconds (JVM running for 3.03)
``` 

5. Create a Deployment with a single pod.

```bash
kubectl create -f test-startup-time-deployment.yml
```

Similar startup time:

```bash
kubectl logs test-startup-time-f97f5bcd-sbkms

Started TestStartupTimeApplication in 2.87 seconds (JVM running for 3.332)
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
...
Started TestStartupTimeApplication in 7.702 seconds (JVM running for 8.847)
```

Interesting that the time now increased almost to 3 times. 

#### 5 Tweaking the CPU and memory options

1. Let's re-create the `minikube` environment:

```bash
minikube stop
minikube delete && rm -rf ~/.minikube && rm -rf ~/.kube 
minikube start --memory 4096 --cpus 4
```

and with the following config in `test-startup-time-deployment.yml`

```yaml
        resources:
          limits:
            memory: 256Mi
            cpu: 2
```

a single pod will start under 3 seconds.

```
Started TestStartupTimeApplication in 2.987 seconds (JVM running for 3.585)
```

More details about managing the CPU and memory configuration you can find [here](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container).

2. Let's create 3 pods with the previous configuration:

```bash
kubectl create -f test-startup-time-3-pods-deployment.yml
```

We can see that the only one pods is started, two of them will be indefinitely in `Pending` state, since we don't have 2 cpu resources for each pod.

```
NAME                                READY     STATUS    RESTARTS   AGE
test-startup-time-6fc6b7f99-5s5ft   1/1       Running   0          33s
test-startup-time-6fc6b7f99-n556d   0/1       Pending   0          33s
test-startup-time-6fc6b7f99-z5m95   0/1       Pending   0          33s
```

If we lower the `cpu` to 1.5 then two pods would have been in `Running` state and only one in `Pending`  




Resources:

https://github.com/spotify/dockerfile-maven
https://github.com/dsyer/spring-boot-micro-apps/
http://dolszewski.com/spring/faster-spring-boot-startup/
https://blog.shanelee.name/2017/07/15/jvm-microservice-with-spring-boot-docker-and-kubernetes/
https://github.com/bygui86/enthusiast-producer-service

