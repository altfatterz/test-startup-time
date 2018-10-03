```bash
mvn clean package
```

```bash
java -noverify -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:TieredStopAtLevel=1 -jar target/test-startup-time-0.0.1-SNAPSHOT.jar
```

```
Started TestStartupTimeApplication in 2.157 seconds (JVM running for 2.565)
```

```bash
mvn clean package dockerfile:build
docker run -p 8080:8080 altfatterz/test-startup-time
```

```
Started TestStartupTimeApplication in 3.093 seconds (JVM running for 3.74)
```

# Running with Kubernetes

1. Start minikube

```bash
minikube start
```

2. Reusing  the Docker daemon

```bash
eval $(minikube docker-env)
```

3. Build the Docker image

```bash
mvn clean package dockerfile:build
```

4. Create the deployment

```bash
kubectl run test-startup-time --image=altfatterz/test-startup-time:latest --port=8080 --image-pull-policy Never
```

5. Verify the deployment

```bash
kubectl get deployments

NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
test-startup-time   1         1         1            1           4s
```

```bash
kubectl get pods

NAME                                 READY     STATUS    RESTARTS   AGE
test-startup-time-6d99f46548-qp8q8   1/1       Running   0          29s
```

```bash
kubectl logs test-startup-time-6d99f46548-qp8q8

...
2018-10-02 12:38:27.153  INFO 1 --- [           main] o.s.b.w.e.u.UndertowServletWebServer     : Undertow started on port(s) 8080 (http) with context path ''
2018-10-02 12:38:27.157  INFO 1 --- [           main] c.e.t.TestStartupTimeApplication         : Started TestStartupTimeApplication in 5.33 seconds (JVM running for 6.088)
```

6. Creating a service for the deployment

```bash
kubectl expose deployment test-startup-time --type=NodePort
```

```bash
kubectl get services

NAME                TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
kubernetes          ClusterIP   10.96.0.1      <none>        443/TCP          1d
test-startup-time   NodePort    10.97.198.62   <none>        8080:30706/TCP   5s
```

`-–type=NodePort` makes the service available from outside of the cluster. It will be available at <NodeIP>:<NodePort>
The `NodePort` is set by the cluster automatically.

7. Calling the service

```bash
minikube service demo
```
Opens up in a browser: http://192.168.99.100:30706/


8. Restart a pod

```bash
kubectl get pods
kubectl delete pod test-startup-time-6d99f46548-wddvq

kubectl get pods
NAME                                 READY     STATUS        RESTARTS   AGE
test-startup-time-6d99f46548-m5mnn   1/1       Running       0          8s
test-startup-time-6d99f46548-wddvq   0/1       Terminating   0          12m
```

9. Cleanup

```bash
kubectl delete services test-startup-time
kubectl delete deployment test-startup-time
```


10. Using the `test-startup-time-deployment.yml`

```bash
kubectl create -f test-startup-time-deployment.yml
```




```bash
java -XX:+PrintFlagsFinal -version
```


Resources:

https://github.com/spotify/dockerfile-maven
https://github.com/dsyer/spring-boot-micro-apps/
http://dolszewski.com/spring/faster-spring-boot-startup/
https://blog.shanelee.name/2017/07/15/jvm-microservice-with-spring-boot-docker-and-kubernetes/

