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
    - {{ .Release.Name }}-{{ .Values.etcd.name }}:{{ .Values.etcd.service.port }}
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
{{- else }}
  address: {{ .Release.Name }}-{{ .Values.minio.name }}
  port: {{ .Values.minio.service.port }}
  accessKeyID: {{ .Values.minio.accessKey }}
  secretAccessKey: {{ .Values.minio.secretKey }}
  useSSL: {{ .Values.minio.tls.enabled }}
{{- if .Values.minio.gcsgateway.enabled }}
  bucketName: {{ .Values.externalGcs.bucketName }}
{{- else }}
  bucketName: "milvus-bucket"
{{- end }}
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
  retentionTimeInMinutes: {{ .Values.standalone.rocksmq.retentionTimeInMinutes }}
  retentionSizeInMB: {{ .Values.standalone.rocksmq.retentionSizeInMB }}

rootCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.rootcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.rootCoordinator.service.port }}

proxy:
  port: 19530

queryCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.querycoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.queryCoordinator.service.port }}
  autoHandoff: {{ .Values.queryCoordinator.autoHandoff }}

queryNode:
  gracefulTime: 5000 #ms
  port: 21123

indexCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.indexcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.indexCoordinator.service.port }}

indexNode:
  port: 21121

dataCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.datacoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.dataCoordinator.service.port }}

dataNode:
  port: 21124

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

{{- end }}
