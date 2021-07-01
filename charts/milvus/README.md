# Milvus Helm Chart

For more information about installing and using Helm, see the [Helm Docs](https://helm.sh/docs/). For a quick introduction to Charts, see the [Chart Guide](https://helm.sh/docs/topics/charts/).

To install Milvus, refer to [Milvus installation](https://milvus.io/docs/guides/get_started/install_milvus/install_milvus.md).

## Introduction
This chart bootstraps Milvus deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.14+
- Helm >= 3.0.0

> **IMPORTANT** The master branch is for the development of Milvus v2.0. On March 9th, 2021, we released Milvus v1.0, the first stable version of Milvus with long-term support. To use Milvus v1.x, switch to [branch 1.1](https://github.com/milvus-io/milvus-helm/tree/1.1).

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
$ helm upgrade --install my-release milvus/milvus
```

> **Tip**: To list all releases, using `helm list`.

### Deploy Milvus with cluster mode

Assume the release name is `my-release`:

```bash
# Helm v3.x
$ helm upgrade --install --set cluster.enabled=true my-release milvus/milvus
```

### Upgrade an existing Milvus cluster
E.g. to scale out query node from 1(default) to 2:
```bash
# Helm v3.x
$ helm upgrade --install --set cluster.enabled=true --set queryNode.replicas=2 my-release milvus/milvus
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
| `cluster.enabled`                         | Enable or disable Milvus Cluster mode         | `false`                                                 |
| `image.all.repository`                    | Image repository                              | `milvusdb/milvus`                                       |
| `image.all.tag`                           | Image tag                                     | `v2.0.0-rc1-20210628-b87baa1`                                                |
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
| `log.level`                               | Logging level to be used. Valid levels are `debug`, `info`, `warn`, `error`, `fatal` | `debug`          |
| `log.file.maxSize`                        | The size limit of the log file (MB)           | `300`                                                   |
| `log.file.maxAge`                         | The maximum number of days that the log is retained. (day) | `10`                                       |
| `log.file.maxBackups`                     | The maximum number of retained logs.          | `20`                                                    |
| `log.format`                              | Format used for the logs. Valid formats are `text` and `json` | `text`                                  |
| `externalS3.enabled`                      | Enable or disable external S3                 | `false`                                                 |
| `externalS3.host`                         | The host of the external S3                   | `localhost`                                             |
| `externalS3.port`                         | The port of the external S3                   | `9000`                                                  |
| `externalS3.accessKey`                    | The Access Key of the external S3             | `minioadmin`                                            |
| `externalS3.secretKey`                    | The Secret Key of the external S3             | `minioadmin`                                            |
| `externalEtcd.enabled`                    | Enable or disable external Etcd               | `false`                                                 |
| `externalEtcd.endpoints`                  | The endpoints of the external etcd            | `{}`                                                    |
| `externalPulsar.enabled`                  | Enable or disable external Pulsar             | `false`                                                 |
| `externalPulsar.host`                     | The host of the external Pulsar               | `localhost`                                             |
| `externalPulsar.port`                     | The port of the external Pulsar               | `6650`                                                  |

### Milvus Standalone Deployment Configuration

The following table lists the configurable parameters of the Milvus Standalone component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `standalone.resources`                    | Resource requests/limits for the Milvus Standalone pods | `{}`                                          |
| `standalone.nodeSelector`                 | Node labels for Milvus Standalone pods assignment | `{}`                                                |
| `standalone.affinity`                     | Affinity settings for Milvus Standalone pods assignment | `{}`                                          |
| `standalone.tolerations`                  | Toleration labels for Milvus Standalone pods assignment | `[]`                                          |
| `standalone.extraEnv`                     | Additional Milvus Standalone container environment variables | `[]`                                     |
| `standalone.persistence.enabled`          | Use persistent volume to store Milvus standalone data | `true`                                          |
| `standalone.persistence.mountPath` | Milvus standalone data persistence volume mount path | `/var/lib/milvus`                                       |
| `standalone.persistence.annotations`      | PersistentVolumeClaim annotations             | `{}`                                                    |
| `standalone.persistence.persistentVolumeClaim.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`                    |
| `standalone.persistence.persistentVolumeClaim.storageClass` | The Milvus standalone data Persistent Volume Storage Class | `unset`                  |
| `standalone.persistence.persistentVolumeClaim.accessModes` | The Milvus standalone data Persistence access modes | `ReadWriteOnec`                  |
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
| `proxy.extraEnv`                          | Additional Milvus Proxy container environment variables | `[]`                                          |

### Milvus Root Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Root Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `rootCoordinator.enabled`                 | Enable or disable Milvus Root Coordinator component  | `true`                                           |
| `rootCoordinator.resources`               | Resource requests/limits for the Milvus Root Coordinator pods | `{}`                                    |
| `rootCoordinator.nodeSelector`            | Node labels for Milvus Root Coordinator pods assignment | `{}`                                          |
| `rootCoordinator.affinity`                | Affinity settings for Milvus Root Coordinator pods assignment | `{}`                                    |
| `rootCoordinator.tolerations`             | Toleration labels for Milvus Root Coordinator pods assignment | `[]`                                    |
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
| `queryNode.extraEnv`                      | Additional Milvus Query Node container environment variables | `[]`                                     |

### Milvus Index Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Index Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `indexCoordinator.enabled`                | Enable or disable Index Coordinator component | `true`                                                  |
| `indexCoordinator.resources`              | Resource requests/limits for the Milvus Index Coordinator pods | `{}`                                   |
| `indexCoordinator.nodeSelector`           | Node labels for Milvus Index Coordinator pods assignment | `{}`                                         |
| `indexCoordinator.affinity`               | Affinity settings for Milvus Index Coordinator pods assignment | `{}`                                   |
| `indexCoordinator.tolerations`            | Toleration labels for Milvus Index Coordinator pods assignment | `[]`                                   |
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
| `indexNode.extraEnv`                      | Additional Milvus Index Node container environment variables | `[]`                                     |

### Milvus Data Coordinator Deployment Configuration

The following table lists the configurable parameters of the Milvus Data Coordinator component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `dataCoordinator.enabled`                 | Enable or disable Data Coordinator component  | `true`                                                  |
| `dataCoordinator.resources`               | Resource requests/limits for the Milvus Data Coordinator pods | `{}`                                    |
| `dataCoordinator.nodeSelector`            | Node labels for Milvus Data Coordinator pods assignment | `{}`                                          |
| `dataCoordinator.affinity`                | Affinity settings for Milvus Data Coordinator pods assignment  | `{}`                                   |
| `dataCoordinator.tolerations`             | Toleration labels for Milvus Data Coordinator pods assignment | `[]`                                    |
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
| `dataNode.extraEnv`                       | Additional Milvus Data Node container environment variables | `[]`                                      |

### Pulsar Standalone Deployment Configuration

The following table lists the configurable parameters of the Pulsar Standalone component and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `pulsarStandalone.enabled`                | Enable or disable Pulsar Standalone mode      | `true`                                                  |
| `pulsarStandalone.resources`              | Resource requests/limits for the Pulsar Standalone pods | `{}`                                          |
| `pulsarStandalone.nodeSelector`           | Node labels for Pulsar Standalone pods assignment | `{}`                                                |
| `pulsarStandalone.affinity`               | Affinity settings for Pulsar Standalone pods assignment | `{}`                                          |
| `pulsarStandalone.tolerations`            | Toleration labels for Pulsar Standalone pods assignment | `[]`                                          |
| `pulsarStandalone.extraEnv`               | Additional Pulsar Standalone container environment variables | `[]`                                     |
| `pulsarStandalone.service.type`                        | Service type                                  | `ClusterIP`                                |
| `pulsarStandalone.service.port`                        | Port where service is exposed                 | `19530`                                    |
| `pulsarStandalone.service.nodePort`                    | Service nodePort                              | `unset`                                    |
| `pulsarStandalone.service.annotations`                 | Service annotations                           | `{}`                                       |
| `pulsarStandalone.service.labels`                      | Service custom labels                         | `{}`                                       |
| `pulsarStandalone.service.clusterIP`                   | Internal cluster service IP                   | `unset`                                    |
| `pulsarStandalone.service.loadBalancerIP`              | IP address to assign to load balancer (if supported) | `unset`                             |
| `pulsarStandalone.service.loadBalancerSourceRanges`    | List of IP CIDRs allowed access to lb (if supported) | `[]`                                |
| `pulsarStandalone.service.externalIPs`                 | Service external IP addresses                 | `[]`                                       |
| `pulsarStandalone.persistence.enabled`          | Use persistent volume to store Pulsar standalone data | `true`                                    |
| `pulsarStandalone.persistence.mountPath` | Pulsar standalone data persistence volume mount path | `/var/lib/milvus`                                 |
| `pulsarStandalone.persistence.annotations`      | PersistentVolumeClaim annotations             | `{}`                                              |
| `pulsarStandalone.persistence.persistentVolumeClaim.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`              |
| `pulsarStandalone.persistence.persistentVolumeClaim.storageClass` | The Pulsar standalone data Persistent Volume Storage Class | `unset`            |
| `pulsarStandalone.persistence.persistentVolumeClaim.accessModes` | The Pulsar standalone data Persistence access modes | `ReadWriteOnec`            |
| `pulsarStandalone.persistence.persistentVolumeClaim.size` | The size of Pulsar standalone data Persistent Volume Storage Class | `5Gi`              |
| `pulsarStandalone.persistence.persistentVolumeClaim.subPath` | SubPath for Pulsar standalone data mount | `unset`                                   |

### Pulsar Configuration

This version of the chart includes the dependent Pulsar chart in the charts/ directory.

You can find more information at:
* [https://github.com/kafkaesque-io/pulsar-helm-chart](https://github.com/kafkaesque-io/pulsar-helm-chart)

### Etcd Configuration

This version of the chart includes the dependent Etcd chart in the charts/ directory.

You can find more information at:
* [https://artifacthub.io/packages/helm/bitnami/etcd](https://artifacthub.io/packages/helm/bitnami/etcd)

### Minio Configuration

This version of the chart includes the dependent Minio chart in the charts/ directory.

You can find more information at:
* [https://github.com/minio/charts/blob/master/README.md](https://github.com/minio/charts/blob/master/README.md)
