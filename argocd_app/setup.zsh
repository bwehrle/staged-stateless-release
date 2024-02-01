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
kubectl config set-context --current --namespace=argocd

if [[ $1 == "create" ]]; then
argocd appset create $2 appset-clusterlist.yaml
argocd appset create $2 appset-pullrequest.yaml
elif [[ $1 == "delete" ]]; then
argocd appset $1 -y guestbook
argocd appset $1 -y guestbook-staging
fi

kubectl config set-context --current --namespace=$NS
