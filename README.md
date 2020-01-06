# Milvus Helm Chart

* For more information about installing and using Helm, see the [Helm Docs](https://helm.sh/docs/). For a quick introduction to Charts, see the [Chart Guide](https://helm.sh/docs/topics/charts/).

* Installs the milvus system [Milvus installation](https://milvus.io/docs/guides/get_started/install_milvus/install_milvus.md)

## Introduction
This chart bootstraps an milvus deployment on a Kubernetes cluster using the Helm package manager.

## Prerequisites

- Kubernetes 1.10+
- Helm >= 2.12.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
# Helm v2.x
$ cd milvus-helm/milvus
$ helm install --name my-release .
```

or

```console
# Helm v3.x
$ cd milvus-helm/milvus
$ helm install my-release  .
```

After a few minutes, you should see service statuses being written to the configured output, which is a log file inside the milvus container.

> **Tip**: List all releases using `helm list`

## Uninstall the Chart

To uninstall/delete the my-release deployment:

```console
# Helm v2.x
$ helm delete my-release
```

or

```console
# Helm v3.x
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

### Milvus Server Configuration

The following table lists the configurable parameters of the milvus server and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `primaryPath`                             | Path used to store data and metadata          | `/var/lib/milvus/data`                                  |
| `timeZone`                                | Time zone                                     | `UTC+8`                                                 |
| `backendURL`                              | URI format: dialect://username:password@host:port/database,Replace 'dialect' with 'mysql' or 'sqlite' | `""` |
| `deployMode`                              | Deployment type: single, cluster_readonly, cluster_writable | `single`                                  |
| `insertBufferSize`                        | Maximum insert buffer size allowed (GB)       | `1`                                                     |
| `cpuCacheCapacity`                        | Size of CPU memory used for cache  (GB)       | `4`                                                    |
| `cacheInsertData`                         | Load inserted data into cache                 | `false`                                                 |
| `useBLASThreshold`                        | BLAS threshold                                | `1100`                                                  |
| `gpuSearchThreshold`                      | GPU search threshold                          | `1100`                                                  |
| `gpu.enabled`                             | Enable GPU resources                          | `false`                                                 |
| `gpu.cacheCapacity`                       | Size of GPU memory per card used for cache (GB) | `1`                                                     |
| `gpu.searchResources`                     | Define the GPU devices used for search computation | `[gpu0]`                                           |
| `gpu.buildIndexResources`                 | Define the GPU devices used for index building | `[gpu0]`                                               |
| `metrics.enabled`                         | Set this to `true` to enable exporting Prometheus monitoring metrics | `false`                          |
| `metrics.port`                            | Prometheus monitoring metrics port            | `8080`                                                  |

### Milvus Deploy Configuration

The following table lists the configurable parameters of the milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `replicas`                                | Number of nodes                               | `1`                                                     |
| `initContainerImage`                      | Init container image                          | `alpine:3.8`                                            |
| `image.repository`                        | Image repository                              | `milvusdb/milvus`                                       |
| `image.tag`                               | Image tag                                     | `cpu-latest`                                            |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `image.pullSecrets`                       | Image pull secrets                            | `{}`                                                    |
| `resources`                               | CPU/GPU/Memory resource requests/limits       | `{}`                                                    |
| `extraInitContainers`                     | Additional init containers                    | `[]`                                                    |
| `extraContainers`                         | Additional containers                         | `unset`                                                 |
| `extraVolumes`                            | Additional volumes for use in extraContainers | `unset`                                                 |
| `extraVolumeMounts`                       | Additional volume mounts to add to the pods   | `unset`                                                 |
| `extraConfigFiles`                        | Content of additional configuration files.    | `{}`                                                    |
| `livenessProbe`                           | Liveness Probe settings                       | `{ "tcpSocket": { "port": 19530 } "initialDelaySeconds": 15, "periodSeconds": 15, "timeoutSeconds": 10, "failureThreshold": 5 }` |
| `readinessProbe`                          | Readiness Probe settings                      | `{ "tcpSocket": { "port": 19530 } "initialDelaySeconds": 15, "periodSeconds": 15, "timeoutSeconds": 10, "failureThreshold": 3 }` |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                            | Kubernetes port where service is exposed      | `19530`                                                 |
| `service.portName`                        | Name of the port on the service               | `service`                                               |
| `service.nodePort`                        | Kubernetes service nodePort                   | `unset`                                                 |
| `service.annotations`                     | Service annotations                           | `{}`                                                    |
| `service.labels`                          | Custom labels                                 | `{}`                                                    |
| `service.clusterIP`                       | Internal cluster service IP                   | `unset`                                                 |
| `service.loadBalancerIP`                  | IP address to assign to load balancer (if supported) | `unset`                                          |
| `service.loadBalancerSourceRanges`        | list of IP CIDRs allowed access to lb (if supported) | `[]`                                             |
| `serivce.externalIPs`                     | service external IP addresses                 | `[]`                                                    |
| `persistence.enabled`                     | Use persistent volume to store data           | `false`                                                 |
| `persistence.annotations`                 | PersistentVolumeClaim annotations             | `{}`                                                    |
| `persistence.persistentVolumeClaim.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`                               |
| `persistence.persistentVolumeClaim.storageClass` | The milvus data Persistent Volume Storage Class | `unset`                                        |
| `persistence.persistentVolumeClaim.accessModes` | The milvus data Persistence access modes | `ReadWriteMany`                                        |
| `persistence.persistentVolumeClaim.size` | The size of milvus data Persistent Volume Storage Class | `50Gi`                                         |
| `persistence.persistentVolumeClaim.subPath` | SubPath for milvus data mount               | `data`                                                  |
| `nodeSelector`                            | Node labels for pod assignment                | `{}`                                                    |
| `tolerations`                             | Toleration labels for pod assignment          | `[]`                                                    |
| `affinity`                                | Affinity settings for pod assignment          | `{}`                                                    |
| `podAnnotations`                          | Additional pod annotations                    | `{}`                                                    |
| `podDisruptionBudget.minAvailable`        | Pod disruption minimum available              | `unset`                                                 |
| `podDisruptionBudget.maxUnavailable`      | Pod disruption maximum unavailable            | `unset`                                                 |


### MySQL Configuration

The following table lists the configurable parameters of the mysql chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `mysql.enable`                            | Enable deployment of MySQL                    | `true`                                                  |
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
| `mysql.persistence.size`                  | Size of persistent volume claim               | `8Gi`                                                   |