FROM hashicorp/packer:light

## Set Ansible VARS
ENV USER root
ENV HOME /root/
ENV ANSIBLE_REMOTE_TEMP /tmp/.ansible

# Following is needed for Ansible 2.7.1
RUN apk --no-cache add sudo openssh-client python                  \
    py-pip openssl ca-certificates                              && \
    apk --no-cache add --virtual build-dependencies python-dev     \
    libffi-dev openssl-dev build-base

# Install ansible by standard means if
#RUN apk update                                                 && \
#    apk add --no-cache ansible openssh-client                  && \
#    rm -rf /tmp/*                                              && \
#    rm -rf /var/cache/apk/*

RUN pip install ansible                                         && \
    apk del build-dependencies python-dev libffi-dev               \
    openssl-dev build-base py-pip                               && \
    rm -rf /var/cache/apk/*

# Confirm Ansible installed and working
RUN ansible --version
RUN ansible all -i localhost, -m ping -c local
