
# Side-by-side releases using Kubernetes, ArgoCD, Istio and Ivro

A deployment system for stateless microservices that creates a separate service entry.  Traffic is routed to the "main" release or the "per-branch" release using Istio and the Ivro operators.

This PoC repo does this using httpbin (and later "kafkabin", showing how Kafka async topics are handled).

* httpbin-helm app is deployed via ArgoCD
* branches in the app are deployed as new service
* traffic is routed between the two services using Istio and Ivro


# Setup

* Create minikube cluster
* Install istio with "demo" profile
* Create secret that has access to github repo where httpbin-helm app is stored
* Install argocd using script
* Install argocd apps using script


# Notes on limitations:
* Naming of branches must be stable
* Some explanation of metrics, alerts and logs is needed
* Service gateway access cannot be changed, it should have its own gateway entry for it alone

