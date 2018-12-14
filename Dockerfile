FROM alpine:3.8

ENV ANSIBLE_HOST_KEY_CHECKING="False"
ENV ANSIBLE_PRIVATE_KEY_FILE="/ansible-support/ssh_key"
ENV ANSIBLE_VERSION="2.7.5"

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN env && mkdir /ansible && mkdir /ansible-support && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add tar gosu rsync openssh-client python py-pip py-jinja2 py-yaml py-paramiko py-cryptography py-virtualenv && \
  pip --no-cache-dir install --upgrade pip && \
  pip --no-cache-dir install --upgrade docker ansible==${ANSIBLE_VERSION} && \
  addgroup -S ansible && \
  adduser -S ansible -G ansible && \
  virtualenv --system-site-packages -p /usr/bin/python2.7 /home/ansible/venv && \
  chown -R ansible:ansible /home/ansible/venv && \
  ansible --version

WORKDIR /ansible
