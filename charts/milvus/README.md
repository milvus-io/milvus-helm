# Milvus Helm Chart

For more information about installing and using Helm, see the [Helm Docs](https://helm.sh/docs/). For a quick introduction to Charts, see the [Chart Guide](https://helm.sh/docs/topics/charts/).

To install Milvus, refer to [Milvus installation](https://milvus.io/docs/v2.0.x/install_cluster-helm.md).

## Introduction
This chart bootstraps Milvus deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.14+ (Attu requires 1.18+)
- Helm >= 3.2.0

> **IMPORTANT** The master branch is for the development of Milvus v2.x. On March 9th, 2021, we released Milvus v1.0, the first stable version of Milvus with long-term support. To use Milvus v1.x, switch to [branch 1.1](https://github.com/milvus-io/milvus-helm/tree/1.1).

## Install the Chart

1. Add the stable repository
```bash
$ helm repo add milvus https://milvus-io.github.io/milvus-helm/
```

2. Update charts repositories
```
$ helm repo update
```

### Deploy Milvus with standalone mode

Assume the release name is `my-release`:

```bash
# Helm v3.x
$ helm upgrade --install my-release --set cluster.enabled=false --set etcd.replicaCount=1 --set pulsar.enabled=false --set minio.mode=standalone milvus/milvus
```
By default, milvus standalone uses `rocksmq` as message queue. You can also use `pulsar` or `kafka` as message queue:
```bash
# Helm v3.x
# Milvus Standalone with pulsar as message queue
$ helm upgrade --install my-release --set cluster.enabled=false --set standalone.messageQueue=pulsar --set etcd.replicaCount=1 --set pulsar.enabled=true --set minio.mode=standalone milvus/milvus
```

```bash
# Helm v3.x
# Milvus Standalone with kafka as message queue
$ helm upgrade --install my-release --set cluster.enabled=false --set standalone.messageQueue=kafka --set etcd.replicaCount=1 --set pulsar.enabled=false --set kafka.enabled=true --set minio.mode=standalone milvus/milvus
```
> **Tip**: To list all releases, using `helm list`.

### Deploy Milvus with cluster mode

Assume the release name is `my-release`:

```bash
# Helm v3.x
$ helm upgrade --install my-release milvus/milvus
```
By default, milvus cluster uses `pulsar` as message queue. You can also use `kafka` instead of `pulsar` for milvus cluster:

```bash
# Helm v3.x
$ helm upgrade --install my-release milvus/milvus --set pulsar.enabled=false --set kafka.enabled=true
```

### Upgrade an existing Milvus cluster
E.g. to scale out query node from 1(default) to 2:
```bash
# Helm v3.x
$ helm upgrade --install --set queryNode.replicas=2 my-release milvus/milvus
```

## Uninstall the Chart

```bash
# Helm v3.x
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

- Completely uninstall Milvus

> **IMPORTANT** Please run this command with care. Maybe you want to keep ETCD data
```bash
MILVUS_LABELS="app.kubernetes.io/instance=my-release"
kubectl delete pvc $(kubectl get pvc -l "${MILVUS_LABELS}" -o jsonpath='{range.items[*]}{.metadata.name} ')
```


## Configuration

### Milvus Service Configuration

The following table lists the configurable parameters of the Milvus Service and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `cluster.enabled`                         | Enable or disable Milvus Cluster mode         | `true`                                                 |
| `image.all.repository`                    | Image repository                              | `milvusdb/milvus`                                       |
| `image.all.tag`                           | Image tag                                     | `v2.1.3`                           |
| `image.all.pullPolicy`                    | Image pull policy                             | `IfNotPresent`                                          |
| `image.all.pullSecrets`                   | Image pull secrets                            | `{}`                                                    |
| `service.type`                            | Service type                                  | `ClusterIP`                                             |
| `service.port`                            | Port where service is exposed                 | `19530`                                                 |
| `service.nodePort`                        | Service nodePort                              | `unset`                                                 |
| `service.annotations`                     | Service annotations                           | `{}`                                                    |
| `service.labels`                          | Service custom labels                         | `{}`                                                    |
| `service.clusterIP`                       | Internal cluster service IP                   | `unset`                                                 |
| `service.loadBalancerIP`                  | IP address to assign to load balancer (if supported) | `unset`                                          |
| `service.loadBalancerSourceRanges`        | List of IP CIDRs allowed access to lb (if supported) | `[]`                                             |
| `service.externalIPs`                     | Service external IP addresses                 | `[]`                                                    |
| `ingress.enabled`                         | If true, Ingress will be created              | `false`                                                 |
| `ingress.annotations`                     | Ingress annotations                           | `{}`                                                    |
| `ingress.labels`                          | Ingress labels                                | `{}`                                                    |
| `ingress.hosts`                           | Ingress hostnames                             | `[]`                                                    |
| `ingress.tls`                             | Ingress TLS configuration                     | `[]`                                                    |
| `metrics.enabled`                         | Export Prometheus monitoring metrics          | `true`                                                  |
| `metrics.serviceMonitor.enabled`          | Create ServiceMonitor for Prometheus operator | `false`                                                 |
| `metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `unset`         |
| `metadata.rootPath`                       | Root of key prefix to etcd                    | `by-dev`                                                |
| `authorization.enabled`                   | Enable milvus authorization                   | `false`                                                |
| `log.level`                               | Logging level to be used. Valid levels are `debug`, `info`, `warn`, `error`, `fatal` | `debug`          |
| `log.file.maxSize`                        | The size limit of the log file (MB)           | `300`                                                   |
| `log.file.maxAge`                         | The maximum number of days that the log is retained. (day) | `10`                                       |
| `log.file.maxBackups`                     | The maximum number of retained logs.          | `20`                                                    |
| `log.format`                              | Format used for the logs. Valid formats are `text` and `json` | `text`                                  |
| `log.persistence.enabled`                 | Use persistent volume to store Milvus logs data | `false`                                               |
| `log.persistence.mountPath`               | Milvus logs data persistence volume mount path | `/milvus/logs`                                         |
| `log.persistence.annotations`             | PersistentVolumeClaim annotations             | `{}`                                                    |
| `log.persistence.persistentVolumeClaim.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`                           |
| `log.persistence.persistentVolumeClaim.storageClass` | The Milvus logs data Persistent Volume Storage Class | `unset`                               |
| `log.persistence.persistentVolumeClaim.accessModes` | The Milvus logs data Persistence access modes | `ReadWriteOnce`                               |
| `log.persistence.persistentVolumeClaim.size` | The size of Milvus logs data Persistent Volume Storage Class | `5Gi`                                 |
| `log.persistence.persistentVolumeClaim.subPath` | SubPath for Milvus logs data mount | `unset`                                                      |
| `msgChannel.chanNamePrefix.cluster`                       | Pulsar topic name prefix                    | `by-dev`                                                |
| `quotaAndLimits.enabled`                  | Enable milvus quota and limits                | `false`                                                |
| `quotaAndLimits.quotaCenterCollectInterval`                  | Collect metrics interval                | `3`                                                |
| `quotaAndLimits.ddl.eabled`               | Enable milvus ddl limit                       | `false`                                                |
| `quotaAndLimits.ddl.collectionRate`       | Milvus ddl collection rate per minute         | `unset`                                                |
| `quotaAndLimits.ddl.partitionRate`        | Milvus ddl partition rate per minute          | `unset`                                                |
| `quotaAndLimits.ddl.indexRate`            | Milvus ddl index rate per minute              | `unset`                                                |
| `quotaAndLimits.ddl.flushRate`            | Milvus ddl flush rate per minute              | `unset`                                                |
| `quotaAndLimits.ddl.compactionRate`       | Milvus ddl compaction rate per minute         | `unset`                                                |
| `quotaAndLimits.dml.eabled`               | Enable milvus dml limit                       | `false`                                                |
| `quotaAndLimits.dml.insertRate.max`       | Milvus dml max insert rate MB/s               | `unset`                                                |
| `quotaAndLimits.dml.insertRate.min`       | Milvus dml min insert rate MB/s               | `unset`                                                |
| `quotaAndLimits.dml.deleteRate.max`       | Milvus dml max delete rate MB/s               | `unset`                                                |
| `quotaAndLimits.dml.deleteRate.min`       | Milvus dml min delete rate MB/s               | `unset`                                                |
| `quotaAndLimits.dml.bulkLoadRate.max`     | Milvus dml max bulk load rate MB/s            | `unset`                                                |
| `quotaAndLimits.dml.bulkLoadRate.min`     | Milvus dml min bulk load rate MB/s            | `unset`                                                |
| `quotaAndLimits.dql.eabled`               | Enable milvus dql limit                       | `false`                                                |
| `quotaAndLimits.dql.searchRate.max`       | Milvus dml max search vps                     | `unset`                                                |
| `quotaAndLimits.dql.searchRate.min`       | Milvus dml min search vps                     | `unset`                                                |
| `quotaAndLimits.dql.queryRate.max`        | Milvus dml max query qps                      | `unset`                                                |
| `quotaAndLimits.dql.queryRate.min`        | Milvus dml max query qps                      | `unset`                                                |
| `quotaAndLimits.limitWriting.forceDeny`   | Deny write requests if quota exceeded         | `false`                                                |
| `quotaAndLimits.limitWriting.ttProtection.enabled`   | Enable milvus time tick protection         | `true`                                                |
| `quotaAndLimits.limitWriting.ttProtection.maxTimeTickDelay`   | Max time tick delay in seconds        | `30`                                                |
| `quotaAndLimits.limitWriting.memProtection.enabled`   | Enable milvus memory protection         | `true`                                                |
| `quotaAndLimits.limitWriting.memProtection.dataNodeMemoryLowWaterLevel`     | Low water level for data node      | `0.8`                                                |
| `quotaAndLimits.limitWriting.memProtection.dataNodeMemoryHighWaterLevel`    | High water level for data node     | `0.9`                                                |
 | `quotaAndLimits.limitWriting.memProtection.queryNodeMemoryLowWaterLevel`   | Low water level for query node     | `0.8`                                                |
| `quotaAndLimits.limitWriting.memProtection.queryNodeMemoryHighWaterLevel`   | High water level for query node    | `0.9`                                                |
| `quotaAndLimits.limitReading.forceDeny`   | Deny read requests if quota exceeded          | `false`                                                |
| `quotaAndLimits.limitReading.queueProtection.nqInQueueThreshold`   | NQ in queue threshold         | `unset`                                                |
| `quotaAndLimits.limitReading.queueProtection.queueLatencyThreshold`   | Queue latency threshold         | `unset`                                                |
| `quotaAndLimits.limitReading.queueProtection.coolOffSpeed`   | Cooloff speed         | `0.9`                                                |
| `externalS3.enabled`                      | Enable or disable external S3                 | `false`                                                 |
| `externalS3.host`                         | The host of the external S3                   | `unset`                                                 |
| `externalS3.port`                         | The port of the external S3                   | `unset`                                                 |
| `externalS3.accessKey`                    | The Access Key of the external S3             | `unset`                                                 |
| `externalS3.secretKey`                    | The Secret Key of the external S3             | `unset`                                                 |
| `externalS3.bucketName`                   | The Bucket Name of the external S3            | `unset`                                                 |
| `externalS3.useSSL`                       | If true, use SSL to connect to the external S3 | `false`                                                |
| `externalS3.useIAM`                       | If true, use iam to connect to the external S3 | `false`                                                |
| `externalS3.iamEndpoint`                  | The IAM endpoint of  the external S3 | ``                                                |
| `externalGcs.bucketName`                  | The Bucket Name of the external GCS. Requires GCS gateway to be enabled in the minIO configuration | `unset`                                                |
| `externalEtcd.enabled`                    | Enable or disable external Etcd               | `false`                                                 |
| `externalEtcd.endpoints`                  | The endpoints of the external etcd            | `{}`                                                    |
| `externalPulsar.enabled`                  | Enable or disable external Pulsar             | `false`                                                 |
| `externalPulsar.host`                     | The host of the external Pulsar               | `localhost`                                             |
| `externalPulsar.port`                     | The port of the external Pulsar               | `6650`                                                  |
| `externalKafka.enabled`                   | Enable or disable external Kafka             | `false`                                                 |
| `externalKafka.brokerList`                | The brokerList of the external Kafka separated by comma               | `localhost:9092`                                             |
| `externalKafka.securityProtocol`          | The securityProtocol used for kafka authentication                    | `SASL_SSL`                                                   |
| `externalKafka.sasl.mechanisms`           | SASL mechanism to use for kafka authentication                        | `PLAIN`                                                      |
| `externalKafka.sasl.username`             | username for PLAIN or SASL/PLAIN authentication                       | ``                                                           |
| `externalKafka.sasl.password`             | password for PLAIN or SASL/PLAIN authentication                       | ``                                                           |
| `externalMysql.enabled`                   | Enable or disable external MySQL             | `false`                                                 |
| `externalMysql.username`                  | MySQL username                               |                                        ``                                                      |
| `externalMysql.password`                  | MySQL password                               | ``                                                      |
| `externalMysql.address`                   | MySQL address                                | `localhost`                                             |
| `externalMysql.port`                      | MySQL port                                   | `3306`                                                  |
| `externalMysql.dbName`                    | MySQL meta database                          | `milvus_meta`                                           |
| `externalMysql.maxOpenConns`              | MySQL client maxOpenConns                    | `20`                                                    |
| `externalMysql.maxIdleConns`              | MySQL client maxIdleConns                    | `5`                                                     |

### Milvus Standalone Deployment Configuration

The following table lists the configurable parameters of the Milvus Standalone component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `standalone.resources`                    | Resource requests/limits for the Milvus Standalone pods | `{}`                                          |
| `standalone.nodeSelector`                 | Node labels for Milvus Standalone pods assignment | `{}`                                                |
| `standalone.affinity`                     | Affinity settings for Milvus Standalone pods assignment | `{}`                                          |
| `standalone.tolerations`                  | Toleration labels for Milvus Standalone pods assignment | `[]`                                          |
| `standalone.heaptrack.enabled`            | Whether to enable heaptrack                             | `false`                                          |
| `standalone.disk.enabled`                 | Whether to enable disk                             | `false`                                          |
| `standalone.profiling.enabled`            | Whether to enable live profiling                   | `false`                                          |
| `standalone.extraEnv`                     | Additional Milvus Standalone container environment variables | `[]`                                     |
| `standalone.messageQueue`                     | Message queue for Milvus Standalone: rocksmq, pulsar, kafka | `rocksmq`                                     |
| `standalone.rocksmq.retentionTimeInMinutes` | Set the retention time of rocksmq           | `10080`                                                 |
| `standalone.rocksmq.retentionSizeInMB`    | Set the retention size of rocksmq             | `0`                                                     |
| `standalone.persistence.enabled`          | Use persistent volume to store Milvus standalone data | `true`                                          |
| `standalone.persistence.mountPath` | Milvus standalone data persistence volume mount path | `/var/lib/milvus`                                       |
| `standalone.persistence.annotations`      | PersistentVolumeClaim annotations             | `{}`                                                    |
| `standalone.persistence.persistentVolumeClaim.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`                    |
| `standalone.persistence.persistentVolumeClaim.storageClass` | The Milvus standalone data Persistent Volume Storage Class | `unset`                  |
| `standalone.persistence.persistentVolumeClaim.accessModes` | The Milvus standalone data Persistence access modes | `ReadWriteOnce`                  |
| `standalone.persistence.persistentVolumeClaim.size` | The size of Milvus standalone data Persistent Volume Storage Class | `5Gi`                    |
| `standalone.persistence.persistentVolumeClaim.subPath` | SubPath for Milvus standalone data mount | `unset`                                         |

### Milvus Proxy Deployment Configuration

The following table lists the configurable parameters of the Milvus Proxy component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `proxy.enabled`                           | Enable or disable Milvus Proxy Deployment     | `true`                                                  |
| `proxy.replicas`                          | Desired number of Milvus Proxy pods            | `1`                                                    |
| `proxy.resources`                         | Resource requests/limits for the Milvus Proxy pods | `{}`                                               |
| `proxy.nodeSelector`                      | Node labels for Milvus Proxy pods assignment | `{}`                                                     |
| `proxy.affinity`                          | Affinity settings for Milvus Proxy pods assignment | `{}`                                               |
| `proxy.tolerations`                       | Toleration labels for Milvus Proxy pods assignment | `[]`                                               |
| `proxy.heaptrack.enabled`                 | Whether to enable heaptrack                             | `false`                                          |
| `proxy.profiling.enabled`                 | Whether to enable live profiling                   | `false`                                          |
| `proxy.extraEnv`                          | Additional Milvus Proxy container environment variables | `[]`                                          |
| `proxy.http.enabled`                          | Enable rest api for Milvus Proxy | `false`                                          |
| `proxy.http.debugMode.enabled`                          | Enable debug mode for rest api | `false`                                          |

### Milvus Root Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Root Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `rootCoordinator.enabled`                 | Enable or disable Milvus Root Coordinator component  | `true`                                           |
| `rootCoordinator.resources`               | Resource requests/limits for the Milvus Root Coordinator pods | `{}`                                    |
| `rootCoordinator.nodeSelector`            | Node labels for Milvus Root Coordinator pods assignment | `{}`                                          |
| `rootCoordinator.affinity`                | Affinity settings for Milvus Root Coordinator pods assignment | `{}`                                    |
| `rootCoordinator.tolerations`             | Toleration labels for Milvus Root Coordinator pods assignment | `[]`                                    |
| `rootCoordinator.heaptrack.enabled`       | Whether to enable heaptrack                             | `false`                                          |
| `rootCoordinator.profiling.enabled`       | Whether to enable live profiling                   | `false`                                          |
| `rootCoordinator.extraEnv`                | Additional Milvus Root Coordinator container environment variables | `[]`                               |
| `rootCoordinator.service.type`                       | Service type                                  | `ClusterIP`                                  |
| `rootCoordinator.service.port`                       | Port where service is exposed                 | `19530`                                      |
| `rootCoordinator.service.nodePort`                   | Service nodePort                              | `unset`                                      |
| `rootCoordinator.service.annotations`                | Service annotations                           | `{}`                                         |
| `rootCoordinator.service.labels`                     | Service custom labels                         | `{}`                                         |
| `rootCoordinator.service.clusterIP`                  | Internal cluster service IP                   | `unset`                                      |
| `rootCoordinator.service.loadBalancerIP`             | IP address to assign to load balancer (if supported) | `unset`                               |
| `rootCoordinator.service.loadBalancerSourceRanges`   | List of IP CIDRs allowed access to lb (if supported) | `[]`                                  |
| `rootCoordinator.service.externalIPs`                | Service external IP addresses                 | `[]`                                         |

### Milvus Query Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Query Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `queryCoordinator.enabled`                | Enable or disable Query Coordinator component | `true`                                                  |
| `queryCoordinator.resources`              | Resource requests/limits for the Milvus Query Coordinator pods | `{}`                                   |
| `queryCoordinator.nodeSelector`           | Node labels for Milvus Query Coordinator pods assignment | `{}`                                         |
| `queryCoordinator.affinity`               | Affinity settings for Milvus Query Coordinator pods assignment | `{}`                                   |
| `queryCoordinator.tolerations`            | Toleration labels for Milvus Query Coordinator pods assignment | `[]`                                   |
| `queryCoordinator.heaptrack.enabled`      | Whether to enable heaptrack                             | `false`                                          |
| `queryCoordinator.profiling.enabled`      | Whether to enable live profiling                   | `false`                                          |
| `queryCoordinator.extraEnv`               | Additional Milvus Query Coordinator container environment variables | `[]`                              |
| `queryCoordinator.service.type`                       | Service type                                  | `ClusterIP`                                 |
| `queryCoordinator.service.port`                       | Port where service is exposed                 | `19530`                                     |
| `queryCoordinator.service.nodePort`                   | Service nodePort                              | `unset`                                     |
| `queryCoordinator.service.annotations`                | Service annotations                           | `{}`                                        |
| `queryCoordinator.service.labels`                     | Service custom labels                         | `{}`                                        |
| `queryCoordinator.service.clusterIP`                  | Internal cluster service IP                   | `unset`                                     |
| `queryCoordinator.service.loadBalancerIP`             | IP address to assign to load balancer (if supported) | `unset`                              |
| `queryCoordinator.service.loadBalancerSourceRanges`   | List of IP CIDRs allowed access to lb (if supported) | `[]`                                 |
| `queryCoordinator.service.externalIPs`                | Service external IP addresses                 | `[]`                                        |

### Milvus Query Node Deployment Configuration

The following table lists the configurable parameters of the Milvus Query Node component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `queryNode.enabled`                       | Enable or disable Milvus Query Node component | `true`                                                  |
| `queryNode.replicas`                      | Desired number of Milvus Query Node pods | `1`                                                          |
| `queryNode.resources`                     | Resource requests/limits for the Milvus Query Node pods | `{}`                                          |
| `queryNode.nodeSelector`                  | Node labels for Milvus Query Node pods assignment | `{}`                                                |
| `queryNode.affinity`                      | Affinity settings for Milvus Query Node pods assignment | `{}`                                          |
| `queryNode.tolerations`                   | Toleration labels for Milvus Query Node pods assignment | `[]`                                          |
| `queryNode.heaptrack.enabled`             | Whether to enable heaptrack                             | `false`                                          |
| `queryNode.disk.enabled`                  | Whether to enable disk for query                             | `false`                                          |
| `queryNode.profiling.enabled`             | Whether to enable live profiling                   | `false`                                          |
| `queryNode.extraEnv`                      | Additional Milvus Query Node container environment variables | `[]`                                     |
| `queryNode.grouping.enabled`              | Enable grouping small nq search |               `true`                                     |
| `queryNode.grouping.maxNQ`                | Grouping small nq search max threshold |               `1000`                                     |

### Milvus Index Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Index Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `indexCoordinator.enabled`                | Enable or disable Index Coordinator component | `true`                                                  |
| `indexCoordinator.resources`              | Resource requests/limits for the Milvus Index Coordinator pods | `{}`                                   |
| `indexCoordinator.nodeSelector`           | Node labels for Milvus Index Coordinator pods assignment | `{}`                                         |
| `indexCoordinator.affinity`               | Affinity settings for Milvus Index Coordinator pods assignment | `{}`                                   |
| `indexCoordinator.tolerations`            | Toleration labels for Milvus Index Coordinator pods assignment | `[]`                                   |
| `indexCoordinator.heaptrack.enabled`      | Whether to enable heaptrack                             | `false`                                          |
| `indexCoordinator.profiling.enabled`      | Whether to enable live profiling                   | `false`                                          |
| `indexCoordinator.extraEnv`               | Additional Milvus Index Coordinator container environment variables | `[]`                              |
| `indexCoordinator.service.type`                       | Service type                                  | `ClusterIP`                                 |
| `indexCoordinator.service.port`                       | Port where service is exposed                 | `19530`                                     |
| `indexCoordinator.service.nodePort`                   | Service nodePort                              | `unset`                                     |
| `indexCoordinator.service.annotations`                | Service annotations                           | `{}`                                        |
| `indexCoordinator.service.labels`                     | Service custom labels                         | `{}`                                        |
| `indexCoordinator.service.clusterIP`                  | Internal cluster service IP                   | `unset`                                     |
| `indexCoordinator.service.loadBalancerIP`             | IP address to assign to load balancer (if supported) | `unset`                              |
| `indexCoordinator.service.loadBalancerSourceRanges`   | List of IP CIDRs allowed access to lb (if supported) | `[]`                                 |
| `indexCoordinator.service.externalIPs`                | Service external IP addresses                 | `[]`                                        |
| `indexCoordinator.gc.interval`                        | GC interval in seconds                 | `600`                                        |

### Milvus Index Node Deployment Configuration

The following table lists the configurable parameters of the Milvus Index Node component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `indexNode.enabled`                       | Enable or disable Index Node component        | `true`                                                  |
| `indexNode.replicas`                      | Desired number of Index Node pods             | `1`                                                     |
| `indexNode.resources`                     | Resource requests/limits for the Milvus Index Node pods | `{}`                                          |
| `indexNode.nodeSelector`                  | Node labels for Milvus Index Node pods assignment | `{}`                                                |
| `indexNode.affinity`                      | Affinity settings for Milvus Index Node pods assignment | `{}`                                          |
| `indexNode.tolerations`                   | Toleration labels for Milvus Index Node pods assignment | `[]`                                          |
| `indexNode.heaptrack.enabled`             | Whether to enable heaptrack                             | `false`                                          |
| `indexNode.disk.enabled`                  | Whether to enable disk for index node                             | `false`                                          |
| `indexNode.profiling.enabled`             | Whether to enable live profiling                   | `false`                                          |
| `indexNode.extraEnv`                      | Additional Milvus Index Node container environment variables | `[]`                                     |
| `indexNode.scheduler.buildParallel`       | Index task build paralellism | `1`                                     |

### Milvus Data Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Data Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `dataCoordinator.enabled`                 | Enable or disable Data Coordinator component  | `true`                                                  |
| `dataCoordinator.resources`               | Resource requests/limits for the Milvus Data Coordinator pods | `{}`                                    |
| `dataCoordinator.nodeSelector`            | Node labels for Milvus Data Coordinator pods assignment | `{}`                                          |
| `dataCoordinator.affinity`                | Affinity settings for Milvus Data Coordinator pods assignment  | `{}`                                   |
| `dataCoordinator.tolerations`             | Toleration labels for Milvus Data Coordinator pods assignment | `[]`                                    |
| `dataCoordinator.heaptrack.enabled`       | Whether to enable heaptrack                             | `false`                                          |
| `dataCoordinator.profiling.enabled`       | Whether to enable live profiling                   | `false`                                          |
| `dataCoordinator.segment.maxSize`         | Maximum size of a segment in MB                   | `512`                                          |
| `dataCoordinator.segment.sealProportion`         | Minimum proportion for a segment which can be sealed                   | `0.25`                                          |
| `dataCoordinator.segment.maxLife`         | Maximum lifetime of a segment in seconds                   | `3600`                                          |
| `dataCoordinator.extraEnv`                | Additional Milvus Data Coordinator container environment variables | `[]`                               |
| `dataCoordinator.service.type`                        | Service type                                  | `ClusterIP`                                 |
| `dataCoordinator.service.port`                        | Port where service is exposed                 | `19530`                                     |
| `dataCoordinator.service.nodePort`                    | Service nodePort                              | `unset`                                     |
| `dataCoordinator.service.annotations`                 | Service annotations                           | `{}`                                        |
| `dataCoordinator.service.labels`                      | Service custom labels                         | `{}`                                        |
| `dataCoordinator.service.clusterIP`                   | Internal cluster service IP                   | `unset`                                     |
| `dataCoordinator.service.loadBalancerIP`              | IP address to assign to load balancer (if supported) | `unset`                              |
| `dataCoordinator.service.loadBalancerSourceRanges`    | List of IP CIDRs allowed access to lb (if supported) | `[]`                                 |
| `dataCoordinator.service.externalIPs`                 | Service external IP addresses                 | `[]`                                        |

### Milvus Data Node Deployment Configuration

The following table lists the configurable parameters of the Milvus Data Node component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `dataNode.enabled`                        | Enable or disable Data Node component         | `true`                                                  |
| `dataNode.replicas`                       | Desired number of Data Node pods               | `1`                                                    |
| `dataNode.resources`                      | Resource requests/limits for the Milvus Data Node pods | `{}`                                           |
| `dataNode.nodeSelector`                   | Node labels for Milvus Data Node pods assignment | `{}`                                                 |
| `dataNode.affinity`                       | Affinity settings for Milvus Data Node pods assignment | `{}`                                           |
| `dataNode.tolerations`                    | Toleration labels for Milvus Data Node pods assignment | `[]`                                           |
| `dataNode.heaptrack.enabled`              | Whether to enable heaptrack                             | `false`                                          |
| `dataNode.profiling.enabled`              | Whether to enable live profiling                   | `false`                                          |
| `dataNode.extraEnv`                       | Additional Milvus Data Node container environment variables | `[]`                                      |

### Pulsar Configuration

This version of the chart includes the dependent Pulsar chart in the charts/ directory.

You can find more information at:
* [https://pulsar.apache.org/charts](https://pulsar.apache.org/charts)

### Etcd Configuration

This version of the chart includes the dependent Etcd chart in the charts/ directory.

You can find more information at:
* [https://artifacthub.io/packages/helm/bitnami/etcd](https://artifacthub.io/packages/helm/bitnami/etcd)

### Minio Configuration

This version of the chart includes the dependent Minio chart in the charts/ directory.

You can find more information at:
* [https://github.com/minio/charts/blob/master/README.md](https://github.com/minio/charts/blob/master/README.md)

### Kafka Configuration

This version of the chart includes the dependent Kafka chart in the charts/ directory.

You can find more information at:
* [https://artifacthub.io/packages/helm/bitnami/kafka](https://artifacthub.io/packages/helm/bitnami/kafka)

### MySQL Configuration

This version of the chart includes the dependent MySQL chart in the charts/ directory.

You can find more information at:
* [https://artifacthub.io/packages/helm/bitnami/mysql](https://artifacthub.io/packages/helm/bitnami/mysql)

### Milvus Live Profiling
Profiling is an effective way of understanding which parts of your application are consuming the most resources.

Continuous Profiling adds a dimension of time that allows you to understand your systems resource usage (i.e. CPU, Memory, etc.) over time and gives you the ability to locate, debug, and fix issues related to performance.

You can enable profiling with Pyroscope and you can find more information at:
* [https://pyroscope.io/docs/kubernetes-helm-chart/](https://pyroscope.io/docs/kubernetes-helm-chart/)
