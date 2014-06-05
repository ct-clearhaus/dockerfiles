FROM debian:wheezy
MAINTAINER Casper Thomsen, ct@clearhaus.com

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade --yes
RUN apt-get install --yes procps nmap openssh-client
ENV DEBIAN_FRONTEND dialog

ADD forwarder.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/forwarder.sh

CMD /usr/local/bin/forwarder.sh
