{{- define "milvus.proxyconfig" -}}
FROM_EXAMPLE='true'
{{- if .Values.mysql.enabled }}
SQLALCHEMY_DATABASE_URI={{ template "milvus.mysqlURL" . }}
{{- else }}
SQLALCHEMY_DATABASE_URI={{ template "milvus.sqliteURL" . }}
{{- end }}
DEBUG='true'
SERVER_PORT=19530
WOSERVER=tcp://{{ template "milvus.fullname" . }}:19530
DISCOVERY_PLUGIN_PATH=static
DISCOVERY_STATIC_HOSTS={{ template "milvus.fullname" . }},{{ template "milvus.fullname.readonly" . }}
TRACER_CLASS_NAME=jaeger
TRACING_SERVICE_NAME=mishards-demo
TRACING_REPORTING_HOST=jaeger
TRACING_REPORTING_PORT=5775
{{- end -}}
