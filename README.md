<p align="center">
<img width="680px" src="https://user-images.githubusercontent.com/16992394/65840473-f70ca780-e319-11e9-9245-29ec0a8948d6.png">
</p>
<h2 align="center">Elastic Stack on Docker with Preconfigured Security, Tools, Self-Monitoring, and Prometheus Metrics Exporters</h2>
<h4 align="center">With tools like Curator, Rubban, ElastAlert for Alerting.</h4>
<p align="center">
   <a>
      <img src="https://img.shields.io/badge/Elastic%20Stack-7.12.0-blue?style=flat&logo=elasticsearch" alt="Elastic Stack Version 7^^">
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
Elastic Stack (**ELK**) Docker Composition, preconfigured with **Security**, **Monitoring**, and **Tools**; Up with a Single Command.

Based on [Official Elastic Docker Images](https://www.docker.elastic.co/)

Stack Version: [7.12.0](https://www.elastic.co/blog/elastic-stack-7-12-0-released)
> You can change Elastic Stack version by setting `ELK_VERSION` in `.env` file and rebuild your images. Any version >= 7.0.0 is compatible with this template.

### Main Features 📜

- Configured as Production Single Node Cluster. (With a multi-node cluster option for experimenting).
- Deployed on a Single Docker Host or a Docker Swarm Cluster.
- Security Enabled (under basic license).
- SSL Enabled for Transport Layer and Kibana.
- Use Docker-Compose and `.env` to configure your entire stack parameters.
- Persist Elasticsearch's Keystore and SSL Certifications.
- Self-Monitoring Metrics Enabled.
- Prometheus Exporters for Stack Metrics.
- Embedded Container Healthchecks for Stack Images.
- [ElastAlert](https://github.com/Yelp/elastalert) preconfigured for Alerting.
- [Curator](https://github.com/elastic/curator) with Crond preconfigured for Automated Scheduled tasks (e.g Snapshots to S3).
- [Rubban](https://github.com/sherifabdlnaby/rubban) for Kibana curating tasks.

#### More points
And comparing Elastdocker and the popular [deviantony/docker-elk](https://github.com/deviantony/docker-elk)

<details><summary>Expand...</summary>
<p>

One of the most popular ELK on Docker repositories is the awesome [deviantony/docker-elk](https://github.com/deviantony/docker-elk).
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

</p>
</details>

-----

# Requirements

- [Docker 17.05 or higher](https://docs.docker.com/install/)
- [Docker-Compose 3 or higher](https://docs.docker.com/compose/install/)
- 4GB RAM (For Windows and MacOS make sure Docker's VM has more than 4GB+ memory.)

# Setup

1. Clone the Repository
     ```bash
     git clone https://github.com/sherifabdlnaby/elastdocker.git
     ```
2. Initialize Elasticsearch Keystore and TLS Self-Signed Certificates
    ```bash
    $ make setup
    ```
    > **For Linux's docker hosts only**. By default virtual memory [is not enough](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) so run the next command as root `sysctl -w vm.max_map_count=262144`
3. Start Elastic Stack
    ```bash
    $ make elk           <OR>         $ docker-compose up -d
    ```
4. Visit Kibana at [https://localhost:5601](https://localhost:5601) or `https://<your_public_ip>:5601`

    Default Username: `elastic`, Password: `changeme`

    > - Notice that Kibana is configured to use HTTPS, so you'll need to write `https://` before `localhost:5601` in the browser.
    > - Modify `.env` file for your needs, most importantly `ELASTIC_PASSWORD` that setup your superuser `elastic`'s password, `ELASTICSEARCH_HEAP` & `LOGSTASH_HEAP` for Elasticsearch & Logstash Heap Size.

Whatever your Host (e.g AWS EC2, Azure, DigitalOcean, or on-premise server), once you expose your host to the network, ELK component will be accessible on their respective ports.

### Docker Swarm Support

Elastdocker can be deployed to Docker Swarm using `make swarm-deploy`

<details><summary>Expand</summary>
<p>

However it is not recommended to [depend on Docker Swarm](https://boxboat.com/2019/12/10/migrate-docker-swarm-to-kubernetes/); if your scale needs a multi-host cluster to host your ELK then Kubernetes is the recommended next step.

Elastdocker should be used for small production workloads enough to fit on a single host.

> Docker Swarm lacks some features such as `ulimits` used to disable swapping in Elasticsearch container, please change `bootstrap.memory_lock` to `false` in docker-compose.yml and find an [alternative way](https://www.elastic.co/guide/en/elasticsearch/reference/master/setup-configuration-memory.html) to disable swapping in your swarm cluster.

</p>
</details>

## Additional Commands

<details><summary>Expand</summary>
<p>

#### To Start Monitoring and Prometheus Exporters
```shell
$ make monitoring
```
#### To Start Tools (ElastAlert, Rubban, and Curator)
```shell
$ make tools
```
#### To Start **Elastic Stack, Tools and Monitoring**
```
$ make all
```
#### To Start 2 Extra Elasticsearch nodes (recommended for experimenting only)
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

#### Reset everything, Remove all containers, and delete **DATA**!
```shell
$ make prune
```

</p>
</details>

# Configuration

* Some Configuration are parameterized in the `.env` file.
  * `ELASTIC_PASSWORD`, user `elastic`'s password (default: `changeme` _pls_).
  * `ELK_VERSION` Elastic Stack Version (default: `7.12.0`)
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
* Rubban Configuration using Docker-Compose passed Environment Variables.

### Setting Up Keystore

You can extend the Keystore generation script by adding keys to `./setup/keystore.sh` script. (e.g Add S3 Snapshot Repository Credentials)

To Re-generate Keystore:
```
make keystore
```

### Enable SSL on HTTP

By default, only Transport Layer has SSL Enabled, to enable SSL on HTTP layer, add the following lines to `elasticsearch.yml`
```yaml
## - http
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.key: certs/elasticsearch.key
xpack.security.http.ssl.certificate: certs/elasticsearch.crt
xpack.security.http.ssl.certificate_authorities: certs/ca.crt
xpack.security.http.ssl.client_authentication: optional
```

> ⚠️ Enabling SSL on HTTP layer will require all clients that connect to Elasticsearch to configure SSL connection for HTTP, this includes all the current configured parts of the stack (e.g Logstash, Kibana, Curator, etc) plus any library/binding that connects to Elasticsearch from your application code.


### Notes

- Adding Two Extra Nodes to the cluster will make the cluster depending on them and won't start without them again.

- Makefile is a wrapper around `Docker-Compose` commands, use `make help` to know every command.

- Elasticsearch will save its data to a volume named `elasticsearch-data`

- Elasticsearch Keystore (that contains passwords and credentials) and SSL Certificate are generated in the `./secrets` directory by the setup command.

- Make sure to run `make setup` if you changed `ELASTIC_PASSWORD` and to restart the stack afterwards.

- For Linux Users it's recommended to set the following configuration (run as `root`)
    ```
    sysctl -w vm.max_map_count=262144
    ```
    By default, Virtual Memory [is not enough](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html).

---------------------------

# Monitoring The Cluster

### Via Prometheus Exporters
If you started Prometheus Exporters using `make monitoring` command. Prometheus Exporters will expose metrics at the following ports.

| **Prometheus Exporter**      | **Port**     | **Recommended Grafana Dashboard**                                         |
|--------------------------    |----------    |------------------------------------------------  |
| `elasticsearch-exporter`     | `9114`       | [Elasticsearch by Kristian Jensen](https://grafana.com/grafana/dashboards/4358)                                                |
| `logstash-exporter`          | `9304`       | [logstash-monitoring by dpavlos](https://github.com/dpavlos/logstash-monitoring)                                               |

![Metrics](https://user-images.githubusercontent.com/16992394/78685076-89a58900-78f1-11ea-959b-ce374fe51500.jpg)

### Via Self-Monitoring

Head to Stack Monitoring tab in Kibana to see cluster metrics for all stack components.

![Metrics](https://user-images.githubusercontent.com/16992394/65841358-b0bb4680-e321-11e9-9a71-36a1d6fb2a41.png)
![Metrics](https://user-images.githubusercontent.com/16992394/65841362-b6189100-e321-11e9-93e4-b7b2caa5a37d.jpg)

> In Production, cluster metrics should be shipped to another dedicated monitoring cluster.

# License
[MIT License](https://raw.githubusercontent.com/sherifabdlnaby/elastdocker/master/LICENSE)
Copyright (c) 2020 Sherif Abdel-Naby

# Contribution

PR(s) are Open and Welcomed.