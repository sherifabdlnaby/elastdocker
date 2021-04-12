ARG ELK_VERSION

# https://github.com/elastic/kibana-docker
FROM docker.elastic.co/kibana/kibana:${ELK_VERSION}
ARG ELK_VERSION

## Add healthcheck
#COPY scripts/docker-healthcheck .
#HEALTHCHECK CMD sh ./docker-healthcheck

# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>
#RUN kibana-plugin install https://github.com/bitsensor/elastalert-kibana-plugin/releases/download/1.1.0/elastalert-kibana-plugin-1.1.0-${ELK_VERSION}.zip