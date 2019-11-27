FROM python:3.6-alpine
LABEL developer="Wes Young <wes@csirtgadgets.org>"
LABEL docker_maintainer="Drew Stinnett <drew.stinnett@duke.edu>"


ENV DOCKER_BUILD=yes
ENV CIF_VERSION=3.0.7
ENV LANG=C.UTF-8
ENV CIF_ANSIBLE_ES=localhost:9200
ENV CIF_ENABLE_INSTALL=1
ENV ARCHIVE_URL=https://github.com/csirtgadgets/bearded-avenger/archive

EXPOSE 5000

COPY cif-helpers /cif-helpers

RUN apk add --update \
    git shadow sqlite g++ make python3-dev shadow libxml2-dev libxslt-dev \
    libffi-dev openssl-dev wget && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/log/cif && \
    mkdir -p /var/lib/cif && \
    mkdir -p /etc/cif && \
    useradd -m -s /bin/bash cif && \
    touch /home/cif/.profile && \
    chown -R cif /home/cif && \
    cd /tmp && \
    wget --quiet ${ARCHIVE_URL}/${CIF_VERSION}.tar.gz -O ba.tar.gz && \
    tar -zxf ba.tar.gz  && \
    cd /tmp/bearded-avenger-${CIF_VERSION} && \
    pip3 install --upgrade --no-cache-dir pip && \
    pip3 install --no-cache-dir -r ./dev_requirements.txt && \
    python3 setup.py install

WORKDIR /home/cif

USER cif
RUN ls /cif-helpers
ENTRYPOINT ["/cif-helpers/entrypoint"]
