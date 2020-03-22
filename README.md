# "Complex" Kubernetes

## Local setup (using Minikube)
1. Boot up Minikube
    ```bash
    $ minikube start
    ```
1. Install `ingress-nginx` on MiniKube
    ```bash
    $ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml
    $ minikube addons enable ingress
    ```
1. Set a Postgres password as a Kubernetes secret
    ```bash
    $ kubectl create secret generic pgpassword --from-literal PGPASSWORD=<your password>
    ```
1. Apply Kubernetes conigs
    ```bash
    $ kubectl apply -f k8s
    ```

## Cluster setup (on Google Cloud Kubernetes Engine)
1. Set up cluster (e.g. via Google Cloud web console)
1. Set a Postgres password as a Kubernetes secret
    ```bash
    $ kubectl create secret generic pgpassword --from-literal PGPASSWORD=<your password>
    ```
1. Install Helm (v3)
    ```bash
    $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    $ chmod 700 get_helm.sh
    $ ./get_helm.sh
    ```
1. Install `nginx-ingress` chart
    ```bash
    $ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    $ helm repo update
    $ helm install my-nginx stage/nginx-ingress --set rbac.create=true
    ```
1. Install certificate manager
    ```bash
    $ kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
    $ kubectl create namespace cert-manager
    $ helm repo add jetstack https://charts.jetstack.io
    $ helm repo update
    $ helm install cert-manager --namespace cert-manager --version v0.11.0 jetstack/cert-manager
    ```
