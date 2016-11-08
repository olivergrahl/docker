# Zammad ticketing system docker image
FROM centos:6
MAINTAINER Thorsten Eckel <thorsten.eckel@znuny.com>

# Expose ports
EXPOSE 80 3000 6042 9200

# Add repository contents into docker images
ADD repos/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
ADD repos/zammad.repo /etc/yum.repos.d/zammad.repo
ADD repos/nginx.repo /etc/yum.repos.d/nginx.repo

# Install prerequisites
RUN \
    rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch && \
    rpm --import https://rpm.packager.io/key && \
    \
    yum -y install epel-release && \
    yum -y install postfix elasticsearch java cronie nginx zammad && \
    \
    /usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-mapper-attachments/2.5.0

# Configure
RUN \
    usermod -d /opt/zammad zammad && \
    \
    rm -rf /etc/nginx/conf.d/* && \
    sed -i.bak '/server_name\syour\.domain\.org;/d' /opt/zammad/contrib/nginx/sites-enabled/zammad.conf && \
    cp /opt/zammad/contrib/nginx/sites-enabled/zammad.conf /etc/nginx/conf.d/

# Copy scripts
ADD scripts/run.sh /run.sh
ADD scripts/setup_db.sh /setup_db.sh

RUN \
    chmod 744 /*.sh && \
    chown zammad:zammad /setup_db.sh

# Define environment variables for DB connection
ENV \
    DB_ADAPTER=mysql2 \
    DB_DATABASE=zammad \
    DB_USERNAME=zammad \
    DB_PASSWORD="" \
    DB_HOST=mysql \
    DB_PORT=3306

WORKDIR "/opt/zammad"

CMD ["/bin/bash", "/run.sh"]
