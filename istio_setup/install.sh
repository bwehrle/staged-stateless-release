#!/bin/zsh
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.1 TARGET_ARCH=amd_64 sh -
pushd istio-1.20.1
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
popd
