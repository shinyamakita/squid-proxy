FROM ubuntu/squid:4.10-20.04_beta

RUN apt-get update && apt-get install -y \
   # openssl \
   # squid-openssl \
   sudo \
   && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /etc/squid/ssl_cert /var/spool/squid /etc/squid/ssl_db /var/run/squid \
    && chown -R proxy:proxy /etc/squid/ssl_cert /var/spool/squid /etc/squid/ssl_db /var/run/squid \
    && chmod 750 /var/spool/squid \
    && chmod 700 /etc/squid/ssl_db

# Copy certificates
COPY ./certs/squidCA.pem /etc/squid/ssl_cert/
COPY ./certs/squidCA.key /etc/squid/ssl_cert/
COPY ./certs/server.crt /etc/squid/ssl_cert/
COPY ./certs/server.key /etc/squid/ssl_cert/
RUN chmod 600 /etc/squid/ssl_cert/squidCA.key \
   && chmod 600 /etc/squid/ssl_cert/server.key \
   && chown -R proxy:proxy /etc/squid/ssl_cert/

# pid file
RUN mkdir -p /var/run/squid \
   && chown proxy:proxy /var/run/squid \
   && chmod 755 /var/run/squid

# Copy configuration file
COPY ./proxy/squid.conf /etc/squid/squid.conf

# Copy start script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3128
# ENV HOSTNAME=proxy.local
USER proxy
ENTRYPOINT ["/entrypoint.sh"]