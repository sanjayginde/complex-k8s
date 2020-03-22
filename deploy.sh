#!/bin/bash

openssl aes-256-cbc -K $encrypted_9f3b5599b056_key -iv $encrypted_9f3b5599b056_iv -in service-account.json.enc -out service-account.json -d
curl https://sdk.cloud.google.com | bash > /dev/null;
source $HOME/google-cloud-sdk/path.bash.inc
gcloud components update kubectl
gcloud auth activate-service-account --key-file service-account.json
gcloud config set project complex-k8s-271222
gcloud config set compute/zone us-east1-c
gcloud container clusters get-credentials multi-cluster

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
