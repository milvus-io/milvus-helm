{{- define "milvus.nginx.config" -}}
events {}
http {
    client_max_body_size 1024M;
    keepalive_timeout 180;
    send_timeout 120;

    upstream rwserver {
        server {{ template "milvus.writable.fullname" . }}:{{ .Values.service.port }};
    }

    {{- if not (eq 0 (int .Values.readonly.replicas)) }}
    upstream roserver {
        server {{ template "milvus.readonly.fullname" . }}:{{ .Values.service.port }};
    }
    {{- end }}

    # access_log  /var/log/nginx/access.log;

    server {
        listen {{ .Values.service.port }} http2;

        location ~* ^/milvus.grpc.MilvusService/.+ {
            grpc_pass grpc://rwserver;
        }

        {{- if not (eq 0 (int .Values.readonly.replicas)) }}
        location = /milvus.grpc.MilvusService/Search {
            {{- if .Values.nginx.delay.enabled }}
            delay {{ .Values.nginx.delay.time }};
            {{- end }}
            grpc_pass grpc://roserver;
        }
        {{- end }}
    }
}
{{- end -}}
