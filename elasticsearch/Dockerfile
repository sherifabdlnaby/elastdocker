ARG ELK_VERSION

# https://github.com/elastic/elasticsearch-docker
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_VERSION}

# Add healthcheck
COPY scripts/docker-healthcheck .
HEALTHCHECK CMD sh ./docker-healthcheck

# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu
#RUN elasticsearch-plugin install --batch repository-s3
