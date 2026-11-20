ARG ELK_VERSION

# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash:${ELK_VERSION}

# Install the OS security fixes Elastic's image does not ship yet (UBI packages).
USER 0
RUN microdnf upgrade -y --refresh --nodocs --setopt=install_weak_deps=0 && microdnf clean all
USER 1000

HEALTHCHECK --interval=240s --timeout=120s --retries=5 \
  CMD ["curl", "-s", "-XGET", "http://127.0.0.1:9600"]

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
