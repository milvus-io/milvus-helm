{{- define "milvus.config" -}}
# Copyright (C) 2019-2021 Zilliz. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under the License.

etcd:
{{- if .Values.externalEtcd.enabled }}
  endpoints:
  {{- range .Values.externalEtcd.endpoints }}
    - {{ . }}
  {{- end }}
{{- else }}
  endpoints:
{{- if contains .Values.etcd.name .Release.Name }}
    - {{ .Release.Name }}:{{ .Values.etcd.service.port }}
{{- else }}
    - {{ .Release.Name }}-{{ .Values.etcd.name }}:{{ .Values.etcd.service.port }}
{{- end }}
{{- end }}
  rootPath: {{ .Values.metadata.rootPath }}
  metaSubPath: meta # metaRootPath = rootPath + '/' + metaSubPath
  kvSubPath: kv # kvRootPath = rootPath + '/' + kvSubPath

minio:
{{- if .Values.externalS3.enabled }}
  address: {{ .Values.externalS3.host }}
  port: {{ .Values.externalS3.port }}
  accessKeyID: {{ .Values.externalS3.accessKey }}
  secretAccessKey: {{ .Values.externalS3.secretKey }}
  useSSL: {{ .Values.externalS3.useSSL }}
  bucketName: {{ .Values.externalS3.bucketName }}
  rootPath: {{ .Values.externalS3.rootPath }}
{{- else }}
  address: {{ .Release.Name }}-{{ .Values.minio.name }}
  port: {{ .Values.minio.service.port }}
  accessKeyID: {{ .Values.minio.accessKey }}
  secretAccessKey: {{ .Values.minio.secretKey }}
  useSSL: {{ .Values.minio.tls.enabled }}
{{- if .Values.minio.gcsgateway.enabled }}
  bucketName: {{ .Values.externalGcs.bucketName }}
{{- else }}
  bucketName: {{ .Values.minio.bucketName }}
{{- end }}
  rootPath: {{ .Values.minio.rootPath }}
{{- end }}

pulsar:
{{- if .Values.externalPulsar.enabled }}
  address: {{ .Values.externalPulsar.host }}
  port: {{ .Values.externalPulsar.port }}
{{- else if .Values.pulsar.enabled }}
  address: {{ .Release.Name }}-{{ .Values.pulsar.name }}-proxy
  {{- $httpPort := "" -}}
  {{- $httpsPort := "" -}}
  {{- range .Values.pulsar.proxy.service.ports }}
  {{- if eq .name "pulsar" }}
  {{- $httpPort = .port -}}
  {{- else if eq .name "pulsarssl" }}
  {{- $httpsPort = .port -}}
  {{- end }}
  {{- end }}
  port: {{ $httpsPort | default $httpPort }}
{{- end }}

rocksmq:
  path: "{{ .Values.standalone.persistence.mountPath }}/rdb_data"
  rocksmqPageSize: "{{ .Values.standalone.rocksmq.rocksmqPageSize }}"  # 2 GB
  retentionTimeInMinutes: {{ .Values.standalone.rocksmq.retentionTimeInMinutes }}
  retentionSizeInMB: {{ .Values.standalone.rocksmq.retentionSizeInMB }}

rootCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.rootcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.rootCoordinator.service.port }}

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

  dmlChannelNum: "{{ .Values.rootCoordinator.dmlChannelNum }}"  # The number of dml channels created at system startup
  maxPartitionNum: "{{ .Values.rootCoordinator.maxPartitionNum }}"  # Maximum number of partitions in a collection
  minSegmentSizeToEnableIndex: "{{ .Values.rootCoordinator.minSegmentSizeToEnableIndex }}"  # It's a threshold. When the segment size is less than this value, the segment will not be indexed
  timeout: 3600  # time out, 5 seconds
  timeTickInterval: 200  # ms, the interval that proxy synchronize the time tick

proxy:
  port: 19530

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

  timeTickInterval: "{{ .Values.proxy.timeTickInterval }}"  # ms, the interval that proxy synchronize the time tick
  msgStream:
    insert:
      bufSize: 1024  # msgPack chan buffer size
    search:
      bufSize: 512
    searchResult:
      recvBufSize: 1024  # msgPack chan buffer size
      pulsarBufSize: 1024  # pulsar chan buffer size
    timeTick:
      bufSize: 512
  maxNameLength: 255   # max name length of collection or alias
  maxFieldNum: "{{ .Values.proxy.maxFieldNum }}"     # max field number of a collection
  maxDimension: 32768  # Maximum dimension of vector
  maxShardNum: "{{ .Values.proxy.maxShardNum }}"  # Maximum number of shards in a collection
  maxTaskNum: "{{ .Values.proxy.maxTaskNum }}"  # max task number of proxy task queue

queryCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.querycoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.queryCoordinator.service.port }}
  autoHandoff: {{ .Values.queryCoordinator.autoHandoff }}
  autoBalance: {{ .Values.queryCoordinator.autoBalance }}
  overloadedMemoryThresholdPercentage: 90
  balanceIntervalSeconds: 60
  memoryUsageMaxDifferencePercentage: 30

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

queryNode:
  gracefulTime: {{ .Values.queryNode.gracefulTime }}  # ms
  port: 21123

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

  stats:
    publishInterval: 1000  # Interval for querynode to report node information (milliseconds)
  dataSync:
    flowGraph:
      maxQueueLength: 1024  # Maximum length of task queue in flowgraph
      maxParallelism: 1024  # Maximum number of tasks executed in parallel in the flowgraph
  msgStream:
    search:
      recvBufSize: 512    # msgPack channel buffer size
      pulsarBufSize: 512  # pulsar channel buffer size
    searchResult:
      recvBufSize: 64  # msgPack channel buffer size
  segcore:
    chunkRows: {{ .Values.queryNode.segcore.chunkRows }}  # The number of vectors in a chunk.

indexCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.indexcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.indexCoordinator.service.port }}

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

indexNode:
  port: 21121

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

dataCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.datacoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.dataCoordinator.service.port }}

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024
  enableCompaction: {{ .Values.dataCoordinator.enableCompaction }}
  enableGarbageCollection: {{ .Values.dataCoordinator.enableGarbageCollection }}

  segment:
    maxSize: "{{ .Values.dataCoordinator.segment.maxSize }}"  # Maximum size of a segment in MB
    sealProportion: 0.75  # It's the minimum proportion for a segment which can be sealed
    assignmentExpiration: 2000  # ms

  gc:
    interval: {{ .Values.dataCoordinator.gc.interval }} # gc interval in seconds
    missingTolerance: {{ .Values.dataCoordinator.gc.missingTolerance }} # file meta missing tolerance duration in seconds, 1 day
    dropTolerance: {{ .Values.dataCoordinator.gc.dropTolerance }} # file belongs to dropped entity tolerance duration in seconds, 1 day

dataNode:
  port: 21124

  grpc:
    serverMaxRecvSize: 2147483647  # math.MaxInt32
    serverMaxSendSize: 2147483647  # math.MaxInt32
    clientMaxRecvSize: 104857600   # 100 MB, 100 * 1024 * 1024
    clientMaxSendSize: 104857600   # 100 MB, 100 * 1024 * 1024

  dataSync:
    flowGraph:
      maxQueueLength: 1024  # Maximum length of task queue in flowgraph
      maxParallelism: 1024  # Maximum number of tasks executed in parallel in the flowgraph
  flush:
    insertBufSize: "{{ .Values.dataNode.flush.insertBufSize }}"  # Bytes, 16 MB

log:
  level: {{ .Values.log.level }}
  file:
{{- if .Values.log.persistence.enabled }}
    rootPath: "{{ .Values.log.persistence.mountPath }}"
{{- else }}
    rootPath: ""
{{- end }}
    maxSize: {{ .Values.log.file.maxSize }}
    maxAge: {{ .Values.log.file.maxAge }}
    maxBackups: {{ .Values.log.file.maxBackups }}
  format: {{ .Values.log.format }}

msgChannel:
  # channel name generation rule: ${namePrefix}-${ChannelIdx}
  chanNamePrefix:
    cluster: {{ .Values.msgChannel.chanNamePrefix.cluster }}
    rootCoordTimeTick: "rootcoord-timetick"
    rootCoordStatistics: "rootcoord-statistics"
    rootCoordDml: "rootcoord-dml"
    rootCoordDelta: "rootcoord-delta"
    search: "search"
    searchResult: "searchResult"
    proxyTimeTick: "proxyTimeTick"
    queryTimeTick: "queryTimeTick"
    queryNodeStats: "query-node-stats"
    cmd: "cmd"
    dataCoordInsertChannel: "insert-channel-"
    dataCoordStatistic: "datacoord-statistics-channel"
    dataCoordTimeTick: "datacoord-timetick-channel"
    dataCoordSegmentInfo: "segment-info-channel"

  # sub name generation rule: ${subNamePrefix}-${NodeID}
  subNamePrefix:
    rootCoordSubNamePrefix: "rootCoord"
    proxySubNamePrefix: "proxy"
    queryNodeSubNamePrefix: "queryNode"
    dataNodeSubNamePrefix: "dataNode"
    dataCoordSubNamePrefix: "dataCoord"

common:
  defaultPartitionName: "_default"  # default partition name for a collection
  defaultIndexName: "_default_idx"  # default index name

knowhere:
  simdType: {{ .Values.knowhere.simdType }}  # default to auto
{{- end }}
