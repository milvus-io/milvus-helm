{{- define "milvus.readonly.serverConfig" -}}
# Copyright (C) 2019-2020 Zilliz. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under the License.

version: {{ .Values.version }} 

#----------------------+------------------------------------------------------------+------------+-----------------+
# Cluster Config       | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# enable               | If runinng with Mishards, set true, otherwise false.       | Boolean    | false           |
#----------------------+------------------------------------------------------------+------------+-----------------+
# role                 | Milvus deployment role: rw / ro                            | role       | rw              |
#----------------------+------------------------------------------------------------+------------+-----------------+
cluster:
  enable: {{ .Values.cluster.enabled }}
  role: ro

#----------------------+------------------------------------------------------------+------------+-----------------+
# General Config       | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# timezone             | Use UTC-x or UTC+x to specify a time zone.                 | Timezone   | UTC+8           |
#----------------------+------------------------------------------------------------+------------+-----------------+
# meta_uri             | URI for metadata storage, using SQLite (for single server  | URL        | sqlite://:@:/   |
#                      | Milvus) or MySQL (for distributed cluster Milvus).         |            |                 |
#                      | Format: dialect://username:password@host:port/database     |            |                 |
#                      | Keep 'dialect://:@:/', 'dialect' can be either 'sqlite' or |            |                 |
#                      | 'mysql', replace other texts with real values.             |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
general:
  timezone: {{ .Values.timeZone }}
{{- if or .Values.mysql.enabled .Values.externalMysql.enabled }}
  meta_uri: {{ template "milvus.mysqlURI" . }}
{{- else }}
  meta_uri: {{ template "milvus.sqliteURI" . }}
{{- end }}

#----------------------+------------------------------------------------------------+------------+-----------------+
# Network Config       | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# bind.address         | IP address that Milvus server monitors.                    | IP         | 0.0.0.0         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# bind.port            | Port that Milvus server monitors. Port range (1024, 65535) | Integer    | 19530           |
#----------------------+------------------------------------------------------------+------------+-----------------+
# http.enable          | Enable web server or not.                                  | Boolean    | true            |
#----------------------+------------------------------------------------------------+------------+-----------------+
# http.port            | Port that Milvus web server monitors.                      | Integer    | 19121           |
#                      | Port range (1024, 65535)                                   |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
network: 
  bind.address: 0.0.0.0
  bind.port: 19530
  http.enable: false
  http.port: 19121

#----------------------+------------------------------------------------------------+------------+-----------------+
# Storage Config       | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# path                 | Path used to save meta data, vector data and index data.   | Path       | /var/lib/milvus |
#----------------------+------------------------------------------------------------+------------+-----------------+
# auto_flush_interval  | The interval, in seconds, at which Milvus automatically    | Integer    | 1 (s)           |
#                      | flushes data to disk.                                      |            |                 |
#                      | 0 means disable the regular flush.                         |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
storage:
  path: {{ .Values.primaryPath }}
  auto_flush_interval: {{ .Values.storage.autoFlushInterval }}

#----------------------+------------------------------------------------------------+------------+-----------------+
# WAL Config           | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# enable               | Whether to enable write-ahead logging (WAL) in Milvus.     | Boolean    | true            |
#                      | If WAL is enabled, Milvus writes all data changes to log   |            |                 |
#                      | files in advance before implementing data changes. WAL     |            |                 |
#                      | ensures the atomicity and durability for Milvus operations.|            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# recovery_error_ignore| Whether to ignore logs with errors that happens during WAL | Boolean    | false           |
#                      | recovery. If true, when Milvus restarts for recovery and   |            |                 |
#                      | there are errors in WAL log files, log files with errors   |            |                 |
#                      | are ignored. If false, Milvus does not restart when there  |            |                 |
#                      | are errors in WAL log files.                               |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# buffer_size          | Sum total of the read buffer and the write buffer in Bytes.| String     | 256MB           |
#                      | buffer_size must be in range [64MB, 4096MB].               |            |                 |
#                      | If the value you specified is out of range, Milvus         |            |                 |
#                      | automatically uses the boundary value closest to the       |            |                 |
#                      | specified value. It is recommended you set buffer_size to  |            |                 |
#                      | a value greater than the inserted data size of a single    |            |                 |
#                      | insert operation for better performance.                   |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# path                 | Location of WAL log files.                                 | String     |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
wal:
  enable: false
  recovery_error_ignore: true
  buffer_size: {{ .Values.wal.bufferSize }}
  path: {{ .Values.wal.path }}

#----------------------+------------------------------------------------------------+------------+-----------------+
# Cache Config         | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# cache_size           | The size of CPU memory used for caching data for faster    | String     | 4GB             |
#                      | query. The sum of 'cpu_cache_capacity' and                 |            |                 |
#                      | 'insert_buffer_size' must be less than system memory size. |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# insert_buffer_size   | Buffer size used for data insertion.                       | String     | 1GB             |
#                      | The sum of 'insert_buffer_size' and 'cpu_cache_capacity'   |            |                 |
#                      | must be less than system memory size.                      |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# preload_collection   | A comma-separated list of collection names that need to    | StringList |                 |
#                      | be pre-loaded when Milvus server starts up.                |            |                 |
#                      | '*' means preload all existing tables (single-quote or     |            |                 |
#                      | double-quote required).                                    |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
cache:
  cache_size: {{ .Values.readonly.cache.cacheSize }}
  insert_buffer_size: {{ .Values.readonly.cache.insertBufferSize }}
  preload_collection:

#----------------------+------------------------------------------------------------+------------+-----------------+
# GPU Config           | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# enable               | Enable GPU resources or not.                               | Boolean    | false           |
#----------------------+------------------------------------------------------------+------------+-----------------+
# cache_size           | The size of GPU memory per card used for cache.            | String     | 1GB             |
#----------------------+------------------------------------------------------------+------------+-----------------+
# gpu_search_threshold | A Milvus performance tuning parameter. This value will be  | Integer    | 1000            |
#                      | compared with 'nq' to decide if the search computation will|            |                 |
#                      | be executed on GPUs only.                                  |            |                 |
#                      | If nq >= gpu_search_threshold, the search computation will |            |                 |
#                      | be executed on GPUs only;                                  |            |                 |
#                      | if nq < gpu_search_threshold, the search computation will  |            |                 |
#                      | be executed on both CPUs and GPUs.                         |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# search_resources     | The list of GPU devices used for search computation.       | DeviceList | gpu0            |
#                      | Must be in format gpux.                                    |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# build_index_resources| The list of GPU devices used for index building.           | DeviceList | gpu0            |
#                      | Must be in format gpux.                                    |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
gpu:
  enable: {{ .Values.readonly.gpu.enabled }}
  cache_size: {{ .Values.readonly.gpu.cacheSize }}
  gpu_search_threshold: {{ .Values.readonly.gpu.gpuSearchThreshold }}
  {{- with .Values.readonly.gpu.searchDevices }}
  search_devices:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.readonly.gpu.buildIndexDevices }}
  build_index_devices:
    {{- toYaml . | nindent 4 }}
  {{- end }}

#----------------------+------------------------------------------------------------+------------+-----------------+
# Logs Config          | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# trace.enable         | Whether to enable trace level logging in Milvus.           | Boolean    | true            |
#----------------------+------------------------------------------------------------+------------+-----------------+
# path                 | Absolute path to the folder holding the log files.         | String     |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# max_log_file_size    | The maximum size of each log file, size range              | String     | 1024MB          |
#                      | [512MB, 4096MB].                                           |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
# log_rotate_num       | The maximum number of log files that Milvus keeps for each | Integer    | 0               |
#                      | logging level, num range [0, 1024], 0 means unlimited.     |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
logs:
  trace.enable: true
  path: {{ .Values.logs.path }}
  max_log_file_size: {{ .Values.logs.maxLogFileSize }}
  log_rotate_num: {{ .Values.logs.logRotateNum }}

#----------------------+------------------------------------------------------------+------------+-----------------+
# Log Config           | Description                                                | Type       | Default         |
#----------------------+------------------------------------------------------------+------------+-----------------+
# min_messages         | Log level in Milvus. Must be one of debug, info, warning,  | String     | warning         |
#                      | error, fatal                                               |            |                 |
#----------------------+------------------------------------------------------------+------------+-----------------+
log:
  min_messages: {{ .Values.log.minMessages }}

{{- if .Values.readonly.extraConfiguration }}
{{ toYaml .Values.readonly.extraConfiguration }}
{{- end }}

{{- end }}
