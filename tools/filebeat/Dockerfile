ARG ELK_VERSION

FROM docker.elastic.co/beats/filebeat:${ELK_VERSION}

# Add healthcheck
HEALTHCHECK CMD filebeat test config && filebeat test output

# EXPOSE metrics port
EXPOSE 5066