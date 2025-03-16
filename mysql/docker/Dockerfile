# base official mysql image
FROM mysql:8.0

# install socat
RUN microdnf install -y socat && \
microdnf clean all

COPY start-with-wrap.sh /start-with-wrap.sh
RUN chmod +x /start-with-wrap.sh
COPY custom.cnf /etc/mysql/conf.d/

# overwrite entrypoint
ENTRYPOINT ["/start-with-wrap.sh"]
#ENTRYPOINT ["/bin/sh", "-c", "sleep 3600" ]

EXPOSE 3306 10088
