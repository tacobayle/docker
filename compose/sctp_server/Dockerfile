FROM ubuntu:18.04
LABEL maintainer="Nicolas Bayle"

RUN apt update  \
    && apt install -y iproute2 \
    && apt install -y python \
    && apt install -y libsctp-dev \
    && apt install -y python-pip \
    && apt install -y vim \
    && apt install -y tcpdump \
    && apt install -y net-tools \
    && apt install -y iputils-ping \
    && pip install --upgrade pip \
    && pip install pysctp \
    && pip install pysocket \
    && mkdir /sctp

COPY asn_diameter_python-master /sctp

COPY startup_script.sh /sctp/startup_script.sh

CMD ["/bin/bash", "-c", "/sctp/startup_script.sh"]