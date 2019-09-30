<p align="center">
<img width="680px" src="https://user-images.githubusercontent.com/16992394/65840473-f70ca780-e319-11e9-9245-29ec0a8948d6.png">
</p>
<h2 align="center">🐳 Elastic Stack on Docker, with preconfigured security, tools, self-monitoring, and Prometheus Metrics Exporters</h2>
<h4 align="center">Comes with tools like Curator, ElastAlert for Alerting.</h4>
<p align="center">
   <a>
      <img src="https://img.shields.io/badge/Elastic%20Stack->=7.0.0-blue?style=flat&logo=elasticsearch" alt="Elastic Stack Version 7^^">
   </a>
   <a>
      <img src="https://img.shields.io/github/v/tag/sherifabdlnaby/elastdocker?label=release&amp;sort=semver">
    </a>
   <a>
      <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat" alt="contributions welcome">
   </a>
   <a href="https://github.com/sherifabdlnaby/elastdocker/network">
      <img src="https://img.shields.io/github/forks/sherifabdlnaby/elastdocker.svg" alt="GitHub forks">
   </a>
   <a href="https://github.com/sherifabdlnaby/elastdocker/issues">
        <img src="https://img.shields.io/github/issues/sherifabdlnaby/elastdocker.svg" alt="GitHub issues">
   </a>
   <a href="https://raw.githubusercontent.com/sherifabdlnaby/elastdocker/blob/master/LICENSE">
      <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="GitHub license">
   </a>
</p>

# Introduction
Elastic Stack (AKA **ELK**) Docker Composition, preconfigured with **Security**, **Monitoring**, Tools such as **ElastAlert** for alerting and **Curator**.

### Main Points 📜

- Configured as Production Single Node Cluster (With a multi-node option for experimenting).
- Use Docker-Compose and `.env` to configure your stack.
- Security Enabled (under basic license).
- SSL Enabled for Transport Layer.
- Automated Script that initializes and persist Elasticsearch's Keystore and SSL Certifications.
- Curator Preconfigured for Automated Snapshotting (Need to setup S3 Repository).
- Self-Monitoring Metrics Enabled.
- Filebeat instance for shipping Stack logs to Elasticsearch itself.
- Prometheus Exporters for Stack Metrics.
- ElastAlert preconfigured for Alerting.
- Embedded Container Healthchecks for Stack Images.

-----

# Requirements 

- [Docker 17.05 or higher](https://docs.docker.com/install/) 
- [Docker-Compose 3.4 or higher](https://docs.docker.com/compose/install/) (optional) 

# Setup

1. 
> <a href="https://github.com/sherifabdlnaby/elastdocker/generate"><img src="https://user-images.githubusercontent.com/16992394/65464461-20c95880-de5a-11e9-9bf0-fc79d125b99e.png" alt="create repository from template"></a>
2. Go to repository directory
3. Modify `.env` file for your requirments, most importantly `ELASTIC_PASSWORD` that setup your superuser `elastic`'s password. and `ELK_VERSION` for, yk, ELK Version.
4. Initalize Elasticsearch Keystore and SSL Certificates
```shell
$ make setup
```
5. Start Elastic Stack 
```shell
$ make elk
---- OR ----
$ docker-compose up -d
```
6. Visit Kibana at [localhost:5601](http://localhost:5601) 

Username: `elastic`

Password: `changeme` (or `ELASTIC_PASSWORD` value in `.env`)

### Additional Commands

#### To Start Monitoring and Promethus Exporters
```shell
$ make monitoring
```
#### To Start Tools (ElastAlert and Curator
```shell
$ make tools
```
#### To Start **ELK, Tools and Monitoring**
```
$ make all
```
#### To Start 2 Extra Elasticsearch nodes (for development only)
```shell
$ make nodes
```

### Notes

- Adding Two Extra Nodes to the cluster will make the cluster depending on them and won't start without them again.

- Makefile is a wrapper around `Docker-Compose` commands, use `make help` to know every command.

- Elasticsearch will save its data to a volume named `elasticsearch-data`

- Elasticsearch Keystore (that contains passwords and credentials) and SSL Certificate are generated in the `./secrets` directory by the setup command.

- Linux Users must set the following configuration as `root`
```
sysctl -w vm.max_map_count=262144
```
By default, Virtual Memory [is not enough](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html).


# Configuration

* Some Configuration are parameterized in the `.env` file.
  * `ELASTIC_PASSWORD`, user `elastic`'s password (default: `changeme` _pls_).
  * `ELK_VERSION` Elastic Stack Version (default: `7.3.0`)
  * `ELASTICSEARCH_HEAP`, how much Elasticsearch allocate from memory (default: 1GB -good for development only-)
  * `LOGSTASH_HEAP`, how much Logstash allocate from memory.
  * Other configurations which their such as cluster name, and node name, etc.
* Elasticsearch Configuration in `elasticsearch.yml` at `./elasticsearch/config`.
* Logstash Configuration in `logstash.yml` at `./elasticsearch/config/logstash.yml`.
* Logstash Pipeline in `main.conf` at `./elasticsearch/pipeline/main.conf`.
* Kibana Configuration in `kibana.yml` at `./kibana/config`.
* ElastAlert Configuration in `./tools/elastalert/config`.
* ElastAlert Alert rules in `./tools/elastalert/rules`, [head to ElastAlert docs to lookup how to create alerts.](https://elastalert.readthedocs.io/en/latest/elastalert.html)
* Curator Actions at `./tools/curator/actions` and `./tools/curator/crontab`.

### Setting Up Keystore

You can extend the Keystore generation script by adding keys to `./setup/keystore.sh` script. (e.g Add S3 Snapshot Repository Credentials)

To Re-generate Keystore:
```
make keystore
```

# Monitoring Cluster

### Prometheus Exporters
If you started Prometheus Exporters using `make monitoring` command. Prometheus Exporters will expose metrics at the following ports.

| **Prometheus Exporter**      | **Port**     | **Note**                                         |
|--------------------------    |----------    |------------------------------------------------  |
| `elasticsearch-exporter`     | `9114`       | -                                                |
| `logstash-exporter`          | `9304`       | -                                                |
| `cadvisor-exporter`          | `8080`       | - To Monitor Each Container stats and metrics.   |

### Self-Monitoring is Enabled

Head to Stack Monitoring tab in Kibana to see cluster metrics for all stack components.

![Metrics](https://user-images.githubusercontent.com/16992394/65841358-b0bb4680-e321-11e9-9a71-36a1d6fb2a41.png)
![Metrics](https://user-images.githubusercontent.com/16992394/65841362-b6189100-e321-11e9-93e4-b7b2caa5a37d.jpg)

> In Production, cluster metrics should be shipped to another dedicated monitoring cluster. 

  
# License 
[MIT License](https://raw.githubusercontent.com/sherifabdlnaby/elastdocker/blob/master/LICENSE)
Copyright (c) 2019 Sherif Abdel-Naby

# Contribution

PR(s) are Open and Welcomed.
