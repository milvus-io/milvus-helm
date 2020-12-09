{{- define "milvus.nginx.config" -}}
events {}
http {
    client_max_body_size 1024M;
    upstream rwserver {
        server {{ template "milvus.writable.fullname" . }}:{{ .Values.service.port }};
    }

    upstream roserver {
        server {{ template "milvus.readonly.fullname" . }}:{{ .Values.service.port }};
    }

    access_log  /var/log/nginx/access.log;

    server {
        listen {{ .Values.service.port }} http2;

        location ~* ^/milvus.grpc.MilvusService/.+ {
            grpc_pass grpc://rwserver;
        }
        location = /milvus.grpc.MilvusService/Search {
            grpc_pass grpc://roserver;
        }

    }
}
{{- end -}}