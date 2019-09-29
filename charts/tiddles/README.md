# Tiddle

A mini-microservice stack consists:

- 1 frontend service
- 2 backend services (v1 and v2)
  - v2 is backed by a mongodb service
- opencensus instrumented for SD tracing

## Deploy

```sh
# create deployments (frontend, backend-v1 and backend-v2)
# expose frontend as NodePort service
# expose both backends as ClusterIP service
keel_run -r dev -a

# create deployments
# expose frontend as NodePort service
# expose both backends as ClusterIP service
# expose frontend service via ingress with neg
keel_run -r dev -f examples/values-ing.yaml -a

# create deployments in istio-workload namespace
# expose frontend as ClusterIP service
# expose both backends as ClusterIP service
# create istio objects (vs,dr etc)
# expose frontend service via istio-ingressgateway
keel_run -r dev -f examples/values-istio.yaml -n istio-workload -a
```

## Clean up

> substitute `-a` with `-d`
