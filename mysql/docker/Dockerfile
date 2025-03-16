# base official mysql image
FROM mysql:8.0

# install socat
RUN microdnf install -y socat && \
microdnf clean all

COPY start-with-wrap.sh /start-with-wrap.sh
RUN chmod +x /start-with-wrap.sh

# overwrite entrypoint
ENTRYPOINT ["/start-with-wrap.sh"]

EXPOSE 3306 10088
