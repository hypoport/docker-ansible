FROM alpine:3.8

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_SSH_ARGS="-i /ansible-support/ssh_key"
ENV ANSIBLE_VERSION="2.7.5"

RUN env && mkdir /ansible && mkdir /ansible-support && \
  apk --no-cache add tar rsync openssh-client python py-pip py-jinja2 py-yaml py-paramiko py-cryptography && \
  pip --no-cache-dir install --upgrade pip && \
  pip --no-cache-dir install --upgrade docker ansible==${ANSIBLE_VERSION} && \
  ansible --version

WORKDIR /ansible
