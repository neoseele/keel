{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "go-web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "go-web.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "go-web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create frontend name
*/}}
{{- define "go-web.frontend" -}}
{{- printf "%s-frontend" (include "go-web.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create frontend name
*/}}
{{- define "go-web.backend" -}}
{{- printf "%s-backend" (include "go-web.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create mongodb name
*/}}
{{- define "go-web.mongodb" -}}
{{- printf "%s-mongodb" (include "go-web.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create tls secret name
*/}}
{{- define "go-web.backendTLSSecretName" -}}
{{- printf "%s-backend-tls" (include "go-web.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create tls secret name
*/}}
{{- define "go-web.ingressTLSSecretName" -}}
{{- printf "%s-ingress-tls" (include "go-web.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create temp namespace name
This is where the secret creation resources lives
Workaround if the chart is deployed in a istio enabled cluster
Using a temp namespace will ensure the istio sidecar is NOT auto injected to the secret creator job
*/}}
{{- define "go-web.tempNamespaceName" -}}
{{- printf "%s-ns-temp" (include "go-web.fullname" .) | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}