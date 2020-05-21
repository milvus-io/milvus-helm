{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "milvus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "milvus.fullname" -}}
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
Create a default fully qualified mishards name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.mishards.fullname" -}}
{{ template "milvus.fullname" . }}-mishards
{{- end -}}

{{/*
Create a default fully qualified ro-milvus name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.readonly.fullname" -}}
{{ template "milvus.fullname" . }}-readonly
{{- end -}}

{{/*
Create a default fully qualified writable-milvus name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.writable.fullname" -}}
{{ template "milvus.fullname" . }}-writable
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "milvus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "milvus.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "milvus.name" . }}"
{{- end -}}

{{/* matchLabels */}}
{{- define "milvus.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "milvus.name" . }}"
{{- end -}}

{{/*
Create the name of the service account to use for the mishards component
*/}}
{{- define "milvus.serviceAccountName.mishards" -}}
{{- if .Values.serviceAccounts.mishards.create -}}
    {{ default (include "milvus.mishards.fullname" .) .Values.serviceAccounts.mishards.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.mishards.name }}
{{- end -}}
{{- end -}}

{{/* Milvus backend URL */}}
{{- define "milvus.mysqlURL" -}}
mysql://root:{{ .Values.mysql.mysqlRootPassword }}@{{ .Release.Name }}-mysql:3306/{{ .Values.mysql.mysqlDatabase }}
{{- end -}}
{{- define "milvus.sqliteURL" -}}
sqlite://:@:/
{{- end -}}

{{- define "svc.name" -}}
{{- if .Values.cluster.enabled }}
mishards
{{- else }}
standalone
{{- end }}
{{- end -}}

{{- define "svc.fullname" -}}
{{- if .Values.cluster.enabled }}
{{ template "milvus.mishards.fullname" . }}
{{- else }}
{{ template "milvus.fullname" . }}
{{- end }}
{{- end -}}