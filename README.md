# keel

k8s toolbox

## Prerequesites

```sh
# install tiller
helm init --history-max 200

# add repos
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

# install/upadte dependencies to charts/
helm dep update

# grant yourself cluster-admin role
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value core/account)
```

## Test

```sh
make test
```

## Clean up

```sh
make clean
```
