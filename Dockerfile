ARG ALPINE
ARG CLI

FROM mikefarah/yq:3.3.2 as yq
FROM gofunky/envtpl:0.2.1 as envtpl
FROM circleci/circleci-cli:${CLI}-alpine as cli

FROM gofunky/git:alpine${ALPINE}-envload
LABEL maintainer="mat@fax.fyi"

COPY --from=yq /usr/bin/yq /usr/local/bin/yq
RUN chmod +x /usr/local/bin/yq

COPY --from=envtpl /usr/local/bin/envtpl /usr/local/bin/envtpl
RUN chmod +x /usr/local/bin/envtpl

COPY --from=cli /usr/local/bin/circleci /usr/local/bin/circleci
RUN chmod +x /usr/local/bin/circleci

RUN apk add --no-cache docker

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/gofunky/orbtools" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENTRYPOINT ["circleci"]
