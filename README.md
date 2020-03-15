Before running the application, the Postgres pasword needs to be set as a Kubernetes secret.

```bash
$ kubectl create secret generic pgpassword --from-literal PGPASSWORD=<your password>
```

To boot up the application with MiniKube

```bash
$ minikube start
$ kubectl apply k8s
```
