#!/bin/zsh
pushd ../ivro
kubectl config set-context --current --namespace=default   
make build
make install
make deploy
popd

