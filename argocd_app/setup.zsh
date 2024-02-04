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
argocd repocreds add https://github.com/bwehrle --username bwehrle --password $GITHUB_TOKEN --upsert
argocd appset create $2 appset-clusterlist.yaml  --upsert
argocd appset create $2 appset-pullrequest.yaml  --upsert
sed -e "s|MYTOKEN|$GITHUB_TOKEN|g" github-secret.yaml | kubectl apply -f -

elif [[ $1 == "delete" ]]; then
argocd appset $1 -y httpbin-staging
argocd appset $1 -y httpbin-staging-branch
kubectl delete secret github-access-token -n argocd
fi

kubectl config set-context --current --namespace=$NS
