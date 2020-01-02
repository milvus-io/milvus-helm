# Milvus Helm Chart

* Installs the milvus system [Milvus](https://milvus.io/)

## Prerequisites

- Kubernetes 1.9+
- Helm >= 2.12.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
# Helm v2.x
$ cd milvus-helm/milvus
$ helm install --name my-release .
```

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

```console
# Helm v3.x
$ helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

### Configuration

The following table lists the configurable parameters of the milvus chart and their default values.

| Parameter                                 | Description                                   | Default                                                 |
|-------------------------------------------|-----------------------------------------------|---------------------------------------------------------|
| `engine.image.repository`                 | Image repository                              | `milvusdb/milvus`                                       |
| `engine.image.tag`                        | Image tag                                     | `cpu-latest`                                            |
| `engine.image.pullPolicy`                 | Image pull policy                             | `IfNotPresent`                                          |
| `engine.image.pullSecrets`                | Image pull secrets                            | `{}`                                                    |