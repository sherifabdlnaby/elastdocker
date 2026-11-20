ARG ELK_VERSION

# https://github.com/elastic/kibana-docker
FROM docker.elastic.co/kibana/kibana:${ELK_VERSION}

# Install the OS security fixes Elastic's image does not ship yet (UBI packages).
USER 0
RUN microdnf upgrade -y --refresh --nodocs --setopt=install_weak_deps=0 && microdnf clean all
USER 1000

ARG ELK_VERSION

# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>
