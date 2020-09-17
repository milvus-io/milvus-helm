# Milvus Helm Chart

For more information about installing and using Helm, see the [Helm Docs](https://helm.sh/docs/). For a quick introduction to Charts, see the [Chart Guide](https://helm.sh/docs/topics/charts/).

To install Milvus, refer to [Milvus installation](https://milvus.io/docs/guides/get_started/install_milvus/install_milvus.md).

## Introduction
This chart bootstraps Milvus deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.10+
- Helm >= 2.12.0

## Installing the Chart

1. Add the stable repository
```bash
$ helm repo add stable https://kubernetes-charts.storage.googleapis.com
$ helm repo add milvus https://milvus-io.github.io/milvus-helm/
```

2. Update charts repositories
```
$ helm repo update
```

3. Install Helm package

To install the chart with the release name `my-release`:

```bash
# Helm v2.x
$ helm install --name my-release milvus/milvus
```

or

```bash
# Helm v3.x
$ helm install my-release milvus/milvus
```

> **Tip**: To list all releases, using `helm list`.

### Deploying Milvus with cluster enabled

```bash
$ helm install --set cluster.enabled=true --set persistence.enabled=true my-release  .
```

> **NOTE:** Since all Pods should have the same collection of Milvus files, it is recommended to create just one PV
that is shared. This is controlled by setting `persistence.enabled=true`. You will have to ensure yourself the
PVC are shared properly between your pods:
- If you are on AWS, you can use [Elastic File System (EFS)](https://aws.amazon.com/efs/).
- If you are on Azure, you can use
[Azure File Storage (AFS)](https://docs.microsoft.com/en-us/azure/aks/azure-files-dynamic-pv).

To share a PV with multiple Pods, the PV needs to have accessMode 'ReadOnlyMany' or 'ReadWriteMany'.

## Uninstall the Chart

To uninstall/delete the my-release deployment:

```bash
# Helm v2.x
$ helm delete my-release
```

or

```bash
# Helm v3.x
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

### Milvus server Configuration

The following table lists the configurable parameters of the Milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `version`                                 | Configuration Version                         | `0.5`                                                   |
| `primaryPath`                             | Primary directory used to save meta data, vector data and index data. | `/var/lib/milvus`               |
| `timeZone`                                | Use UTC-x or UTC+x to specify a time zone.    | `UTC+8`                                                 |
| `fileCleanupTimeout`                      | The time gap between marking a file as 'deleted' and physically deleting this file from disk, range [0, 3600]. (s) | `10` |
| `storage.autoFlushInterval`               | The interval, in seconds, at which Milvus automatically flushes data to disk. 0 means disable the regular flush. (s) | `1` |
| `logs.path`                               | Absolute path to the folder holding the log files. | `/var/lib/milvus/logs`                             |
| `logs.maxLogFileSize`                     | The maximum size of each log file, size range [512, 4096]. (MB) | `1024MB`                              |
| `logs.logRotateNum`                       | The maximum number of log files that Milvus keeps for each logging level, num range [0, 1024], 0 means unlimited. | `0` |
| `cache.insertBufferSize`                  | Maximum insert buffer size allowed (GB)       | `1GB`                                                   |
| `cache.cacheSize`                         | Size of CPU memory used for cache  (GB)       | `4GB`                                                   |
| `network.httpEnabled`                     | Enable web server or not.                     | `true`                                                  |
| `network.httpPort`                        | Port that Milvus web server monitors.         | `19121`                                                 |
| `wal.enabled`                             | Enable write-ahead logging.                   | `true`                                                  |
| `wal.recoveryErrorIgnore`                 | Whether to ignore logs with errors that happens during WAL | `true`                                     |
| `wal.bufferSize`                          | Sum total of the read buffer and the write buffer. (MB) | `256MB`                                       |
| `wal.path`                                | Location of WAL log files.                    | `/var/lib/milvus/db/wal`                                |
| `gpu.enabled`                             | Enable GPU resources                          | `false`                                                 |
| `gpu.cacheSize`                           | Size of GPU memory per card used for cache (GB) | `1GB`                                                 |
| `gpu.gpuSearchThreshold`                  | GPU search threshold                          | `1000`                                                  |
| `gpu.searchDevices`                       | Define the GPU devices used for search computation | `[gpu0]`                                           |
| `gpu.buildIndexDevices`                   | Define the GPU devices used for index building | `[gpu0]`                                               |
| `metrics.enabled`                         | Set this to `true` to enable exporting Prometheus monitoring metrics | `false`                          |
| `metrics.address`                         | Pushgateway address                           | `127.0.0.1`                                             |
| `metrics.port`                            | Prometheus monitoring metrics port            | `9091`                                                  |
| `readonly.logs.path`                      | Absolute path to the folder holding the log files. | `/var/lib/milvus/logs`                             |
| `readonly.logs.maxLogFileSize`            | The maximum size of each log file, size range [512, 4096]. (MB) | `1024`                                |
| `readonly.logs.logRotateNum`              | The maximum number of log files that Milvus keeps for each logging level, num range [0, 1024], 0 means unlimited. | `0` |
| `readonly.cache.insertBufferSize`         | Maximum insert buffer size allowed (GB)       | `1GB`                                                   |
| `readonly.cache.cacheSize`                | Size of CPU memory used for cache  (GB)       | `4GB`                                                   |
| `readonly.gpu.enabled`                    | Enable GPU resources                          | `false`                                                 |
| `readonly.gpu.cacheSize`                  | Size of GPU memory per card used for cache (GB) | `1GB`                                                 |
| `readonly.gpu.gpuSearchThreshold`         | GPU search threshold                          | `1000`                                                  |
| `readonly.gpu.searchDevices`              | Define the GPU devices used for search computation | `[gpu0]`                                           |
| `readonly.gpu.buildIndexDevices`          | Define the GPU devices used for index building | `[gpu0]`                                               |
| `mishards.debug`                          | Choose if to enable Debug work mode.          | `true`                                                  |
| `mishards.discoveryClassName`             | Under the plug-in search path, search the class based on the class name, and instantiate it. Currently, the system provides 2 classes: static and kubernetes. | `kubernetes` |
| `mishards.trace.enabled`                  | Enable Mishards tracing service.              | `false`                                                 |
| `mishards.trace.tracerClassName`          | Under the plug-in search path, search the class based on the class name, and instantiate it. Currently, only Jaeger is supported. | `Jaeger` |
| `mishards.trace.tracingReportingHost`     | The host of the tracing service.              | `jaeger`                                                |
| `mishards.trace.tracingReportingPort`     | The port of the tracing service.              | `5775`                                                  |


### Milvus Deployment Configuration

The following table lists the configurable parameters of the Milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `cluster.enabled`                         | Create a Milvus cluster                       | `false`                                                 |
| `replicas`                                | Number of nodes                               | `1`                                                     |
| `restartPolicy`                           | Restart policy for all containers             | `Always`                                                |
| `initContainerImage`                      | Init container image                          | `alpine:3.8`                                            |
| `image.repository`                        | Image repository                              | `milvusdb/milvus`                                       |
| `image.tag`                               | Image tag                                     | `0.10.3-cpu-d091720-f962e8`                             |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `image.pullSecrets`                       | Image pull secrets                            | `{}`                                                    |
| `image.resources`                         | CPU/GPU/Memory resource requests/limits       | `{}`                                                    |
| `terminationGracePeriodSeconds`           | Optional duration in seconds the pod needs to terminate gracefully | `30`                               |
| `extraInitContainers`                     | Additional init containers                    | `[]`                                                    |
| `extraContainers`                         | Additional containers                         | `unset`                                                 |
| `extraVolumes`                            | Additional volumes for use in extraContainers | `unset`                                                 |
| `extraVolumeMounts`                       | Additional volume mounts to add to the pods   | `unset`                                                 |
| `extraConfigFiles`                        | Content of additional configuration files.    | `{}`                                                    |
| `livenessProbe`                           | Liveness Probe settings                       | `{ "tcpSocket": { "port": 19530 } "initialDelaySeconds": 15, "periodSeconds": 15, "timeoutSeconds": 10, "failureThreshold": 5 }` |
| `readinessProbe`                          | Readiness Probe settings                      | `{ "tcpSocket": { "port": 19530 } "initialDelaySeconds": 15, "periodSeconds": 15, "timeoutSeconds": 10, "failureThreshold": 3 }` |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                            | Kubernetes port where service is exposed      | `19530`                                                 |
| `service.nodePort`                        | Kubernetes service nodePort                   | `unset`                                                 |
| `service.webNodePort`                     | Kubernetes web server nodePort                | `unset`                                                 |
| `service.metricsNodePort`                 | Kubernetes metrics server nodePort            | `unset`                                                 |
| `service.annotations`                     | Service annotations                           | `{}`                                                    |
| `service.labels`                          | Custom labels                                 | `{}`                                                    |
| `service.clusterIP`                       | Internal cluster service IP                   | `unset`                                                 |
| `service.loadBalancerIP`                  | IP address to assign to load balancer (if supported) | `unset`                                          |
| `service.loadBalancerSourceRanges`        | list of IP CIDRs allowed access to lb (if supported) | `[]`                                             |
| `serivce.externalIPs`                     | service external IP addresses                 | `[]`                                                    |
| `persistence.enabled`                     | Use persistent volume to store data           | `false`                                                 |
| `persistence.annotations`                 | PersistentVolumeClaim annotations             | `{}`                                                    |
| `persistence.persistentVolumeClaim.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`                               |
| `persistence.persistentVolumeClaim.storageClass` | The Milvus data Persistent Volume Storage Class | `unset`                                        |
| `persistence.persistentVolumeClaim.accessModes` | The Milvus data Persistence access modes | `ReadWriteMany`                                        |
| `persistence.persistentVolumeClaim.size` | The size of Milvus data Persistent Volume Storage Class | `50Gi`                                         |
| `persistence.persistentVolumeClaim.subPath` | SubPath for Milvus data mount               | `unset`                                                 |
| `logsPersistence.enabled`                 | Use persistent volume to store logs           | `false`                                                 |
| `logsPersistence.annotations`             | PersistentVolumeClaim annotations             | `{}`                                                    |
| `logsPersistence.persistentVolumeClaim.existingClaim` | Use your own logs Persistent Volume existing claim name | `unset`                           |
| `logsPersistence.persistentVolumeClaim.storageClass` | The Milvus logs Persistent Volume Storage Class | `unset`                                    |
| `logsPersistence.persistentVolumeClaim.accessModes` | The Milvus logs Persistence access modes | `ReadWriteMany`                                    |
| `logsPersistence.persistentVolumeClaim.size` | The size of Milvus logs Persistent Volume Storage Class | `5Gi`                                      |
| `logsPersistence.persistentVolumeClaim.subPath` | SubPath for Milvus logs mount               | `unset`                                             |
| `nodeSelector`                            | Node labels for pod assignment                | `{}`                                                    |
| `tolerations`                             | Toleration labels for pod assignment          | `[]`                                                    |
| `affinity`                                | Affinity settings for pod assignment          | `{}`                                                    |
| `podAnnotations`                          | Additional pod annotations                    | `{}`                                                    |
| `podDisruptionBudget.minAvailable`        | Pod disruption minimum available              | `unset`                                                 |
| `podDisruptionBudget.maxUnavailable`      | Pod disruption maximum unavailable            | `unset`                                                 |
| `mishards.image.repository`               | Mishards image repository                     | `milvusdb/mishards`                                     |
| `mishards.image.tag`                      | Mishards image tag                            | `0.10.3`                                                |
| `mishards.image.pullPolicy`               | Mishards image pull policy                    | `IfNotPresent`                                          |
| `mishards.replicas`                       | Number of mishards nodes                      | `1`                                                     |
| `mishards.resources`                      | Mishards CPU/GPU/Memory resource requests/limits | `{}`                                                 |
| `readonly.replicas`                       | Number of readonly nodes                      | `1`                                                     |
| `mishards.resources`                      | Mishards CPU/GPU/Memory resource requests/limits | `{}`                                                 |
| `admin.enabled`                           | Enable deployment of Milvus admin             | `false`                                                 |
| `admin.image.repository`                  | Milvus Admin image repository                 | `milvusdb/milvus-em`                                    |
| `admin.image.tag`                         | Milvus Admin image tag                        | `v0.4.0`                                                |
| `admin.image.pullPolicy`                  | Milvus Admin image pull policy                | `IfNotPresent`                                          |
| `admin.replicas`                          | Number of Milvus Admin nodes                  | `1`                                                     |
| `admin.resources`                         | Milvus Admin CPU/GPU/Memory resource requests/limits | `{}`                                             |
| `externalMysql.enabled`                   | Use exist mysql database                      | `false`                                                 |
| `externalMysql.ip`                        | IP address                                    | `{}`                                                    |
| `externalMysql.port`                      | Port                                          | `{}`                                                    |
| `externalMysql.user`                      | Username                                      | `{}`                                                    |
| `externalMysql.password`                  | Password for the user                         | `{}`                                                    |
| `externalMysql.database`                  | Database name                                 | `{}`                                                    |


### MySQL Configuration

The following table lists the configurable parameters of the mysql chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `mysql.enabled`                           | Enable deployment of MySQL                    | `true`                                                  |
| `mysql.mysqlDatabase`                     | Database name                                 | `milvus`                                                |
| `mysql.imageTag`                          | Image targe                                   | `5.7.14`                                                |
| `mysql.imagePullPolicy`                   | Image pull policy                             | `IfNotPresent`                                          |
| `mysql.mysqlUser`                         | Username of new user to create.               | `milvus`                                                |
| `mysql.mysqlPassword`                     | Password for the new user. Ignored if existing secret is provided | `milvus`                            |
| `mysql.mysqlRootPassword`                 | Password for the root user. Ignored if existing secret is provided | `milvusroot`                       |
| `mysql.configurationFiles`                | List of mysql configuration files             | `...`                                                   |
| `mysql.initializationFiles`               | List of SQL files which are run after the container started | `...`                                     |
| `mysql.persistence.enabled`               | Create a volume to store data                 | `true`                                                  |
| `mysql.persistence.existingClaim`         | Name of existing persistent volume            | `unset`                                                 |
| `mysql.persistence.annotations`           | Persistent Volume annotations                 | `{}`                                                    |
| `mysql.persistence.storageClass`          | Type of persistent volume claim               | `unset`                                                 |
| `mysql.persistence.accessMode`            | ReadWriteOnce or ReadOnly                     | `ReadWriteOnce`                                         |
| `mysql.persistence.size`                  | Size of persistent volume claim               | `4Gi`                                                   |
