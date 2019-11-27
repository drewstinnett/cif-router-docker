FROM python:3.6-alpine
LABEL developer="Wes Young <wes@csirtgadgets.org>"
LABEL docker_maintainer="Drew Stinnett <drew.stinnett@duke.edu>"

EXPOSE 5000

ENV DOCKER_BUILD=yes
ENV CIF_VERSION=3.0.7
ENV SUDO_USER root
ENV LANG=C.UTF-8
ENV CIF_ANSIBLE_ES=localhost:9200

COPY cif-helpers /


RUN apk add --update \
    g++ make git python3-dev shadow libxml2-dev libxslt-dev \
    libffi-dev openssl-dev sqlite && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/cif ; \
    chmod 755 /entrypoint ; \
    mkdir -p /var/lib/cif ; \
    mkdir -p /etc/cif ; \
    useradd cif

RUN cd /tmp && wget https://github.com/csirtgadgets/bearded-avenger/archive/${CIF_VERSION}.tar.gz -O ba.tar.gz && tar -zxf ba.tar.gz  && \
    wget https://github.com/csirtgadgets/bearded-avenger-deploymentkit/archive/${CIF_VERSION}.tar.gz -O dk.tar.gz && tar -zxf dk.tar.gz

WORKDIR /tmp/bearded-avenger-${CIF_VERSION}

RUN pip3 install --upgrade --no-cache-dir pip && \
    pip3 install --no-cache-dir -r ./dev_requirements.txt

RUN CIF_ENABLE_INSTALL=1 python3 setup.py install

WORKDIR /home/cif

COPY setup-cif-env.py /usr/local/bin/setup-cif-env.py
COPY elasticsearch-token-setup.sh /usr/local/bin/elasticsearch-token-setup.sh

ENTRYPOINT ["/entrypoint", "-n"]
