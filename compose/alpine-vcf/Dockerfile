FROM alpine:3.20.0
LABEL maintainer="Nicolas Bayle"

RUN apk add bash \
    && apk add jq \
    && apk add curl \
    && apk add openssh \
    && apk add expect \
    && apk add xorriso \
    && apk add git \
    && curl -L -o - "https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | tar -C /usr/local/bin -xvzf - govc \
    && apk add python3 \
    && apk add py3-pip \
    && pip3 install kubernetes --break-system-packages \
    && pip3 install kopf --break-system-packages \
    && mkdir /build

COPY build /build

ENTRYPOINT ["/bin/bash", "/build/apply.sh"]