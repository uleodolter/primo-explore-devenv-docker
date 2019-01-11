FROM node:boron-alpine

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
LABEL org.label-schema.build-date="$BUILD_DATE" \
org.label-schema.name="primo-explore-devenv" \
org.label-schema.description="Primo New UI Customization Docker Development Environment" \
org.label-schema.vcs-ref="$VCS_REF" \
org.label-schema.vcs-url="$VCS_URL" \
org.label-schema.vendor="OBVSG" \
org.label-schema.version="$VERSION" \
org.label-schema.schema-version="1.0"

ENV NPM_CONFIG_LOGLEVEL info
ENV PROXY "http://search.obvsg.at:80"
ENV VIEW TML
ENV GULP_OPTIONS ""

# Update and install tools
RUN apk upgrade --update  \
 && apk add \
    libc6-compat \
    bash \
    vim \
    git \
    su-exec \
    gzip \
    tar \
    curl \
 && rm -fr /var/cache/apk/* \
 && rm -fr /tmp/* \
 && rm -rf /var/log/*

# Install primo-exlpore-devenv
RUN npm install -g gulp
WORKDIR /app
# RUN git clone https://github.com/ExLibrisGroup/primo-explore-devenv.git
RUN git clone https://github.com/uleodolter/primo-explore-devenv.git \
 && git clone https://github.com/ExLibrisGroup/primo-explore-package.git \
 && mv ./primo-explore-package/VIEW_CODE ./primo-explore-devenv/primo-explore/custom/TML \
 && rm -rf primo-explore-package
WORKDIR /app/primo-explore-devenv
RUN npm install && npm cache clean --force

EXPOSE 8003
EXPOSE 3001

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "/bin/bash", "-c", "gulp run --view $VIEW --proxy $PROXY $GULP_OPTIONS" ]
