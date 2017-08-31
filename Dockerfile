FROM frolvlad/alpine-oraclejdk8:8.141.15-slim

ENV SBT_VERSION 1.0.0-RC2

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

ENV DOCKER_VERSION 17.05.0-ce

ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /

RUN apk --update --no-cache add py2-pip py-crcmod git tar gzip bash curl sed tzdata ncurses gettext jq && \
  pip install crcmod && \
  curl https://sdk.cloud.google.com | bash && \
  gcloud components update && \
  gcloud components install app alpha beta kubectl && \
  curl -q -o - -L https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz \
    | tar xzf - -C /usr/local/lib && \
  rm /usr/local/lib/sbt/bin/sbt.bat && \
  curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz && \
  tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin && \
  /usr/local/lib/sbt/bin/sbt update # For pre-fetching

ENV PATH $PATH:/usr/local/lib/sbt/bin
ENV HOME /root
