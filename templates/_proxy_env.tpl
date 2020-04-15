{{- define "milvus.proxyconfig" -}}
{{- $_ := set . "deploy_name" "readonly" -}}
{{- $ro_milvus := include "milvus.fullname" . -}}
{{- $_ := set . "deploy_name" "writeonly" -}}
{{- $wo_milvus := include "milvus.fullname" . -}}
FROM_EXAMPLE='true'
SQLALCHEMY_DATABASE_URI={{ template "milvus.mysqlURL" . }}
DEBUG='true'
SERVER_PORT=19530
WOSERVER=tcp://{{ $wo_milvus }}:19530
DISCOVERY_PLUGIN_PATH=static
DISCOVERY_STATIC_HOSTS={{ $wo_milvus }},{{ $ro_milvus }}
TRACER_CLASS_NAME=jaeger
TRACING_SERVICE_NAME=mishards-demo
TRACING_REPORTING_HOST=jaeger
TRACING_REPORTING_PORT=5775
{{- end -}}
