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
  cloudProvider: {{ .Values.externalS3.cloudProvider }}
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
  tenant: "{{ .Values.externalPulsar.tenant }}"
  namespace: {{ .Values.externalPulsar.namespace }}
  authPlugin: {{ .Values.externalPulsar.authPlugin }}
  authParams: {{ .Values.externalPulsar.authParams }}

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

{{- end }}

rootCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.rootcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.rootCoordinator.service.port }}
  enableActiveStandby: {{ .Values.rootCoordinator.activeStandby.enabled }}  # Enable active-standby

proxy:
  port: 19530
  internalPort: 19529

queryCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.querycoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.queryCoordinator.service.port }}

  enableActiveStandby: {{ .Values.queryCoordinator.activeStandby.enabled }}  # Enable active-standby

queryNode:
  port: 21123
{{- if .Values.cluster.enabled }}
  enableDisk: {{ .Values.queryNode.disk.enabled }} # Enable querynode load disk index, and search on disk index
{{- else }}
  enableDisk: {{ .Values.standalone.disk.enabled }} # Enable querynode load disk index, and search on disk index
{{- end }}

indexCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.indexcoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.indexCoordinator.service.port }}
  enableActiveStandby: {{ .Values.indexCoordinator.activeStandby.enabled }}  # Enable active-standby

indexNode:
  port: 21121

{{- if .Values.cluster.enabled }}
  enableDisk: {{ .Values.indexNode.disk.enabled }} # Enable index node build disk vector index
{{- else }}
  enableDisk: {{ .Values.standalone.disk.enabled }} # Enable index node build disk vector index
{{- end }}

dataCoord:
{{- if .Values.cluster.enabled }}
  address: {{ template "milvus.datacoord.fullname" . }}
{{- else }}
  address: localhost
{{- end }}
  port: {{ .Values.dataCoordinator.service.port }}
  enableActiveStandby: {{ .Values.dataCoordinator.activeStandby.enabled }}  # Enable active-standby

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

{{- end }}
