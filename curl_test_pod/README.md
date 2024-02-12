# Install
```sh
kubectl apply -n default -f sleep.yaml
```

# Run curl

```sh
# run curl
export $POD = podname
export $HTTPBINHOST = httpbin-r1.default.svc.cluster.local:8000
kubectl exec -it $POD  -n default -- curl -v $HTTPBINHOST/status/200
```