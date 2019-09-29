<p align="center">
<img width="520px" src="https://user-images.githubusercontent.com/16992394/65820321-a87ee080-e227-11e9-9c61-8cf60357a034.png">
</p>
<h2 align="center">🐳 Pre-configured Elastic Stack on Docker, for single node, single host deployments.
<h4 align="center">Comes with Prometheus Metrics Exporters, Elastic Stack Monitoring and Tools preconfigured.</h4>
</h2>
<p align="center">A Composition</p>
<p align="center">
	<a>
		<img src="https://img.shields.io/github/v/tag/sherifabdlnaby/elastdocker?label=release&amp;sort=semver">
    </a>
	<a>
		<img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat" alt="contributions welcome">
	</a>
	<a>
		<img src="https://img.shields.io/badge/Elastic%20Stack-7%5E-blue?style=flat&logo=elasticsearch" alt="Elastic Stack Version 7^^">
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

sudo sysctl -w vm.max_map_count=262144

# Introduction
**Docker Image for Symfony 4.3+ Application** running on **Nginx + PHP_FPM** based on [PHP Official Image](https://hub.docker.com/_/php).
This image should be used as a **base** image for your Symfony Project, **and you shall extend and edit it according to your app needs.**
The Image utilizes docker's multistage builds to create multiple targets optimized for **production** and **development**.


You should copy this repository`Dockerfile`, `docker` Directory, `Makefile`, and `.dockerignore` to your Symfony application repository and configure it to your needs.

### Main Points 📜

- **Production Image is a fully contained Image with source code and dependencies inside**, Development image is set up for mounting source code on runtime with hot-reload.

- Image configuration is transparent, you can view and modify any of the configurations that determine the behavior of the application.

- Nginx **HTTP**, **HTTPS**, and **HTTP2** are pre-configured, for **HTTPS** it uses self-signed certificate generated at build-time. For production you'll need to mount your own signed certificates to `/etc/nginx/ssl` amd overwrite defaults.

- Image tries to fail at build time as much as possible by running all sort of Checks.

- Dockerfile is arranged for optimize builds, so that changed won't invalidate cache as much as possible.

### Image Targets

| **Target**   	| **Description**                                                                                    	|  **Size** 	|          **Stdout**          	|             **Targets**            	|
|--------------	|----------------------------------------------------------------------------------------------------	|--------------	|:----------------------------:	|:-----------------------------------:	|
| `nginx`      	| The Webserver, serves static content and replay others requests `php-fpm`                          	| 21 MB        	| Nginx Access and Error logs. 	|      `nginx-prod`, `nginx-dev`      	|
| `fpm`        	| PHP_FPM, which will actually run the PHP Scripts for web requests.                                 	| 78 MB        	|  PHP Application logs only.  	|        `fpm-prod`, `fpm-dev`        	|
| `supervisor` 	| Contains supervisor and source-code, for your consumers. (config at `docker/conf/supervisor/`)    	| 120 MB       	|    Stdout of all Commands.   	|           `supervisor-prod`           |
| `cron`       	| Loads crontab and your app source-code, for your cron commands. (config at `docker/conf/crontab`) 	| 78 MB        	|     Stdout of all Crons.     	|              `cron-prod`            	|

> All Images are **Alpine** based.  Official PHP-Alpine-Cli image size is 79.4MB. 

> Size stated above are calculated excluding source code and vendor directory. 

-----

# Requirements 

- [Docker 17.05 or higher](https://docs.docker.com/install/) 
- [Docker-Compose 3.4 or higher](https://docs.docker.com/compose/install/) (optional) 
- Symfony 4+ Application
- PHP >= 7 Application

# Setup

### Get Template
#### 1. Generate Repo from this Template

1. Download This Repository
2. Copy `Dockerfile`, `docker` Directory, `Makefile`, and `.dockerignore` Into your Symfony Application Repository.
3. Modify `Dockerfile` to your app needs, and add your app needed PHP Extensions and Required Packages.
4. Situational:
    - If you will use `Makefile` and `Docker-Compose`: go to `docker/.composer/.env` and modify `SERVER_NAME` to your app's name.
    - If you will expose SSL port to Production: Mount your signed certificates `server.crt` & `server.key` to `/etc/nginx/ssl`.
      Also make sure `SERVER_NAME` build ARG matches Certificate's **Common Name**.
5. run `make up` for development or `make deploy` for production. 

OR

<a href="https://github.com/sherifabdlnaby/elastdocker/generate">
<img src="https://user-images.githubusercontent.com/16992394/65464461-20c95880-de5a-11e9-9bf0-fc79d125b99e.png" alt="create repository from template"></a>

<p> <small>And start from step 3..</small> </p>

      
# Building Image

1. The image is to be used as a base for your Symfony application image, you should modify its Dockerfile to your needs.

2. The image come with a handy _Makefile_ to build the image using Docker-Compose files, it's handy when manually building the image for development or in a not-orchestrated docker hosts.
However in an environment where CI/CD pipelines will build the image, they will need to supply some build-time arguments for the image. (tho defaults exist.)

### Build Time Arguments
| **ARG**            | **Description**                                                                                                                                      | **Default** |
|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| `PHP_VERSION`      | PHP Version used in the Image                                                                                                                        | `7.3.9`     |
| `ALPINE_VERSION`   | Alpine Version                                                                                                                                       | `3.10`      |
| `NGINX_VERSION`    | Nginx Version                                                                                                                                        | `1.17.4`    |
| `COMPOSER_VERSION` | Composer Version used in Image                                                                                                                       | `1.9.0`     |
| `SERVER_NAME`      | Server Name</br> (In production, and using SSL, this must match certificate's *common name*)                                                              | `php-app`   |
| `COMPOSER_AUTH`    | A Json Object with Bitbucket or Github token to clone private Repos with composer.</br>[Reference](https://getcomposer.org/doc/03-cli.md#composer-auth) | `{}`        | 

### Runtime Environment Variables
| **ENV**     | **Description** | **Default**                                                 |
|-------------|-----------------|-------------------------------------------------------------|
| `APP_ENV`   | App Environment | - `prod` for Production image</br> - `dev` for Development image     |
| `APP_DEBUG` | Enable Debug    | - `0` for Production image</br>- `1` for Development image           |

## Tips for building Image in different environments

### Production
1. For SSL: Mount your signed certificates as secrets to `/etc/nginx/ssl/server.key` & `/etc/nginx/ssl/server.crt`
2. Make sure build argument `SERVER_NAME` matches certificate's **common name**.
2. Expose container port `80` and `443`.

> By default, Image has a generated self-signed certificate for SSL connections added at build time.
### Development
1. Mount source code root to `/var/www/app`
2. Expose container port `8080` and `443`. (or whatever you need actually)

----


# Configuration

## 1. PHP Extensions, Dependencies, and Configuration

### Modify PHP Configuration
1. PHP `prod` Configuration  `docker/conf/php/php-prod.ini`[🔗](https://github.com/sherifabdlnaby/elastdocker/blob/master/docker/conf/php/php-prod.ini) 
2. PHP `dev` Configuration  `docker/conf/php/php-dev.ini`[🔗](https://github.com/sherifabdlnaby/elastdocker/blob/master/docker/conf/php/php-dev.ini) 
3. PHP additional [Symfony recommended configuration](https://symfony.com/doc/current/performance.html#configure-opcache-for-maximum-performance) at `docker/conf/php/symfony.ini` [🔗](https://github.com/sherifabdlnaby/elastdocker/blob/master/docker/conf/php/symfony.ini) 

### Add Packages needed for PHP runtime
Add Packages needed for PHP runtime in this section of the `Dockerfile`.
```Dockerfile
...
# ------------------------------------- Install Packages Needed Inside Base Image --------------------------------------
RUN apk add --no-cache		\
#    # - Please define package version too ---
#    # -----  Needed for Image----------------
	fcgi tini \
#    # -----  Needed for PHP -----------------
    <HERE>
...
``` 

### Add & Enable PHP Extensions
Add PHP Extensions using `docker-php-ext-install <extensions...>` or `pecl install <extensions...>`  and Enable them by `docker-php-ext-enable <extensions...>`
in this section of the `Dockerfile`.
```Dockerfile
...
# --------------------- Install / Enable PHP Extensions ------------------------
RUN docker-php-ext-install opcache && pecl install memcached && docker-php-ext-enable memcached
...
```

##### Note

> At build time, Image will run `composer check-platform-reqs` to check that PHP and extensions versions match the platform requirements of the installed packages.

## 2. Nginx Configuration

Nginx defaults are all defined in `docker/conf/nginx/` [🔗](https://github.com/sherifabdlnaby/elastdocker/blob/master/docker/conf/nginx/)

Nginx is pre-configured with:
1. HTTP, HTTPS, and HTTP2.
2. Rate limit (`rate=5r/s`)
3. Access & Error logs to `stdout/err`
4. Recommended Security Headers
5. Serving Static content with default cache `7d`
6. Metrics endpoint at `:8080/stub_status` from localhost only.

##### Note

> At build time, Image will run `nginx -t` to check config file syntax is OK.

## 3. Post Deployment Custom Scripts

Post Installation scripts should be configured in `composer.json` in the `post-install-cmd` [part](https://getcomposer.org/doc/articles/scripts.md#command-events).

However, Sometimes, some packages has commands that need to be run on startup, that are not compatible with composer, provided in the image a shell script `post-deployment.sh`[🔗](https://github.com/sherifabdlnaby/elastdocker/blob/master/docker/post-deployment.sh) that will be executed after deployment. 
Special about this file that it comes loaded with all OS Environment variables **as well as defaults from `.env` and `.env.${APP_ENV}` files.** so it won't need a special treatment handling parameters.

> It is still discouraged to be used if it's possible to run these commands using composer scripts.

## 3. Supervisor Consumers

If you have consumers (e.g rabbitMq or Kafka consumers) that need to be run under supervisor, you can define these at `docker/conf/supervisor/*`, which will run by the `supervisor` image target.

## 4. Cron Commands

If you have cron jobs, you can define them in `docker/conf/crontab`, which will run by the `cron` image target.

--------

# Misc Notes
- Your application [should log app logs to stdout.](https://stackoverflow.com/questions/38499825/symfony-logs-to-stdout-inside-docker-container). Read about [12factor/logs](https://12factor.net/logs) 
- By default, `php-fpm` access & error logs are disabled as they're mirrored on `nginx`, this is so that `php-fpm` image will contains **only** application logs written by PHP.
- During Build, Image will run `composer dump-autoload` and `composer dump-env` to optimize for performance.
- In **production**, Image contains source-code, however you must sync both `php-fpm` and `nginx` images so that they contain the same code.

# License 
[MIT License](https://raw.githubusercontent.com/sherifabdlnaby/elastdocker/blob/master/LICENSE)
Copyright (c) 2019 Sherif Abdel-Naby

# Contribution

PR(s) are Open and welcomed.

This image has so little to do with Symfony itself and more with Setting up a PHP Website with Nginx and FPM, hence it can be extended for other PHP Frameworks (e.g Laravel, etc). maybe if you're interested to build a similar image for another framework we can collaborate. 

### Possible Ideas

- [x] Add a slim image with supervisor for running consumers.
- [x] Add a slim image with cron tab for cron job instances.
- [ ] Add node build stage that compiles javascript.
- [ ] Recreate the image for Symfony 3^
- [ ] Recreate the image for Laravel
