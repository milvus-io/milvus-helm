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
Create a default fully qualified standalone name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.standalone.fullname" -}}
{{ template "milvus.fullname" . }}-standalone
{{- end -}}

{{/*
Create a default fully qualified Root Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.rootcoord.fullname" -}}
{{ template "milvus.fullname" . }}-rootcoord
{{- end -}}

{{/*
Create a default fully qualified Proxy name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.proxy.fullname" -}}
{{ template "milvus.fullname" . }}-proxy
{{- end -}}

{{/*
Create a default fully qualified Query Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.querycoord.fullname" -}}
{{ template "milvus.fullname" . }}-querycoord
{{- end -}}

{{/*
Create a default fully qualified Query Node name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.querynode.fullname" -}}
{{ template "milvus.fullname" . }}-querynode
{{- end -}}

{{/*
Create a default fully qualified Index Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.indexcoord.fullname" -}}
{{ template "milvus.fullname" . }}-indexcoord
{{- end -}}

{{/*
Create a default fully qualified Index Node name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.indexnode.fullname" -}}
{{ template "milvus.fullname" . }}-indexnode
{{- end -}}

{{/*
Create a default fully qualified Data Coordinator name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.datacoord.fullname" -}}
{{ template "milvus.fullname" . }}-datacoord
{{- end -}}

{{/*
Create a default fully qualified Data Node name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.datanode.fullname" -}}
{{ template "milvus.fullname" . }}-datanode
{{- end -}}

{{/*
Create a default fully qualified pulsar name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.pulsar.fullname" -}}
{{- $name := .Values.pulsar.name -}}
{{- if contains $name .Release.Name -}}
{{ .Release.Name }}
{{- else -}}
{{ .Release.Name }}-pulsar
{{- end -}}
{{- end -}}

{/*
Create a default fully qualified attu name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.attu.fullname" -}}
{{ template "milvus.fullname" . }}-attu
{{- end -}}

{{/*
Create milvus attu env name.
*/}}
{{- define "milvus.attu.env" -}}
- name: HOST_URL
{{- if .Values.attu.ingress.enabled }}
  value: https://{{ first .Values.attu.ingress.hosts }}
{{- else }}
  value: http://{{ template "milvus.attu.fullname" .}}:3000
{{- end }}
- name: MILVUS_URL
  value: http://{{ template "milvus.fullname" .}}:19530
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "milvus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Helm required labels */}}
{{- define "milvus.labels" -}}
helm.sh/chart: {{ include "milvus.chart" . }}
{{ include "milvus.matchLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* matchLabels */}}
{{- define "milvus.matchLabels" -}}
app.kubernetes.io/name: {{ include "milvus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
