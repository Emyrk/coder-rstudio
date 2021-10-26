# Dockerfile
FROM codercom/enterprise-base:ubuntu

USER root
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
    curl \
    vim \
    r-base \
    gdebi-core \
    wget \
    gettext-base

RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.0-351-amd64.deb && \
    gdebi --non-interactive rstudio-server-2021.09.0-351-amd64.deb

# @emyrk: Not sure why I need this, but I get a database error if I do not include this
RUN chown -R coder:coder /var/lib/rstudio-server

# Make directory for rstudio data in home dir
RUN mkdir /home/coder/.rstudio && chown -R coder:coder /home/coder/.rstudio
# Set up rstudio config to work for the coder user
RUN echo "server-pid-file=/tmp/rstudio-server.pid" >> /etc/rstudio/rserver.conf
RUN echo "www-frame-origin=same" >> /etc/rstudio/rserver.conf
# Run rstudio data in user home directory as coder user
RUN echo "server-user=coder" >> /etc/rstudio/rserver.conf
RUN echo "server-data-dir=/home/coder/.rstudio/data" >> /etc/rstudio/rserver.conf
RUN echo "database-config-file=/etc/rstudio/database.conf" >> /etc/rstudio/rserver.conf
# Database conf
RUN echo "provider=sqlite" >> /etc/rstudio/database.conf
RUN echo "directory=/home/coder/.rstudio" >> /etc/rstudio/database.conf
# Launcher config -- Use TLS
# If your coder deployment is NOT on tls, you will want to remove this line.
RUN echo "enable-ssl=1" >> /etc/rstudio/launcher.conf

# Make generic apps directory and give access for coder user to modify
RUN mkdir -p /coder/apps
RUN chown -R coder:coder /coder/apps
ENV CODER_WORKSPACE_ID TEST

COPY ["rstudio-config.yaml", "/tmp/rstudio-config.yaml"]
COPY ["configure", "/coder/configure"]

USER coder