{{- define "milvus.mishards.config" -}}

MAX_WORKERS={{ .Values.mishards.maxWorkers }}

{{- if or .Values.mysql.enabled .Values.externalMysql.enabled }}
SQLALCHEMY_DATABASE_URI={{ template "milvus.mysqlURI" . }}
{{- else }}
SQLALCHEMY_DATABASE_URI={{ template "milvus.sqliteURI" . }}
{{- end }}

DEBUG={{ .Values.mishards.debug }}
SERVER_PORT=19530
WOSERVER=tcp://{{ template "milvus.writable.fullname" . }}:{{ .Values.service.port }}

{{- if eq .Values.mishards.discoveryClassName "static" }}
DISCOVERY_CLASS_NAME=static
DISCOVERY_STATIC_HOSTS={{ template "milvus.writable.fullname" . }},{{ template "milvus.readonly.fullname" . }}
DISCOVERY_STATIC_PORT={{ .Values.service.port }}
{{- else if eq .Values.mishards.discoveryClassName "kubernetes" }}
DISCOVERY_CLASS_NAME=kubernetes
DISCOVERY_KUBERNETES_NAMESPACE={{ .Release.Namespace }}
DISCOVERY_KUBERNETES_IN_CLUSTER=True
DISCOVERY_KUBERNETES_POLL_INTERVAL=10
DISCOVERY_KUBERNETES_POD_PATT={{ template "milvus.readonly.fullname" . }}-.*
DISCOVERY_KUBERNETES_LABEL_SELECTOR=component=readonly
{{- else }}
DISCOVERY_CLASS_NAME={{ .Values.mishards.discoveryClassName }}
{{- end -}}

{{- if .Values.mishards.trace.enabled }}
TRACER_CLASS_NAME={{ .Values.mishards.trace.tracerClassName }}
TRACING_SERVICE_NAME={{ template "milvus.fullname" . }}
TRACING_REPORTING_HOST={{ .Values.mishards.trace.tracingReportingHost }}
TRACING_REPORTING_PORT={{ .Values.mishards.trace.tracingReportingPort }}
{{- end -}}

{{- end -}}