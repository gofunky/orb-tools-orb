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

ARG ENVTPL
RUN apk add --no-cache --virtual .build-deps gnupg \
    && wget -O /usr/local/bin/envtpl "https://github.com/mattrobenolt/envtpl/releases/download/$ENVTPL/envtpl-linux-amd64" \
    && wget -O /usr/local/bin/envtpl.asc "https://github.com/mattrobenolt/envtpl/releases/download/$ENVTPL/envtpl-linux-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys D8749766A66DD714236A932C3B2D400CE5BBCA60 \
    && gpg --batch --verify /usr/local/bin/envtpl.asc /usr/local/bin/envtpl \
    && rm -r "$GNUPGHOME" /usr/local/bin/envtpl.asc \
    && chmod +x /usr/local/bin/envtpl \
    && apk del .build-deps

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/gofunky/orbtools" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENTRYPOINT ["circleci"]
