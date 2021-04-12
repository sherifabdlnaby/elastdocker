.DEFAULT_GOAL:=help

COMPOSE_ALL_FILES := -f docker-compose.yml -f docker-compose.monitor.yml -f docker-compose.tools.yml -f docker-compose.nodes.yml
COMPOSE_MONITORING := -f docker-compose.yml -f docker-compose.monitor.yml
COMPOSE_TOOLS := -f docker-compose.yml -f docker-compose.tools.yml
COMPOSE_NODES := -f docker-compose.yml -f docker-compose.nodes.yml
ELK_SERVICES   := elasticsearch logstash kibana
ELK_MONITORING := elasticsearch-exporter logstash-exporter filebeat-cluster-logs
ELK_TOOLS  := curator elastalert rubban
ELK_NODES := elasticsearch-1 elasticsearch-2
ELK_MAIN_SERVICES := ${ELK_SERVICES} ${ELK_MONITORING} ${ELK_TOOLS}
ELK_ALL_SERVICES := ${ELK_MAIN_SERVICES} ${ELK_NODES}
# --------------------------

# load .env so that Docker Swarm Commands has .env values too. (https://github.com/moby/moby/issues/29133)
include .env
export

# --------------------------
.PHONY: setup keystore certs all elk monitoring tools build down stop restart rm logs

keystore:		## Setup Elasticsearch Keystore, by initializing passwords, and add credentials defined in `keystore.sh`.
	docker-compose -f docker-compose.setup.yml run --rm keystore

certs:		    ## Generate Elasticsearch SSL Certs.
	docker-compose -f docker-compose.setup.yml run --rm certs

setup:		    ## Generate Elasticsearch SSL Certs and Keystore.
	@make certs
	@make keystore

all:		    ## Start Elk and all its component (ELK, Monitoring, and Tools).
	docker-compose ${COMPOSE_ALL_FILES} up -d --build ${ELK_MAIN_SERVICES}

elk:		    ## Start ELK.
	docker-compose up -d --build

up:
	@make elk

monitoring:		## Start ELK Monitoring.
	@docker-compose ${COMPOSE_MONITORING} up -d --build ${ELK_MONITORING}

tools:		    ## Start ELK Tools (ElastAlert, Curator).
	@docker-compose ${COMPOSE_TOOLS} up -d --build ${ELK_TOOLS}

nodes:		    ## Start Two Extra Elasticsearch Nodes
	@docker-compose ${COMPOSE_NODES} up -d --build ${ELK_NODES}

build:			## Build ELK and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} build ${ELK_ALL_SERVICES}

down:			## Down ELK and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} down

stop:			## Stop ELK and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} stop ${ELK_ALL_SERVICES}
	
restart:		## Restart ELK and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} restart ${ELK_ALL_SERVICES}

rm:				## Remove ELK and all its extra components containers.
	@docker-compose $(COMPOSE_ALL_FILES) rm -f ${ELK_ALL_SERVICES}

logs:			## Tail all logs with -n 1000.
	@docker-compose $(COMPOSE_ALL_FILES) logs --follow --tail=1000 ${ELK_ALL_SERVICES}

images:			## Show all Images of ELK and all its extra components.
	@docker-compose $(COMPOSE_ALL_FILES) images ${ELK_ALL_SERVICES}

prune:			## Remove ELK Containers and Delete Volume Data
	@make swarm-rm || echo ""
	@make stop && make rm
	@docker volume prune -f

swarm-deploy-elk:
	@make build
	docker stack deploy -c docker-compose.yml elastic

swarm-deploy-monitoring:
	@make build
	@docker stack deploy -c docker-compose.yml -c docker-compose.monitor.yml elastic

swarm-deploy-tools:
	@make build
	@docker stack deploy -c docker-compose.yml -c docker-compose.tools.yml elastic

swarm-rm:
	docker stack rm elastic


help:       	## Show this help.
	@echo "Make Application Docker Images and Containers using Docker-Compose files in 'docker' Dir."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m (default: help)\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
