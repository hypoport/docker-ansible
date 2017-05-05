FROM alpine:3.4

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_SSH_ARGS="-i /ansible-support/ssh_key"
ENV ANSIBLE_VERSION="2.2.0.0"

RUN env && mkdir /ansible{,-support} && apk update && \
  apk add tar openssh-client python py-pip py-yaml py-jinja2 py-httplib2 py-paramiko py-six rsync && \
  apk add --virtual build-deps build-base openssl-dev python-dev libffi-dev pkgconf && \
  pip install --upgrade pip && \
  pip install --upgrade setuptools && \
  pip install --upgrade ansible==${ANSIBLE_VERSION} && \
  apk del build-deps && \
  ansible --version

WORKDIR /ansible
