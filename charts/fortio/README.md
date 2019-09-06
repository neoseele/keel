# fortio

## add repos

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

## install/upadte dependencies to charts/

```sh
helm dep update
```

## grant yourself cluster-admin role

```sh
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value core/account)
```
