#!/bin/zsh
kubectl create namespace http-helm
kubectl label namespace istio-injection=enabled