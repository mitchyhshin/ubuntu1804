FROM ubuntu:18.04
LABEL MAINTAINER="yhshin.dev@gmail.com"
LABEL VERSION="0.1"
LABEL DESCRIPTION="This is a custom Docker Image for Ubuntu 18.04"

RUN \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential software-properties-common && \
  apt-get install -y net-tools openssh-server && \
  apt-get install -y iputils-ping vim wget htop nmon sudo git make curl man unzip && \
  rm -rf /var/lib/apt/lists/*
  
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

RUN service ssh start
