FROM alpine:3.9

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_VERSION="2.8.0"

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN env && mkdir /ansible && mkdir /ansible-support && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add tar gosu rsync openssh-client python py-pip py-jinja2 py-yaml py-paramiko py-cryptography py-virtualenv && \
  pip --no-cache-dir install --upgrade pip && \
  pip --no-cache-dir install --upgrade docker ansible==${ANSIBLE_VERSION} hvac jmespath && \
  addgroup -S ansible && \
  adduser -S ansible -G ansible && \
  virtualenv --system-site-packages -p /usr/bin/python2.7 /home/ansible/venv && \
  chown -R ansible:ansible /home/ansible/venv && \
  mkdir /home/ansible/.ssh && \
  chown ansible:ansible /home/ansible/.ssh && \
  chmod 0700 /home/ansible/.ssh && \
  ansible --version

COPY ./docker-entrypoint.sh /

WORKDIR /ansible
