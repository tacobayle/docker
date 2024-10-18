FROM ubuntu:22.04
LABEL maintainer="Nicolas Bayle"

RUN apt update  \
    && apt install -y jq \
    && apt install -y curl \
    && apt install -y vim \
    && apt install -y git \
    && apt install -y tcpdump \
    && apt install -y net-tools \
    && apt install -y iputils-ping \
    && apt install -y iproute2 \
    && apt install -y genisoimage \
    && apt install -y xorriso \
    && apt install -y python3 \
    && apt install -y python3-pip \
    && apt install -y gnupg software-properties-common \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt update \
    && apt install terraform \
    && curl -L -o - "https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | tar -C /usr/local/bin -xvzf - govc \
    && pip3 install ansible-core==2.12.5 \
    && pip3 install ansible==5.7.1 \
    && pip3 install pyvmomi \
    && pip3 install avisdk \
    && pip3 install requests \
    && pip3 install jmespath \
    && pip3 install dnspython \
    && ansible-galaxy collection install git+https://github.com/vmware/ansible-for-nsxt.git,master \
    && ansible-galaxy collection install vmware.alb \
    && mkdir /build

COPY build /build