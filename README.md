<p align="center">
<img width="680px" src="https://user-images.githubusercontent.com/16992394/65840473-f70ca780-e319-11e9-9245-29ec0a8948d6.png">
</p>
<h2 align="center">🐳 Elastic Stack on Docker, with preconfigured security, tools, self-monitoring, and Prometheus Metrics Exporters</h2>
<h4 align="center">With tools like Curator, ElastAlert for Alerting.</h4>
<p align="center">
   <a>
      <img src="https://img.shields.io/badge/Elastic%20Stack-7.5.0-blue?style=flat&logo=elasticsearch" alt="Elastic Stack Version 7^^">
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

Based on [Official Elastic Docker Images](https://www.docker.elastic.co/)

Stack Version: [7.5.0](https://www.elastic.co/blog/elastic-stack-7-5-0-released).
> You can change Elastic Stack version by setting `ELK_VERSION` in `.env` file and rebuild your images. Any version >= 7.0.0 is compatible with this template.

### Main Points 📜

- Configured as Production Single Node Cluster. (With a multi-node option for experimenting).
- Security Enabled (under basic license).
- SSL Enabled for Transport Layer.
- Use Docker-Compose and `.env` to configure your stack.
- Automated Script that initializes and persist Elasticsearch's Keystore and SSL Certifications.
- Curator Preconfigured for Automated Snapshotting (Need to setup S3 Repository).
- Self-Monitoring Metrics Enabled.
- Prometheus Exporters for Stack Metrics.
- Filebeat instance for shipping Stack logs to Elasticsearch itself.
- ElastAlert preconfigured for Alerting.
- Embedded Container Healthchecks for Stack Images.

More points at [comparison with deviantony/docker-elk](#Comparison)

-----

# Requirements 

- [Docker 17.05 or higher](https://docs.docker.com/install/) 
- [Docker-Compose 3 or higher](https://docs.docker.com/compose/install/) (optional) 

# Setup

1. Clone the Repository, or:
> <a href="https://github.com/sherifabdlnaby/elastdocker/generate"><img src="https://user-images.githubusercontent.com/16992394/65464461-20c95880-de5a-11e9-9bf0-fc79d125b99e.png" alt="create repository from template"></a>
2. Initialize Elasticsearch Keystore and SSL Certificates
```shell
$ make setup
```
3. Start Elastic Stack 
```shell
$ make elk
---- OR ----
$ docker-compose up -d
```
4. Visit Kibana at [localhost:5601](http://localhost:5601) 

Username: `elastic` Password: `changeme` (or `ELASTIC_PASSWORD` value in `.env`)

> Modify `.env` file for your needs, most importantly `ELASTIC_PASSWORD` that setup your superuser `elastic`'s password, `ELASTICSEARCH_HEAP` & `LOGSTASH_HEAP` for Elasticsearch & Logstash Heap Size and `ELK_VERSION` for, yk, Stack Version.

### Additional Commands

#### To Start Monitoring and Prometheus Exporters
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
#### To Rebuild Images
```shell
$ make build
```
#### Bring down the stack.
```shell
$ make down
```

> Make sure to run `make setup` if you changed `ELASTIC_PASSWORD` and to restart the stack after changing anything in `.env`.

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
  * `ELK_VERSION` Elastic Stack Version (default: `7.5.0`)
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

### Enable SSL on HTTP 

By default, only transport layer has SSL Enabled, to enable SSL on Http layer, add the following lines to `elasticsearch.yml`
```yaml
## - http
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.verification_mode: certificate
xpack.security.http.ssl.keystore.path: certs/elastic-certificates.p12
xpack.security.http.ssl.truststore.path: certs/elastic-certificates.p12
```

> Enabling SSL on HTTP layer will require all clients that connect to elasticsearch to configure SSL connection, this includes all current parts of the stack (e.g Logstash, Kibana, Curator, etc).

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

# Comparison

One of the most popular elk on docker repositories is the awesome [deviantony/docker-elk](https://github.com/deviantony/docker-elk).
Elastdocker differs from `deviantony/docker-elk` in the following points.

- Security enabled by default using Basic license, not Trial.

- Persisting data by default in a volume.

- Run in Production Mode (by enabling SSL on Transport Layer, and add initial master node settings).

- Persisting Generated Keystore, and create an extendable script that makes it easier to recreate it every-time the container is created.

- Parameterize credentials in .env instead of hardcoding `elastich:changeme` in every component config.

- Parameterize all other Config like Heap Size.

- Add recommended environment configurations as Ulimits and Swap disable to the docker-compose.

- Make it ready to be extended into a multinode cluster.

- Configuring the Self-Monitoring and the Filebeat agent that ship ELK logs to ELK itself. (as a step to shipping it to a monitoring cluster in the future).

- Configured tools and Prometheus Exporters.

- The Makefile that simplifies everything into some simple commands.
  
# License 
[MIT License](https://raw.githubusercontent.com/sherifabdlnaby/elastdocker/blob/master/LICENSE)
Copyright (c) 2019 Sherif Abdel-Naby

# Contribution

PR(s) are Open and Welcomed.