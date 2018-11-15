ARG ALPINE
ARG CLI
FROM mikefarah/yq:2.1.2 as yq

FROM circleci/circleci-cli:${CLI}-alpine as cli

FROM gofunky/git:alpine${ALPINE}-envload
LABEL maintainer="mat@fax.fyi"

COPY --from=yq /usr/bin/yq /usr/local/bin/yq
RUN chmod +x /usr/local/bin/yq

COPY --from=cli /usr/local/bin/circleci /usr/local/bin/circleci
RUN chmod +x /usr/local/bin/circleci

RUN wget -O /usr/local/bin/templater https://raw.githubusercontent.com/johanhaleby/bash-templater/master/templater.sh
RUN chmod +x /usr/local/bin/templater

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/gofunky/orbtools" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENTRYPOINT ["circleci"]
