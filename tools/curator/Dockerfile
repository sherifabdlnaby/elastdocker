FROM alpine:3.8

ARG CURATOR_VERSION=5.8.3
ENV CURATOR_VERSION=$CURATOR_VERSION

RUN apk add --no-cache tini python py-pip                   \
  && pip install elasticsearch-curator==${CURATOR_VERSION}  \
  && pip install -U pyyaml==3.12

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT ["entrypoint"]
