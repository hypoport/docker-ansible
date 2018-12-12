FROM alpine:3.8

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_SSH_ARGS="-i /ansible-support/ssh_key"
ENV ANSIBLE_VERSION="2.5.13"

RUN env && mkdir /ansible && mkdir /ansible-support && \
  apk --no-cache add tar openssh-client python py-pip py-yaml py-jinja2 py-httplib2 py-paramiko py-six rsync libssl1.0 && \
  apk --no-cache add --virtual build-deps build-base openssl-dev python-dev libffi-dev pkgconf && \
  pip --no-cache-dir install --upgrade pip && \
  pip --no-cache-dir install --upgrade setuptools docker && \
  pip --no-cache-dir install --upgrade ansible==${ANSIBLE_VERSION} && \
  apk del build-deps && \
  ansible --version

WORKDIR /ansible
