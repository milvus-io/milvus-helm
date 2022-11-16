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

metastore:
{{- if or .Values.mysql.enabled .Values.externalMysql.enabled }}
  type: mysql
{{- else }}
  type: etcd
{{- end }}

{{- if .Values.externalMysql.enabled }}
mysql:
  username: {{ .Values.externalMysql.username }}
  password: {{ .Values.externalMysql.password }}
  address: {{ .Values.externalMysql.address }}
  port: {{ .Values.externalMysql.port }}
  dbName: {{ .Values.externalMysql.dbName }}
  driverName: mysql
  maxOpenConns: {{ .Values.externalMysql.maxOpenConns }}
  maxIdleConns: {{ .Values.externalMysql.maxIdleConns }}
{{- else if .Values.mysql.enabled }}
mysql:
  username: root
  password: {{ .Values.mysql.auth.rootPassword }}
  {{- if contains .Values.mysql.name .Release.Name }}
    {{- if eq .Values.mysql.architecture "replication" }}
  address: {{ .Release.Name }}-primary
    {{- else }}
  address: {{ .Release.Name }}
    {{- end }}
  {{- else }}
    {{- if eq .Values.mysql.architecture "replication" }}
  address: {{ .Release.Name }}-{{ .Values.mysql.name }}-primary
    {{- else }}
  address: {{ .Release.Name }}-{{ .Values.mysql.name }}
    {{- end }}
  {{- end }}
  port: 3306
  dbName: {{ .Values.mysql.auth.database }}
  driverName: mysql
  maxOpenConns: {{ .Values.mysql.maxOpenConns }}
  maxIdleConns: {{ .Values.mysql.maxIdleConns }}
{{- end }}

minio:
{{- if .Values.externalS3.enabled }}
  address: {{ .Values.externalS3.host }}
  port: {{ .Values.externalS3.port }}
  accessKeyID: {{ .Values.externalS3.accessKey }}
  secretAccessKey: {{ .Values.externalS3.secretKey }}
  useSSL: {{ .Values.externalS3.useSSL }}
  bucketName: {{ .Values.externalS3.bucketName }}
  rootPath: {{ .Values.externalS3.rootPath }}
  useIAM: {{ .Values.externalS3.useIAM }}
  iamEndpoint: {{ .Values.externalS3.iamEndpoint }}
{{- else }}
{{- if contains .Values.minio.name .Release.Name }}
  address: {{ .Release.Name }}
{{- else }}
  address: {{ .Release.Name }}-{{ .Values.minio.name }}
{{- end }}
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
  useIAM: {{ .Values.minio.useIAM }}
  iamEndpoint: {{ .Values.minio.iamEndpoint }}
{{- end }}

{{- if .Values.externalPulsar.enabled }}

messageQueue: pulsar

pulsar:
  address: {{ .Values.externalPulsar.host }}
  port: {{ .Values.externalPulsar.port }}
  maxMessageSize: {{ .Values.externalPulsar.maxMessageSize }}

{{- else if .Values.pulsar.enabled }}

messageQueue: pulsar

pulsar:
{{- if contains .Values.pulsar.name .Release.Name }}
  address: {{ .Release.Name }}-proxy
{{- else }}
  address: {{ .Release.Name }}-{{ .Values.pulsar.name }}-proxy
{{- end }}
  port: {{ .Values.pulsar.proxy.ports.pulsar }}
  maxMessageSize: {{ .Values.pulsar.maxMessageSize }}
{{- end }}

{{- if .Values.externalKafka.enabled }}

messageQueue: kafka

kafka:
  brokerList: {{ .Values.externalKafka.brokerList }}
  securityProtocol: {{ .Values.externalKafka.securityProtocol }}
  saslMechanisms: {{ .Values.externalKafka.sasl.mechanisms }}
{{- if .Values.externalKafka.sasl.username }}
  saslUsername: {{ .Values.externalKafka.sasl.username }}
{{- end }}
{{- if .Values.externalKafka.sasl.password }}
  saslPassword: {{ .Values.externalKafka.sasl.password }}
{{- end }}
{{- else if .Values.kafka.enabled }}

messageQueue: kafka

kafka:
{{- if contains .Values.kafka.name .Release.Name }}
  brokerList: {{ .Release.Name }}:{{ .Values.kafka.service.ports.client }}
{{- else }}
  brokerList: {{ .Release.Name }}-{{ .Values.kafka.name }}:{{ .Values.kafka.service.ports.client }}
{{- end }}
{{- end }}

{{- if and (not .Values.cluster.enabled) (eq .Values.standalone.messageQueue "rocksmq") }}

messageQueue: rocksmq

rocksmq:
  path: "{{ .Values.standalone.persistence.mountPath }}/rdb_data"
  rocksmqPageSize: "{{ .Values.standalone.rocksmq.rocksmqPageSize }}"  # 2 GB
  retentionTimeInMinutes: {{ .Values.standalone.rocksmq.retentionTimeInMinutes }}
  retentionSizeInMB: {{ .Values.standalone.rocksmq.retentionSizeInMB }}
  lrucacheratio: {{ .Values.standalone.rocksmq.lrucacheratio }}

{{- end }}

rootCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.rootcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.rootCoordinator.service.port }}

  dmlChannelNum: "{{ .Values.rootCoordinator.dmlChannelNum }}"  # The number of dml channels created at system startup
  maxPartitionNum: "{{ .Values.rootCoordinator.maxPartitionNum }}"  # Maximum number of partitions in a collection
  minSegmentSizeToEnableIndex: "{{ .Values.rootCoordinator.minSegmentSizeToEnableIndex }}"  # It's a threshold. When the segment size is less than this value, the segment will not be indexed

proxy:
  port: 19530
  internalPort: 19529
  http:
    enabled: {{ .Values.proxy.http.enabled }} # Whether to enable the http server
    debug_mode: {{ .Values.proxy.http.debugMode.enabled }} # Whether to enable http server debug mode

  timeTickInterval: "{{ .Values.proxy.timeTickInterval }}"  # ms, the interval that proxy synchronize the time tick
  msgStream:
    timeTick:
      bufSize: 512
  maxNameLength: 255  # Maximum length of name for a collection or alias
  maxFieldNum: "{{ .Values.proxy.maxFieldNum }}"     # max field number of a collection
  maxDimension: 32768  # Maximum dimension of a vector
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
  checkInterval: "{{ .Values.queryCoordinator.checkInterval }}"
  channelTaskTimeout: "{{ .Values.queryCoordinator.channelTaskTimeout }}"
  segmentTaskTimeout: "{{ .Values.queryCoordinator.segmentTaskTimeout }}"
  distPullInterval: "{{ .Values.queryCoordinator.distPullInterval }}"
  loadTimeoutSeconds: "{{ .Values.queryCoordinator.loadTimeoutSeconds }}"
  checkHandoffInterval: "{{ .Values.queryCoordinator.checkHandoffInterval }}"
  taskMergeCap: "{{ .Values.queryCoordinator.taskMergeCap }}"

queryNode:
  port: 21123
  loadMemoryUsageFactor: 3 # The multiply factor of calculating the memory usage while loading segments
{{- if .Values.cluster.enabled }}
  enableDisk: {{ .Values.queryNode.disk.enabled }} # Enable querynode load disk index, and search on disk index
{{- else }}
  enableDisk: {{ .Values.standalone.disk.enabled }} # Enable querynode load disk index, and search on disk index
{{- end }}

  stats:
    publishInterval: 1000 # Interval for querynode to report node information (milliseconds)
  dataSync:
    flowGraph:
      maxQueueLength: 1024 # Maximum length of task queue in flowgraph
      maxParallelism: 1024 # Maximum number of tasks executed in parallel in the flowgraph
  segcore:
    chunkRows: {{ .Values.queryNode.segcore.chunkRows }} # The number of vectors in a chunk.
    smallIndex:
      nlist: 128 # small index nlist, recommend to set sqrt(chunkRows), must smaller than chunkRows/8
      nprobe: 16 # nprobe to search small index, based on your accuracy requirement, must smaller than nlist
  cache:
    enabled: true
    memoryLimit: 2147483648 # 2 GB, 2 * 1024 *1024 *1024

  scheduler:
    receiveChanSize: 10240
    unsolvedQueueSize: 10240
    maxReadConcurrentRatio: "{{ .Values.queryNode.scheduler.maxReadConcurrentRatio }}"
    cpuRatio: 10.0 # ratio used to estimate read task cpu usage.

  grouping:
    enabled: {{ .Values.queryNode.grouping.enabled }}
    maxNQ: "{{ .Values.queryNode.grouping.maxNQ }}"
    topKMergeRatio: 10.0


indexCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.indexcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.indexCoordinator.service.port }}

  gc:
    interval: {{ .Values.indexCoordinator.gc.interval }}  # gc interval in seconds

indexNode:
  port: 21121

{{- if .Values.cluster.enabled }}
  enableDisk: {{ .Values.indexNode.disk.enabled }} # Enable index node build disk vector index
{{- else }}
  enableDisk: {{ .Values.standalone.disk.enabled }} # Enable index node build disk vector index
{{- end }}

  scheduler:
    buildParallel: {{ .Values.indexNode.scheduler.buildParallel }} # one index node can run how many index tasks in parallel


dataCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.datacoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.dataCoordinator.service.port }}

  enableCompaction: {{ .Values.dataCoordinator.enableCompaction }}
  enableGarbageCollection: {{ .Values.dataCoordinator.enableGarbageCollection }}

  segment:
    maxSize: "{{ .Values.dataCoordinator.segment.maxSize }}"  # Maximum size of a segment in MB
    diskSegmentMaxSize: "{{ .Values.dataCoordinator.segment.diskSegmentMaxSize }}" # Maximum size of segment in MB for disk index collection
    sealProportion: "{{ .Values.dataCoordinator.segment.sealProportion }}" # It's the minimum proportion for a segment which can be sealed
    assignmentExpiration: 2000 # The time of the assignment expiration in ms
    maxLife: "{{ .Values.dataCoordinator.segment.maxLife }}" # The max lifetime of segment in seconds, 60*60
    maxIdleTime: "{{ .Values.dataCoordinator.segment.maxIdleTime }}" # The maximum idle time of a growing segment in seconds, 5*60
    minSizeFromIdleToSealed: "{{ .Values.dataCoordinator.segment.minSizeFromIdleToSealed }}"  # The minimum size in MB of segment which can be idle from sealed
    smallProportion: "{{ .Values.dataCoordinator.segment.smallProportion }}" # The proportion for a sealed segment, which would not be compacted

  compaction:
    enableAutoCompaction: {{ .Values.dataCoordinator.compaction.enableAutoCompaction }}

  gc:
    interval: {{ .Values.dataCoordinator.gc.interval }} # gc interval in seconds
    missingTolerance: {{ .Values.dataCoordinator.gc.missingTolerance }} # file meta missing tolerance duration in seconds, 1 day
    dropTolerance: {{ .Values.dataCoordinator.gc.dropTolerance }} # file belongs to dropped entity tolerance duration in seconds, 1 day

dataNode:
  port: 21124

  dataSync:
    flowGraph:
      maxQueueLength: 1024  # Maximum length of task queue in flowgraph
      maxParallelism: 1024  # Maximum number of tasks executed in parallel in the flowgraph
  segment:
    insertBufSize: "{{ .Values.dataNode.segment.insertBufSize }}"  # Bytes, 16 MB
    deleteBufBytes: "{{ .Values.dataNode.segment.deleteBufBytes }}"  # Bytes, 64 MB
    syncPeriod: "{{ .Values.dataNode.segment.syncPeriod }}"  # Seconds, 10min

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

grpc:
  log:
    level: WARNING

  serverMaxRecvSize: 2147483647 # math.MaxInt32
  serverMaxSendSize: 2147483647 # math.MaxInt32
  clientMaxRecvSize: 104857600 # 100 MB, 100 * 1024 * 1024
  clientMaxSendSize: 104857600 # 100 MB, 100 * 1024 * 1024

  client:
    dialTimeout: 5000
    keepAliveTime: 10000
    keepAliveTimeout: 20000
    maxMaxAttempts: 5
    initialBackOff: 1.0
    maxBackoff: 60.0
    backoffMultiplier: 2.0

common:
  # Channel name generation rule: ${namePrefix}-${ChannelIdx}
  chanNamePrefix:
    cluster: {{ .Values.msgChannel.chanNamePrefix.cluster }}
    rootCoordTimeTick: "rootcoord-timetick"
    rootCoordStatistics: "rootcoord-statistics"
    rootCoordDml: "rootcoord-dml"
    rootCoordDelta: "rootcoord-delta"
    search: "search"
    searchResult: "searchResult"
    queryTimeTick: "queryTimeTick"
    queryNodeStats: "query-node-stats"
    # Cmd for loadIndex, flush, etc...
    cmd: "cmd"
    dataCoordStatistic: "datacoord-statistics-channel"
    dataCoordTimeTick: "datacoord-timetick-channel"
    dataCoordSegmentInfo: "segment-info-channel"

  # Sub name generation rule: ${subNamePrefix}-${NodeID}
  subNamePrefix:
    rootCoordSubNamePrefix: "rootCoord"
    proxySubNamePrefix: "proxy"
    queryNodeSubNamePrefix: "queryNode"
    dataNodeSubNamePrefix: "dataNode"
    dataCoordSubNamePrefix: "dataCoord"

  defaultPartitionName: "_default"  # default partition name for a collection
  defaultIndexName: "_default_idx"  # default index name
  retentionDuration: {{ .Values.common.compaction.retentionDuration }}
  entityExpiration:  -1     # Entity expiration in seconds, CAUTION make sure entityExpiration >= retentionDuration and -1 means never expire

  gracefulTime: 5000 # milliseconds. it represents the interval (in ms) by which the request arrival time needs to be subtracted in the case of Bounded Consistency.
  security:
    authorizationEnabled: {{ .Values.authorization.enabled }}
  simdType: {{ .Values.common.simdType }}  # default to auto
  indexSliceSize: 16 # MB
  threadCoreCoefficient: {{ .Values.common.threadCoreCoefficient }}

  storageType: minio
  mem_purge_ratio: 0.2 # in Linux os, if memory-fragmentation-size >= used-memory * ${mem_purge_ratio}, then do `malloc_trim`

quotaAndLimits:
  enabled: {{ .Values.quotaAndLimits.enabled }}
  quotaCenterCollectInterval: {{ .Values.quotaAndLimits.quotaCenterCollectInterval }}  # seconds

  ddl:
    enabled: {{ .Values.quotaAndLimits.ddl.enabled }}
    collectionRate: {{ .Values.quotaAndLimits.ddl.collectionRate }}
    partitionRate: {{ .Values.quotaAndLimits.ddl.partitionRate }}

  indexRate:
    enabled: {{ .Values.quotaAndLimits.indexRate.enabled }}
    max: {{ .Values.quotaAndLimits.indexRate.max }}
  flushRate:
    enabled: {{ .Values.quotaAndLimits.flushRate.enabled }}
    max: {{ .Values.quotaAndLimits.flushRate.max }}
  compactionRate:
    enabled: {{ .Values.quotaAndLimits.compactionRate.enabled }}
    max: {{ .Values.quotaAndLimits.compactionRate.max }}

  dml:
    enabled: {{ .Values.quotaAndLimits.dml.enabled }}
    insertRate:
      max: {{ .Values.quotaAndLimits.dml.insertRate.max }}
    deleteRate:
      max: {{ .Values.quotaAndLimits.dml.deleteRate.max }}
    bulkLoadRate:
      max: {{ .Values.quotaAndLimits.dml.bulkLoadRate.max }}

  dql:
    enabled: {{ .Values.quotaAndLimits.dql.enabled }}
    searchRate:
      max: {{ .Values.quotaAndLimits.dql.searchRate.max }}
    queryRate:
      max: {{ .Values.quotaAndLimits.dql.queryRate.max }}

  limitWriting:
    forceDeny: {{ .Values.quotaAndLimits.limitWriting.forceDeny }}

    ttProtection:
      enabled: {{ .Values.quotaAndLimits.limitWriting.ttProtection.enabled }}
      maxTimeTickDelay: {{ .Values.quotaAndLimits.limitWriting.ttProtection.maxTimeTickDelay }}  # seconds

    memProtection:
      enabled: {{ .Values.quotaAndLimits.limitWriting.memProtection.enabled }}
      dataNodeMemoryLowWaterLevel: {{ .Values.quotaAndLimits.limitWriting.memProtection.dataNodeMemoryLowWaterLevel }}
      dataNodeMemoryHighWaterLevel: {{ .Values.quotaAndLimits.limitWriting.memProtection.dataNodeMemoryHighWaterLevel }}
      queryNodeMemoryLowWaterLevel: {{ .Values.quotaAndLimits.limitWriting.memProtection.queryNodeMemoryLowWaterLevel }}
      queryNodeMemoryHighWaterLevel: {{ .Values.quotaAndLimits.limitWriting.memProtection.queryNodeMemoryHighWaterLevel }}
    diskProtection:
      enabled: {{ .Values.quotaAndLimits.limitWriting.diskProtection.enabled }}
      diskQuota: {{ .Values.quotaAndLimits.limitWriting.diskProtection.diskQuota }}

  limitReading:
    forceDeny: {{ .Values.quotaAndLimits.limitReading.forceDeny }}

    queueProtection:
      enabled: {{ .Values.quotaAndLimits.limitReading.queueProtection.enabled }}
      nqInQueueThreshold: {{ .Values.quotaAndLimits.limitReading.queueProtection.nqInQueueThreshold }}
      queueLatencyThreshold: {{ .Values.quotaAndLimits.limitReading.queueProtection.queueLatencyThreshold }}

    resultProtection:
      enabled: {{ .Values.quotaAndLimits.limitReading.resultProtection.enabled }}
      maxReadResultRate: {{ .Values.quotaAndLimits.limitReading.resultProtection.maxReadResultRate }}

    coolOffSpeed: {{ .Values.quotaAndLimits.limitReading.coolOffSpeed }}

{{- end }}
