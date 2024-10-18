FROM alpine:3.20.0
LABEL maintainer="Nicolas Bayle"

RUN apk add bash \
    && apk add curl \
    && apk add python3 \
    && apk add git \
    && apk add py3-pip \
    && mkdir /build

COPY build /build

ENTRYPOINT ["/bin/bash", "/build/apply.sh"]