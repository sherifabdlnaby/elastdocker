ARG ELK_VERSION

# https://github.com/elastic/kibana-docker
FROM docker.elastic.co/kibana/kibana:${ELK_VERSION}
ARG ELK_VERSION

USER root
RUN apt-get -qq update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER kibana

# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>