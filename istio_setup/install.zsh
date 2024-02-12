#!/bin/zsh
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.2 TARGET_ARCH=amd64 sh -
pushd istio-1.20.2
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
popd
