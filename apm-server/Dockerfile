ARG ELK_VERSION

# https://github.com/elastic/apm-server
FROM docker.elastic.co/apm/apm-server:${ELK_VERSION}
ARG ELK_VERSION

USER root
RUN apt-get -qq update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER apm-server
