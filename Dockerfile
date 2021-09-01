FROM alpine:3.12

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_VERSION="2.9.24"

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN env && mkdir /ansible && mkdir /ansible-support && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add gosu && \
  apk --no-cache add tar rsync openssh-client python3 py3-pip py3-jinja2 py3-yaml py3-paramiko py3-cryptography py3-virtualenv aws-cli && \
  pip3 --no-cache-dir install --upgrade pip && \
  pip3 --no-cache-dir install --upgrade docker ansible==${ANSIBLE_VERSION} hvac jmespath && \
  addgroup -S ansible && \
  adduser -S ansible -G ansible && \
  virtualenv --system-site-packages -p /usr/bin/python3 /home/ansible/venv && \
  chown -R ansible:ansible /home/ansible/venv && \
  mkdir /home/ansible/.ssh && \
  chown ansible:ansible /home/ansible/.ssh && \
  chmod 0700 /home/ansible/.ssh && \
  ansible --version

COPY ./docker-entrypoint.sh /

WORKDIR /ansible
