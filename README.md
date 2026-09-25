<p align="center">
<img width="500px" src="https://user-images.githubusercontent.com/16992394/147855783-07b747f3-d033-476f-9e06-96a4a88a54c6.png">
</p>
<h2 align="center"><b>Elast</b>ic Stack on <b>Docker</b></h2>
<h3 align="center">Preconfigured Security, Tools, and Self-Monitoring</h3>
<h4 align="center">Configured to be ready to be used for Log, Metrics, APM, Alerting, Machine Learning, and Security (SIEM) usecases.</h4>
<p align="center">
   <a>
      <img src="https://img.shields.io/badge/Elastic%20Stack-9.4.2-blue?style=flat&logo=elasticsearch" alt="Elastic Stack Version 9^^">
   </a>
   <a>
      <img src="https://img.shields.io/github/v/tag/sherifabdlnaby/elastdocker?label=release&amp;sort=semver">
   </a>
   <a href="https://github.com/sherifabdlnaby/elastdocker/actions/workflows/smoke-test.yml">
      <img src="https://github.com/sherifabdlnaby/elastdocker/actions/workflows/smoke-test.yml/badge.svg">
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

Suitable for Demoing, MVPs and small production deployments.

Stack Version: [9.4.2](https://www.elastic.co/guide/en/elasticsearch/reference/9.4/release-notes-9.4.2.html) 🎉 - Based on [Official Elastic Docker Images](https://www.docker.elastic.co/)
> You can change Elastic Stack version by setting `ELK_VERSION` in `.env` file and rebuild your images. Any version >= 9.0.0 is compatible with this template.
>
> ⚠️ **Upgrading from 8.x?** See the [Upgrade Notes](#upgrade-notes-from-8x-to-9x) section below for breaking changes and migration steps.
---

## Main Features 📜

- Configured as a Production Single Node Cluster. (With a multi-node cluster option for experimenting).
- Security Enabled By Default.
- Configured to Enable:
  - Logging & Metrics Ingestion
    - Option to collect logs of all Docker Containers running on the host. via `mise run elk:collect-docker-logs`.
  - APM
  - Alerting
  - Machine Learning
  - Anomaly Detection
  - SIEM (Security information and event management).
  - Enabling Trial License
- Use Docker Compose and `.env` to configure your entire stack parameters.
- Persist Elasticsearch's Keystore and SSL Certifications.
- Self-Monitoring Metrics Enabled (using Metricbeat for ES 9+).
- Prometheus Exporters for Stack Metrics.
- Embedded Container Healthchecks for Stack Images.

### More points

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

- Add recommended environment configurations as Ulimits and Swap disable to Docker Compose.

- Make it ready to be extended into a multinode cluster.

- Configuring the Self-Monitoring and the Filebeat agent that ship ELK logs to ELK itself. (as a step to shipping it to a monitoring cluster in the future).

- Configured Prometheus Exporters.

- mise tasks that wrap every stack operation into one short command.

</p>
</details>

### Automatic Docker Container Log Collection

Collect logs from **all Docker containers** on your host with a single command:

```bash
mise run elk:collect-docker-logs
```

Filebeat automatically discovers containers, parses logs, and ships them to Elasticsearch. View and analyze everything in Kibana with zero configuration.

---

## Requirements

- [Docker 20.05 or higher](https://docs.docker.com/install/) with Docker Compose v2
- 4GB RAM (For Windows and MacOS make sure Docker's VM has more than 4GB+ memory.)
- [mise](https://mise.jdx.dev) 2026.9.13 or newer. All stack commands are mise tasks.

<details>
<summary><b>Install mise (first time on this machine)</b></summary>

```bash
brew install mise                   # or: curl https://mise.run | sh
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc   # bash: mise activate bash
mise doctor                         # confirm the install is healthy
```

See the [installation docs](https://mise.jdx.dev/installing-mise.html) for other shells and Windows.

</details>

## Setup

1. Clone the Repository, and allow its mise config to load

     ```bash
     git clone https://github.com/sherifabdlnaby/elastdocker.git
     cd elastdocker
     mise trust
     ```

2. Initialize Elasticsearch Keystore and TLS Self-Signed Certificates

    ```bash
    mise run elk:setup
    ```

   > **For Linux's docker hosts only**. By default virtual memory [is not enough](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html) so run the next command as root `sysctl -w vm.max_map_count=262144`
3. Start Elastic Stack

    ```bash
    mise run elk       # <OR>  docker compose up -d
    ```

4. Visit Kibana at [https://localhost:5601](https://localhost:5601) or `https://<your_public_ip>:5601`

   Default Username: `elastic`, Password: `changeme`

    > - Notice that Kibana is configured to use HTTPS, so you'll need to write `https://` before `localhost:5601` in the browser.
    > - Modify `.env` file for your needs, most importantly `ELASTIC_PASSWORD` that setup your superuser `elastic`'s password, `ELASTICSEARCH_HEAP` & `LOGSTASH_HEAP` for Elasticsearch & Logstash Heap Size.

> Whatever your Host (e.g AWS EC2, Azure, DigitalOcean, or on-premise server), once you expose your host to the network, ELK component will be accessible on their respective ports. Since the enabled TLS uses a self-signed certificate, it is recommended to SSL-Terminate public traffic using your signed certificates.
>
> 🏃🏻‍♂️ To start ingesting logs, you can start by running `mise run elk:collect-docker-logs` which will collect your host's container logs.

### Additional Commands

All stack commands live under the `elk:` namespace. Run `mise tasks` to list them, and `mise run <task> --help` to see a task's arguments (e.g. `mise run elk:logs kibana` tails one service).

<details><summary>Expand</summary>
<p>

#### To Start Monitoring and Prometheus Exporters

```shell
mise run elk:monitoring
```

##### To Ship Docker Container Logs to ELK

```shell
mise run elk:collect-docker-logs
```

##### To Start **Elastic Stack, Tools and Monitoring**

```text
mise run elk:all
```

##### To Start 2 Extra Elasticsearch nodes (recommended for experimenting only)

```shell
mise run elk:nodes
```

##### To Rebuild Images

```shell
mise run elk:build
```

##### Bring down the stack

```shell
mise run elk:down
```

##### Reset everything, Remove all containers, and delete **DATA**

```shell
mise run elk:prune
```

</p>
</details>

### Moving from `make`

The `Makefile` is gone; the stack now needs [mise](https://mise.jdx.dev) (see [Requirements](#requirements)). Each old command maps to a mise task with the same compose files, flags, and services:

| Old command                                  | New command                        |
|----------------------------------------------|------------------------------------|
| `make setup` / `mise run stack:setup`        | `mise run elk:setup`               |
| `make certs` / `mise run certs`              | `mise run elk:certs`               |
| `make keystore` / `mise run keystore`        | `mise run elk:keystore`            |
| `make upgrade-keystore` / `mise run upgrade-keystore` | `mise run elk:keystore:upgrade` |
| `make elk`, `make up` / `mise run up`        | `mise run elk`                     |
| `make all` / `mise run all`                  | `mise run elk:all`                 |
| `make monitoring` / `mise run monitoring`    | `mise run elk:monitoring`          |
| `make nodes` / `mise run nodes`              | `mise run elk:nodes`               |
| `make collect-docker-logs` / `mise run collect-docker-logs` | `mise run elk:collect-docker-logs` |
| `make build` / `mise run build`              | `mise run elk:build`               |
| `make ps` / `mise run ps`                    | `mise run elk:ps`                  |
| `make images` / `mise run images`            | `mise run elk:images`              |
| `make logs` / `mise run logs`                | `mise run elk:logs`                |
| `make stop` / `mise run stop`                | `mise run elk:stop`                |
| `make restart` / `mise run restart`          | `mise run elk:restart`             |
| `make down` / `mise run down`                | `mise run elk:down`                |
| `make rm` / `mise run rm`                    | `mise run elk:rm`                  |
| `make prune` / `mise run prune`              | `mise run elk:prune`               |
| `make help`                                  | `mise tasks`                       |

`elk:rm` and `elk:prune` ask for confirmation; pass `-y` before the task name to skip it (`mise run -y elk:prune`).

## Configuration

- Some Configuration are parameterized in the `.env` file.
  - `ELASTIC_PASSWORD`, user `elastic`'s password (default: `changeme` _pls_).
  - `ELK_VERSION` Elastic Stack Version (default: `9.4.2`)
  - `ELASTICSEARCH_HEAP`, how much Elasticsearch allocate from memory (default: 1GB -good for development only-)
  - `LOGSTASH_HEAP`, how much Logstash allocate from memory.
  - Other configurations which their such as cluster name, and node name, etc.
- Elasticsearch Configuration in `elasticsearch.yml` at `./elasticsearch/config`.
- Logstash Configuration in `logstash.yml` at `./logstash/config/logstash.yml`.
- Logstash Pipeline in `main.conf` at `./logstash/pipeline/main.conf`.
- Kibana Configuration in `kibana.yml` at `./kibana/config`.
- Metricbeat Configuration in `metricbeat.yml` at `./metricbeat/config` (for Stack Monitoring in ES 9+).

### Setting Up Keystore

You can extend the Keystore generation script by adding keys to `./setup/keystore.sh` script. (e.g Add S3 Snapshot Repository Credentials)

To Re-generate Keystore:

```text
mise run elk:keystore
```

#### Notes

- ⚠️ Elasticsearch HTTP layer is using SSL, thus mean you need to configure your elasticsearch clients with the `CA` in `secrets/certs/ca/ca.crt`, or configure client to ignore SSL Certificate Verification (e.g `--insecure` in `curl`).

- Adding Two Extra Nodes to the cluster will make the cluster depending on them and won't start without them again.

- The stack is driven by mise tasks; run `mise tasks` to list them.

- Elasticsearch will save its data to a volume named `elasticsearch-data`

- Elasticsearch Keystore (that contains passwords and credentials) and SSL Certificate are generated in the `./secrets` directory by the setup command.

- Make sure to run `mise run elk:setup` if you changed `ELASTIC_PASSWORD` and to restart the stack afterwards.

- For Linux Users it's recommended to set the following configuration (run as `root`)

    ```text
    sysctl -w vm.max_map_count=262144
    ```

  By default, Virtual Memory [is not enough](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html).

---

![Intro](https://user-images.githubusercontent.com/16992394/156664447-c24c49f4-4282-4d6a-81a7-10743cfa384e.png)
![Alerting](https://user-images.githubusercontent.com/16992394/156664848-d14f5e58-8f80-497d-a841-914c05a4b69c.png)
![Maps](https://user-images.githubusercontent.com/16992394/156664562-d38e11ee-b033-4b91-80bd-3a866ad65f56.png)
![ML](https://user-images.githubusercontent.com/16992394/156664695-5c1ed4a7-82f3-47a6-ab5c-b0ce41cc0fbe.png)

## Working with Elastic APM

After completing the setup step, you will notice a container named apm-server which gives you deeper visibility into your applications and can help you to identify and resolve root cause issues with correlated traces, logs, and metrics.

### Authenticating with Elastic APM

In order to authenticate with Elastic APM, you will need the following:

- The value of `ELASTIC_APM_SECRET_TOKEN` defined in `.env` file as we have [secret token](https://www.elastic.co/guide/en/apm/guide/master/secret-token.html) enabled by default
- The ability to reach port `8200`
- Install elastic apm client in your application e.g. for NodeJS based applications you need to install [elastic-apm-node](https://www.elastic.co/guide/en/apm/agent/nodejs/master/typescript.html)
- Import the package in your application and call the start function, In case of NodeJS based application you can do the following:

```text
const apm = require('elastic-apm-node').start({
  serviceName: 'foobar',
  secretToken: process.env.ELASTIC_APM_SECRET_TOKEN,

  // https is enabled by default as per elastdocker configuration
  serverUrl: 'https://localhost:8200',
})
```

> Make sure that the agent is started before you require any other modules in your Node.js application - i.e. before express, http, etc. as mentioned in [Elastic APM Agent - NodeJS initialization](https://www.elastic.co/guide/en/apm/agent/nodejs/master/express.html#express-initialization)

For more details or other languages you can check the following:

- [APM Agents in different languages](https://www.elastic.co/guide/en/apm/agent/index.html)

## Monitoring The Cluster

### Via Stack Monitoring (Metricbeat)

**Elasticsearch 9+** uses Metricbeat for Stack Monitoring (the recommended approach). When you start monitoring with `mise run elk:monitoring`, Metricbeat will collect metrics from all stack components and send them to Elasticsearch.

Head to **Stack Monitoring** tab in Kibana to see cluster metrics for all stack components.

![Overview](https://user-images.githubusercontent.com/16992394/156664539-cc7e1a69-f1aa-4aca-93f6-7aedaabedd2c.png)
![Moniroting](https://user-images.githubusercontent.com/16992394/156664647-78cfe2af-489d-4c35-8963-9b0a46904cf7.png)

**Architecture Change in ES 9:**

- **ES 8.x and earlier**: Used internal `xpack.monitoring` for self-monitoring
- **ES 9.x**: Uses external Metricbeat collection (more scalable and reliable)

> In Production, cluster metrics should be shipped to another dedicated monitoring cluster.

#### Via Prometheus Exporters

If you started Prometheus Exporters using `mise run elk:monitoring` command. Prometheus Exporters will expose metrics at the following ports.

| **Prometheus Exporter**      | **Port**     | **Recommended Grafana Dashboard**                                         |
|--------------------------    |----------    |------------------------------------------------  |
| `elasticsearch-exporter`     | `9114`       | [Elasticsearch by Kristian Jensen](https://grafana.com/grafana/dashboards/4358)                                                |
| `logstash-exporter`          | `9304`       | [logstash-monitoring by dpavlos](https://github.com/dpavlos/logstash-monitoring)                                               |

**Note:** Elasticsearch Exporter uses updated flags for ES 9 compatibility (`--es.indices` instead of deprecated `--collector.indices`).

![Metrics](https://user-images.githubusercontent.com/16992194/78685076-89a58900-78f1-11ea-959b-ce374fe51500.jpg)

---

## Upgrade Notes from 8.x to 9.x

<details><summary>Expand to see breaking changes and migration details...</summary>
<p>

Elasticsearch 9 introduced several breaking changes. This section documents the changes made to ElastDocker for ES 9 compatibility.

### Breaking Changes Fixed

#### 1. **Logstash Configuration Changes**

**File: `logstash/config/logstash.yml`**

- `http.host` → `api.http.host`

**File: `logstash/pipeline/main.conf`**

- `ssl` → `ssl_enabled`
- `ssl_certificate_verification` → `ssl_verification_mode`
- `cacert` → `ssl_certificate_authorities`

#### 2. **Monitoring Architecture Change**

**Before (ES 8.x):**

- Used internal `xpack.monitoring.collection.enabled` setting
- Components self-reported metrics

**After (ES 9.x):**

- Uses external Metricbeat for metric collection
- More scalable and follows Elastic's recommended approach
- New component: `metricbeat` service in `docker-compose.monitor.yml`

**Files Modified:**

- `elasticsearch/config/elasticsearch.yml` - Removed `xpack.monitoring.collection.enabled`
- `logstash/config/logstash.yml` - Removed `xpack.monitoring` settings
- `apm-server/config/apm-server.yml` - Removed monitoring section
- `metricbeat/config/metricbeat.yml` - **NEW FILE** for Stack Monitoring

#### 3. **Filebeat Migration to Filestream Input**

The `container` input type is deprecated in Filebeat 9. Migrated to the modern `filestream` input with container parser - the ES 9+ recommended approach.

**Files Modified:**

- `filebeat/filebeat.docker.logs.yml` - Now uses `type: filestream` with container parser
- `filebeat/filebeat.monitoring.yml` - All module inputs migrated to filestream

**Key Changes:**

- `type: container` → `type: filestream` with unique IDs
- Added `parsers.container` configuration for Docker log parsing
- Added `prospector.scanner.symlinks: true` for Docker log paths
- No deprecation warnings - fully ES 9 compliant

#### 4. **Certificate Generation Script**

**File: `setup/setup-certs.sh`**

- Updated password generation to work without `openssl` command (not available in ES 9 containers)
- Now uses `/dev/urandom` for random password generation

#### 5. **Elasticsearch Exporter Flags**

**File: `docker-compose.monitor.yml`**

- Updated exporter flags for compatibility with exporter v1.10.0+
- `--collector.indices` → `--es.indices`

### Known Deprecation Warnings

The following deprecation warnings are expected and originate from upstream Elastic components. They will be resolved in future component releases:

1. **Beats using `?local` parameter** (CRITICAL) - ~446 occurrences
   - Source: Metricbeat
   - Will be fixed in future Beats releases
   - **Note:** Filebeat no longer generates these warnings after migrating to filestream input

2. **Behavioral Analytics deprecated** (WARN) - ~37 occurrences
   - Source: Kibana cleanup process
   - Expected during ES 9 migration
   - Will resolve once cleanup completes

3. **APM System Index Access** (WARN) - ~13 occurrences
   - Source: APM Server
   - Will be fixed in future APM Server releases

These warnings don't affect functionality and are logged to the deprecation data stream for visibility.

### Upgrade Path

**Important:** You must upgrade to Elasticsearch 8.19.x before upgrading to 9.x.

**Recommended Path:**

```text
8.17.0 → 8.19.x (run Upgrade Assistant) → 9.x
```

For a clean installation on ES 9, simply:

1. Set `ELK_VERSION=9.4.2` in `.env`
2. Run `mise run elk:setup`
3. Run `mise run elk` (or `mise run elk:all` for full stack with monitoring)

</p>
</details>

---

## Development

The repo uses [**mise**](https://mise.jdx.dev) to run the stack, pin the linters/formatters, and wire git hooks, so everyone lints with the same tool versions as CI. Install it per [Requirements](#requirements).

Set up the toolchain once:

```bash
mise trust      # allow this repo's mise config to load
mise run setup  # check prerequisites, install the pinned tools; git hooks self-install
```

Setup first runs `mise doctor project`, which checks the prerequisites mise can't install (e.g. a running Docker engine) and prints how to fix any that fail. Run it again anytime to diagnose your machine.

Everyday commands:

| Command                            | What it does                                                       |
|------------------------------------|-------------------------------------------------------------------|
| `mise run check` (alias `lint`)    | Run every linter/formatter/validator. Add `--fix` to auto-fix.    |
| `mise tasks`                       | List all tasks (`elk`, `elk:down`, `elk:logs`, …).                |
| `mise run <task> --help`           | Show a task's flags.                                              |

On commit, [hk](https://hk.jdx.dev) formats and lints your staged files; a push runs the slower gates. CI runs both as `mise run check`, so lint problems surface before review. Need to bypass it for a WIP commit? `git commit --no-verify`. Tools and tasks live in `mise.toml`, the hook pipeline in `.config/hk.pkl`.

## License

[MIT License](https://raw.githubusercontent.com/sherifabdlnaby/elastdocker/master/LICENSE)
Copyright (c) 2022-2026 Sherif Abdel-Naby

## Contribution

PR(s) are Open and Welcomed. Run `mise run check` before opening one (see [Development](#development)).
