#!/bin/bash

COMPOSE_ALL_FILES="-f docker-compose.yml -f docker-compose.monitor.yml -f docker-compose.tools.yml -f docker-compose.nodes.yml -f docker-compose.logs.yml"
COMPOSE_MONITORING="-f docker-compose.yml -f docker-compose.monitor.yml"
COMPOSE_LOGGING="-f docker-compose.yml -f docker-compose.logs.yml"
COMPOSE_TOOLS="-f docker-compose.yml -f docker-compose.tools.yml"
COMPOSE_NODES="-f docker-compose.yml -f docker-compose.nodes.yml"
ELK_SERVICES="elasticsearch logstash kibana apm-server"
ELK_LOG_COLLECTION="filebeat"
ELK_MONITORING="elasticsearch-exporter logstash-exporter filebeat-cluster-logs"
ELK_TOOLS="rubban"
ELK_NODES="elasticsearch-1 elasticsearch-2"
ELK_MAIN_SERVICES="${ELK_SERVICES} ${ELK_MONITORING} ${ELK_TOOLS}"
ELK_ALL_SERVICES="${ELK_MAIN_SERVICES} ${ELK_NODES} ${ELK_LOG_COLLECTION}"

compose_v2_not_supported=$(command docker compose 2> /dev/null)
if [ -z "$compose_v2_not_supported" ]; then
  DOCKER_COMPOSE_COMMAND="docker-compose"
else
  DOCKER_COMPOSE_COMMAND="docker compose"
fi

# Function Definitions
setup() {
    $DOCKER_COMPOSE_COMMAND -f docker-compose.setup.yml run --rm keystore
}

certs() {
    $DOCKER_COMPOSE_COMMAND -f docker-compose.setup.yml run --rm certs
}

keystore() {
    certs
    setup
}

all() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" up -d --build "${ELK_MAIN_SERVICES}"
}

elk() {
    $DOCKER_COMPOSE_COMMAND up -d --build
}

up() {
    elk
    echo "Visit Kibana: https://localhost:5601"
}

monitoring() {
    # shellcheck disable=SC2086
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_MONITORING}" up -d --build ${ELK_MONITORING}
}

collect-docker-logs() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_LOGGING}" up -d --build ${ELK_LOG_COLLECTION}
}

tools() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_TOOLS}" up -d --build ${ELK_TOOLS}
}

nodes() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_NODES}" up -d --build "${ELK_NODES}"
}

build() {
    # shellcheck disable=SC2086
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" build "${ELK_ALL_SERVICES}"
}

ps() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" ps
}

down() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" down
}

stop() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" stop "${ELK_ALL_SERVICES}"
}

restart() {
    # shellcheck disable=SC2086
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" restart "${ELK_ALL_SERVICES}"
}

rm() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" rm -f "${ELK_ALL_SERVICES}"
}

logs() {
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" logs --follow --tail=1000 "${ELK_ALL_SERVICES}"
}

images() {
    # shellcheck disable=SC2086
    $DOCKER_COMPOSE_COMMAND "${COMPOSE_ALL_FILES}" images "${ELK_ALL_SERVICES}"
}

prune() {
    stop
    rm
    docker volume prune -f --filter label=com.docker.compose.project=elastic
}

help() {
    echo "Make Application Docker Images and Containers using Docker-Compose files in 'docker' Dir."
    echo "Usage:"
    echo "  $0 <target> [arguments]"
    echo
    echo "Targets:"
    echo "  setup                  Generate Elasticsearch SSL Certs and Keystore"
    echo "  certs                  Generate Elasticsearch SSL Certs"
    echo "  keystore               Setup Elasticsearch Keystore"
    echo "  all                    Start Elk and all its components (ELK, Monitoring, and Tools)"
    echo "  elk                    Start ELK"
    echo "  up                     Start ELK and show Kibana URL"
    echo "  monitoring             Start ELK Monitoring"
    echo "  collect-docker-logs    Start Filebeat to collect all Host Docker Logs"
    echo "  tools                  Start ELK Tools (ElastAlert, Curator)"
    echo "  nodes                  Start Two Extra Elasticsearch Nodes"
    echo "  build                  Build ELK and all its extra components"
    echo "  ps                     Show all running containers"
    echo "  down                   Down ELK and all its extra components"
    echo "  stop                   Stop ELK and all its extra components"
    echo "  restart                Restart ELK and all its extra components"
    echo "  rm                     Remove ELK and all its extra components containers"
    echo "  logs                   Tail all logs with -n 1000"
    echo "  images                 Show all Images of ELK and all its extra components"
    echo "  prune                  Remove ELK Containers and Delete ELK-related Volume Data"
    echo
    echo "Note: Targets can also be invoked directly as functions, e.g., $0 setup"
    echo
}

# Process command-line arguments
if [ "$#" -eq 0 ]; then
    help
    exit 0
fi

case "$1" in
    "setup")
        setup
        ;;
    "certs")
        certs
        ;;
    "keystore")
        keystore
        ;;
    "all")
        all
        ;;
    "elk")
        elk
        ;;
    "up")
        up
        ;;
    "monitoring")
        monitoring
        ;;
    "collect-docker-logs")
        collect-docker-logs
        ;;
    "tools")
        tools
        ;;
    "nodes")
        nodes
        ;;
    "build")
        build
        ;;
    "ps")
        ps
        ;;
    "down")
        down
        ;;
    "stop")
        stop
        ;;
    "restart")
        restart
        ;;
    "rm")
        rm
        ;;
    "logs")
        logs
        ;;
    "images")
        images
        ;;
    "prune")
        prune
        ;;
    "help")
        help
        ;;
    *)
        echo "Invalid target. Run '$0 help' for a list of available targets."
        exit 1
        ;;
esac

exit 0
