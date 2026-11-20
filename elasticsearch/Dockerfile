ARG ELK_VERSION

# https://github.com/elastic/elasticsearch-docker
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_VERSION}

# Install the OS security fixes Elastic's image does not ship yet (UBI packages).
USER 0
RUN microdnf upgrade -y --refresh --nodocs --setopt=install_weak_deps=0 && microdnf clean all
USER 1000:0

# Add healthcheck
WORKDIR /usr/share/elasticsearch
COPY scripts/docker-healthcheck .
HEALTHCHECK CMD ["sh", "./docker-healthcheck"]

# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu
#RUN elasticsearch-plugin install --batch repository-s3
