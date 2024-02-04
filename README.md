
# Side-by-side releases using Kubernetes, ArgoCD, Istio and Ivro

A deployment system for stateless microservices that creates a separate service entry.  Traffic is routed to the "main" release or the "per-branch" release using Istio and the Ivro operators.


The flow works like this:
* The cluster is built and Istio, ArgoCD and Ivro are installed
* httpbin-helm app is deployed via an ArgoCD App "httpinb-staging"
* A Pull-request cause the creation of a ArgoCD App, called "httpbin-staging-branch".  
  * There are two helm releases of the chart, "httpbin-main" and "httpbin-branch{{SHA}}"
* The helm charts deploys VirtualServiceHttpRoute
* The VirtualServiceHttpRoute defines routing to the branch release based on a magic header, called "X-Context".
* The helm chart, when the release is "main", deploys the VirtualServiceBase resource
* Ivro creates a new VirtualService out of the VirtualServiceHttpRoute and the VirtualServiceBase resources.
* Traffic is routed between the two deployments using the VirtualService


# Notes on limitations:
* "kafkabin" is not yet set up- the demo does not show how message topics are handled
* Naming of branches must be stable
* Some explanation of metrics, alerts and logs is needed
* Service gateway access cannot be changed, it should have its own gateway entry for it alone

# Contents

* argocd - installation of ArgoCD
* argocd_app - define and install ArgoCD AppSets
* helm-microservice - (submodule) microservice helm chart
* httpbin-app - source repository for httpbin and its per-environment Chart and values files
* httpbin-helm - test folder for validating helm deployment of the service
* istio_setup - scripts for installing istio
* ivro - (submodule) Ivro operator repo
* ivro_setup - installation of ivro operator

# Setup

## Install (for minikube)

These instructions change only slightly if you're not using minikube.  Check out the Istio documentation on Ingress Gateways and follow those steps.

* Create a minikube cluster, a tunnel and set the context
```sh
minikube create
minikube tunnel 2> /dev/null &
kubectl config use-context minikube
```

* Install istio with "demo" profile
```sh
pushd istio_setup
./install.sh
popd
```


* Install Ivro from source
```sh
pushd ivro
git pull origin main
make install
make deploy
popd
```

* Install argocd using script
```sh
pushd istio_setup && ./install.sh && popd
```

* Install Argocd and ArgoCD tunnel.  
```sh
pushd argocd && ./install.sh 
./start_tunnel.sh 2>/dev/null &
popd
```

* Create a Github token that has read access to the source repository (https://github.com/bwehrle/httpbin-app) with the following permissions:
  * Read commits and history
  * Read pull requests

* Create the ArgoCD AppSets

```sh
export GITHUB_TOKEN=TOKEN
pushd argocd_app
./setup.zsh create
pop
```

## Validate

* Using ArgoCD you should be able to see the httbin-staging app deployed
```sh
https://localhost:8080/applications?showFavorites=false&proj=&sync=&autoSync=&health=&namespace=&cluster=&labels=
```

* Find ingress host IP and port

If not using minikube, please see the Istio documentaion.

```sh
export INGRESS_NAME=istio-ingressgateway
export INGRESS_NS=istio-system
export INGRESS_HOST=$(kubectl -n "$INGRESS_NS" get service "$INGRESS_NAME" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n "$INGRESS_NS" get service "$INGRESS_NAME" -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n "$INGRESS_NS" get service "$INGRESS_NAME" -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n "$INGRESS_NS" get service "$INGRESS_NAME" -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
```
* Send request using cURL
```sh
curl -s -I -H "Host:httpbin.example.com" -H "X-Context:httpbin-branche3d5720" -w "%{http_code}\n" "http://$INGRESS_HOST:$INGRESS_PORT/status/201"  
```

