#!/bin/bash

docker build \
  -t sanjayginde/complex-k8s-client:latest \
  -t sanjayginde/complex-k8s-client:$GIT_SHA \
  -f ./client/Dockerfile ./client

docker build \
  -t sanjayginde/complex-k8s-server:latest \
  -t sanjayginde/complex-k8s-server:$GIT_SHA \
  -f ./server/Dockerfile ./server

docker build \
  -t sanjayginde/complex-k8s-worker:latest \
  -t sanjayginde/complex-k8s-worker:$GIT_SHA \
  -f ./worker/Dockerfile ./worker

docker push sanjayginde/complex-k8s-client:latest
docker push sanjayginde/complex-k8s-client:$GIT_SHA

docker push sanjayginde/complex-k8s-server:latest
docker push sanjayginde/complex-k8s-server:$GIT_SHA

docker push sanjayginde/complex-k8s-worker:latest
docker push sanjayginde/complex-k8s-worker:$GIT_SHA

kubectl apply -f ./k8s

kubectl set image deployments/client-deployment client=sanjayginde/complex-k8s-client:$GIT_SHA
kubectl set image deployments/server-deployment server=sanjayginde/complex-k8s-server:$GIT_SHA
kubectl set image deployments/worker-deployment worker=sanjayginde/complex-k8s-worker:$GIT_SHA
