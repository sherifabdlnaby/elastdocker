ARG ELK_VERSION

# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash:${ELK_VERSION}

HEALTHCHECK --interval=240s --timeout=120s --retries=5 \
  CMD curl -s -XGET 'http://127.0.0.1:9600'

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
