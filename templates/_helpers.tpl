{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "milvus.name" -}}
{{- printf "%s-%s" .Chart.Name "server" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name "server" | trunc 63 | trimSuffix "-" -}}
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

{{/* Milvus backend URL */}}
{{- define "milvus.mysqlURL" -}}
mysql://root:{{ .Values.mysql.mysqlRootPassword }}@{{ .Release.Name }}-mysql:3306/{{ .Values.mysql.mysqlDatabase }}
{{- end -}}
{{- define "milvus.sqliteURL" -}}
sqlite://:@:/
{{- end -}}

{{/* share between romilvus and womilvus  */}}
{{- define "milvus.sharename" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the milvus-readonly.
*/}}
{{- define "milvus.name.readonly" -}}
{{- printf "%s-%s" .Chart.Name "readonly" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "milvus.fullname.readonly" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name "readonly" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* milvus-readonly labels */}}
{{- define "milvus.labels.readonly" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "milvus.name.readonly" . }}"
{{- end -}}

{{/* milvus-readonly matchLabels */}}
{{- define "milvus.matchLabels.readonly" -}}
release: {{ .Release.Name }}
app: "{{ template "milvus.name.readonly" . }}"
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the mishards.
*/}}
{{- define "mishards.name" -}}
{{- printf "%s-%s" .Chart.Name "mishards" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mishards.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name "mishards" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* mishards labels */}}
{{- define "mishards.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "mishards.name" . }}"
{{- end -}}

{{/* mishards matchLabels */}}
{{- define "mishards.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "mishards.name" . }}"
{{- end -}}