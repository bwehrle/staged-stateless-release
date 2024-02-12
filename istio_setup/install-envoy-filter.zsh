#!/bin/zsh

if (( # == 0 )); then
   print >&2 "Usage: $0 (create|delete)"
   exit 1
elif [[ $1 == "create" || $1 == "delete" ]]; then
else
echo >&2 "Usage: $0 (create|delete) [--upsert]"
exit 1
fi

NS=$(kubectl config get-contexts | cut -f 5 -w | tail -n 1)
kubectl config set-context --current --namespace=default

if [[ $1 == "create" ]]; then
kubectl apply -f envoy-request-filter.yaml
kubectl apply -f envoy-response-filter.yaml

elif [[ $1 == "delete" ]]; then
kubectl delete EnvoyFilter context-request-header-filter -n istio-system 
kubectl delete EnvoyFilter context-response-header-filter -n istio-system 
fi

kubectl config set-context --current --namespace=$NS

