FROM mikefarah/yq:2.1.2 as yq

ARG CLI
FROM circleci/circleci-cli:${CLI}-alpine as cli

ARG ALPINE
FROM gofunky/git:${ALPINE}-envload
LABEL maintainer="mat@fax.fyi"

COPY --from=yq /usr/bin/yq /usr/local/bin/yq
RUN chmod +x /usr/local/bin/yq

COPY --from=cli /usr/local/bin/circleci /usr/local/bin/circleci
RUN chmod +x /usr/local/bin/circleci

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/gofunky/orbtools" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENTRYPOINT ["circleci"]
