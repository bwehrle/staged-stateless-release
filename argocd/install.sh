#!/bin/zsh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
argocd admin initial-password -n argocd
argocd cluster add $(kubectl config current-context)