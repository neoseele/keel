# Fortio

## Prerequisite

## Install dependencies

```sh
# add nginx repo to helm
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# update helm repo
helm repo update

# install dependencies
helm dep update
```

## RBAC

> Note: the following `CRB` is needed if the `kubernetes engine admin` IAM role is **NOT** granted to your account

```sh
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value core/account)
```
