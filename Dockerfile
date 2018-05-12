FROM node:boron

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
org.label-schema.name="primo-explore-devenv" \
org.label-schema.description="Primo New UI Customization Docker Development Environment" \
org.label-schema.vcs-ref=$VCS_REF \
org.label-schema.vcs-url="https://gitlab.obvsg.at/Primo/Frontend/primo-explore-devenv-docker" \
org.label-schema.vendor="OBVSG" \
org.label-schema.version=$VERSION \
org.label-schema.schema-version="1.0"

ENV NPM_CONFIG_LOGLEVEL info
ENV PROXY "https://search-test.obvsg.at"
ENV VIEW TEST
ENV GULP_OPTIONS ""

RUN npm install -g gulp
USER node
WORKDIR /home/node
# RUN git clone https://github.com/ExLibrisGroup/primo-explore-devenv.git
RUN git clone https://github.com/uleodolter/primo-explore-devenv.git
WORKDIR /home/node/primo-explore-devenv/primo-explore/custom
RUN git clone https://github.com/ExLibrisGroup/primo-explore-package.git
RUN mv primo-explore-package/VIEW_CODE ./TEST
RUN rm -rf primo-explore-package
WORKDIR /home/node/primo-explore-devenv
RUN npm install
RUN npm rebuild node-sass

EXPOSE 8003
EXPOSE 3001

CMD [ "/bin/bash", "-c", "gulp run --view $VIEW --proxy $PROXY $GULP_OPTIONS" ]
