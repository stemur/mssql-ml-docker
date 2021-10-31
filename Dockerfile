FROM ubuntu:18.04

# Supervisord conf file
COPY ./supervisord.conf /usr/local/etc/supervisord.conf

# Install Packages
RUN apt-get update
RUN apt-get install -y apt-transport-https curl supervisor fakechroot locales iptables \
                        sudo wget zip unzip make bzip2 m4 tzdata libnuma-dev \
                        libsss-nss-idmap-dev software-properties-common

# Custom Microsoft Repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list > /etc/apt/sources.list.d/mssql-server-2019.list

# Install SQL Server Machine Learnng for R and Python
RUN apt-get update && \
    apt-get install -y mssql-mlservices-packages-r \
                        mssql-mlservices-packages-py 

# cleanup of the docker files
RUN apt-get clean
RUN rm -rf /var/apt/cache/* /tmp/* /var/tmp/* /var/lib/apt/lists

# run checkinstallextensibility.sh
RUN /opt/mssql/bin/checkinstallextensibility.sh && \
    # set/fix directory permissions and create default directories
    chown -R root:root /opt/mssql/bin/launchpadd && \
    chown -R root:root /opt/mssql/bin/setnetbr && \
    mkdir -p /var/opt/mssql-extensibility/data && \
    mkdir -p /var/opt/mssql-extensibility/log && \
    chown -R root:root /var/opt/mssql-extensibility && \
    chmod -R 777 /var/opt/mssql-extensibility && \
    # locale-gen
    locale-gen en_US.UTF-8

# expose SQL Server port
EXPOSE 1433:1433

# start services with supervisord
CMD /usr/bin/supervisord -n -c /usr/local/etc/supervisord.conf
