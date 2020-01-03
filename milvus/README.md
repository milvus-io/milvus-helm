# Milvus Helm Chart

* Installs the milvus system [Milvus](https://milvus.io/)

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

### Milvus Configuration

The following table lists the configurable parameters of the milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `replicas`                                | Number of nodes                               | `1`                                                     |
| `podDisruptionBudget.minAvailable`        | Pod disruption minimum available              | `unset`                                                 |
| `podDisruptionBudget.maxUnavailable`      | Pod disruption maximum unavailable            | `unset`                                                 |
| `livenessProbe`                           | Liveness Probe settings                       | `{ "tcpSocket": { "port": 19530 } "initialDelaySeconds": 15, "periodSeconds": 15, "timeoutSeconds": 10, "failureThreshold": 5 }` |
| `readinessProbe`                          | Readiness Probe settings                      | `{ "tcpSocket": { "port": 19530 } "initialDelaySeconds": 15, "periodSeconds": 15, "timeoutSeconds": 10, "failureThreshold": 3 }` |
| `image.repository`                        | Image repository                              | `milvusdb/milvus`                                       |
| `image.tag`                               | Image tag                                     | `cpu-latest`                                            |
| `image.pullPolicy`                        | Image pull policy                             | `IfNotPresent`                                          |
| `image.pullSecrets`                       | Image pull secrets                            | `{}`                                                    |
| `service.type`                            | Kubernetes service type                       | `ClusterIP`                                             |
| `service.port`                            | Kubernetes port where service is exposed      | `19530`                                                 |
| `service.portName`                        | Name of the port on the service               | `service`                                               |
| `service.targetPort`                      | Internal service is port                      | `19530`                                                 |
| `service.nodePort`                        | Kubernetes service nodePort                   | `unset`                                                 |
| `service.annotations`                     | Service annotations                           | `{}`                                                    |
| `service.labels`                          | Custom labels                                 | `{}`                                                    |
| `service.clusterIP`                       | internal cluster service IP                   | `unset`                                                 |
| `service.loadBalancerIP`                  | IP address to assign to load balancer (if supported) | `unset`                                          |
| `service.loadBalancerSourceRanges`        | list of IP CIDRs allowed access to lb (if supported) | `[]`                                             |
| `serivce.externalIPs`                     | service external IP addresses                 | `[]`                                                    |
| `resources`                               | CPU/GPU/Memory resource requests/limits       | `{}`                                                    |
| `persistence.enabled`                     | Use persistent volume to store data           | `false`                                                 |
| `persistence.persistentVolumeClaim.dbdata.existingClaim` | Use your own data Persistent Volume existing claim name | `unset`                        |
| `persistence.persistentVolumeClaim.dbdata.storageClass` | The milvus data Persistent Volume Storage Class | `unset`                                 |
| `persistence.persistentVolumeClaim.dbdata.accessModes` | The milvus data Persistence access modes | `ReadWriteMany`                                 |
| `persistence.persistentVolumeClaim.dbdata.size` | The size of milvus data Persistent Volume Storage Class | `50Gi`                                  |
| `persistence.persistentVolumeClaim.dbdata.subPath` | SubPath for milvus data mount        | `dbdata`                                                |
| `persistence.persistentVolumeClaim.logfile.existingClaim` | Use your own logfile Persistent Volume existing claim name | `unset`                    |
| `persistence.persistentVolumeClaim.logfile.storageClass` | The milvus logfile Persistent Volume Storage Class | `unset`                             |
| `persistence.persistentVolumeClaim.logfile.accessModes` | The milvus logfile Persistence access modes | `ReadWriteMany`                             |
| `persistence.persistentVolumeClaim.logfile.size` | The size of milvus logfile Persistent Volume Storage Class | `5Gi`                               |
| `persistence.persistentVolumeClaim.logfile.subPath` | SubPath for milvus logfile mount    | `logs`                                                  |
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
| `mysql.persistence.size`                  | Size of persistent volume claim               | `8Gi RW`                                                |