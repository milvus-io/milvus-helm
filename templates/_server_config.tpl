{{- define "milvus.serverConfig" -}}
# Default values are used when you make no changes to the following parameters.
version: 0.1

server_config:
  address: 0.0.0.0                  # milvus server ip address (IPv4)
  port: 19530                       # milvus server port, must in range [1025, 65534]
  deploy_mode: {{ .Values.deployMode }}               # deployment type: single, cluster_readonly, cluster_writable
  time_zone: {{ .Values.timeZone }}                  # time zone, must be in format: UTC+X

db_config:
{{- if not .Values.backendURL }}
  {{- if .Values.mysql.enabled }}
  backend_url: {{ template "milvus.mysqlURL" . }}       # URI format: dialect://username:password@host:port/database
  {{- else }}
  backend_url: {{ template "milvus.sqliteURL" . }}       # URI format: dialect://username:password@host:port/database
  {{- end }}
{{- else }}
  backend_url: {{ .Values.backendURL }}       # URI format: dialect://username:password@host:port/database
{{- end }}
                                    # Keep 'dialect://:@:/', and replace other texts with real values
                                    # Replace 'dialect' with 'mysql' or 'sqlite'
  preload_table:                    # preload data at startup, '*' means load all tables, empty value means no preload
                                    # you can specify preload tables like this: table1,table2,table3
storage_config:
  primary_path: {{ .Values.primaryPath }}         # path used to store data and meta
  secondary_path:                   # path used to store data only, split by semicolon

metric_config:
  enable_monitor: {{ .Values.metrics.enabled }}             # enable monitoring or not, must be a boolean
  address: {{ .Values.metrics.address }}
  port: {{ .Values.metrics.port }}                      # port prometheus uses to fetch metrics, must in range [1025, 65534]

cache_config:
  cpu_cache_capacity: {{ .Values.cpuCacheCapacity }}            # GB, size of CPU memory used for cache, must be a positive integer
  cache_insert_data: {{ .Values.cacheInsertData }}          # whether to load inserted data into cache, must be a boolean
  insert_buffer_size: {{ .Values.insertBufferSize }}             # GB, maximum insert buffer size allowed, must be a positive integer
                                    # sum of insert_buffer_size and cpu_cache_capacity cannot exceed total memory

engine_config:
  use_blas_threshold: {{ .Values.useBLASThreshold }}          # if nq <  use_blas_threshold, use SSE, faster with fluctuated response times
                                    # if nq >= use_blas_threshold, use OpenBlas, slower with stable response times
  gpu_search_threshold: {{ .Values.gpuSearchThreshold }}        # threshold beyond which the search computation is executed on GPUs only

gpu_resource_config:
  enable: {{ .Values.gpu.enabled }}  # whether to enable GPU resources
  cache_capacity: {{ .Values.gpu.cacheCapacity }}                 # GB, size of GPU memory per card used for cache, must be a positive integer
  {{- with .Values.gpu.searchResources }}
  search_resources:                 # define the GPU devices used for search computation, must be in format gpux
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.gpu.buildIndexResources }}
  build_index_resources:            # define the GPU devices used for index building, must be in format gpux
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}

wal_config:
  enable:  {{ .Values.wal.enabled }}
  recovery_error_ignore: {{ .Values.wal.ignoreErrorLog }}
  buffer_size: {{ .Values.wal.bufferSize }}
  record_size: {{ .Values.wal.recordSize }}
  wal_path: {{ .Values.wal.path }}
