{{- define "milvus.mishards.config" -}}
FROM_EXAMPLE='true'

{{- if or .Values.mysql.enabled .Values.externalMysql.enabled }}
SQLALCHEMY_DATABASE_URI={{ template "milvus.mysqlURI" . }}
{{- else }}
SQLALCHEMY_DATABASE_URI={{ template "milvus.sqliteURI" . }}
{{- end }}

DEBUG={{ .Values.mishards.debug }}
SERVER_PORT=19530
WOSERVER=tcp://{{ template "milvus.writable.fullname" . }}:{{ .Values.service.port }}
DISCOVERY_PLUGIN_PATH=static
DISCOVERY_STATIC_HOSTS={{ template "milvus.writable.fullname" . }},{{ template "milvus.readonly.fullname" . }}
DISCOVERY_STATIC_PORT={{ .Values.service.port }}

TRACER_CLASS_NAME=jaeger
TRACING_SERVICE_NAME=mishards-demo
TRACING_REPORTING_HOST=jaeger
TRACING_REPORTING_PORT=5775
{{- end -}}