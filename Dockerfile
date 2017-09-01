FROM frolvlad/alpine-oraclejdk8:8.141.15-slim

ENV SBT_VERSION 1.0.0

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

ENV DOCKER_CHANNEL edge
ENV DOCKER_VERSION 17.07.0-ce

ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /

RUN apk --update --no-cache add py2-pip py-crcmod git tar gzip bash curl sed tzdata ncurses gettext jq && \
  pip install crcmod && \
  curl https://sdk.cloud.google.com | bash && \
  gcloud components update && \
  gcloud components install alpha beta kubectl && \
  curl -q -o - -L https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz \
    | tar xzf - -C /usr/local/lib && \
  rm /usr/local/lib/sbt/bin/sbt.bat && \
  dockerArch=x86_64; \
  if ! curl -fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
    echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
    exit 1; \
  fi; \
  tar -xzf docker.tgz --strip-components 1 -C /usr/local/bin/ && \
  rm docker.tgz && \
  # curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz && \
  # tar --strip-components=1 -xvzf docker-${DOCKER_VERSION}.tgz -C /usr/local/bin && \
  /usr/local/lib/sbt/bin/sbt update # For pre-fetching

ENV PATH $PATH:/usr/local/lib/sbt/bin
ENV HOME /root
