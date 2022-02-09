FROM golang:1.15.3-alpine as ssm-builder

ARG VERSION=1.2.295.0

RUN set -ex && apk add --no-cache make git gcc libc-dev curl bash zip && \
    curl -sLO https://github.com/aws/session-manager-plugin/archive/${VERSION}.tar.gz && \
    mkdir -p /go/src/github.com && \
    tar xzf ${VERSION}.tar.gz && \
    mv session-manager-plugin-${VERSION} /go/src/github.com/session-manager-plugin && \
    cd /go/src/github.com/session-manager-plugin && \
    make release




FROM python:3.9-slim

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_VERSION="4.5.0"

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN mkdir /ansible && mkdir /ansible-support && \
  pip3 --no-cache-dir install --upgrade pip && \
  pip3 --no-cache-dir install --upgrade docker ansible==${ANSIBLE_VERSION} hvac jmespath boto3 awscli && \
  apt update && apt -y install gosu tar rsync openssh-client curl && rm -rf /var/lib/apt/lists/* && \
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
  dpkg -i session-manager-plugin.deb && \
  rm session-manager-plugin.deb && \
  groupadd --system ansible && useradd --system -g ansible ansible && \
  python3 -m venv --system-site-packages /home/ansible/venv && \
  chown -R ansible:ansible /home/ansible/venv && \
  mkdir /home/ansible/.ssh && \
  chown ansible:ansible /home/ansible/.ssh && \
  chmod 0700 /home/ansible/.ssh && \
  ansible --version

COPY ./docker-entrypoint.sh /
COPY --from=ssm-builder /go/src/github.com/session-manager-plugin/bin/linux_amd64_plugin/session-manager-plugin /usr/local/bin/

WORKDIR /ansible
