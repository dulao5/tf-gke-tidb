# base official mysql image
FROM --platform=$TARGETPLATFORM gcr.io/pingcap-public/dbaas/tidb:v8.5.0

# install socat
RUN yum install -y socat && \
    yum clean all

COPY start-with-wrap.sh /start-with-wrap.sh
RUN chmod +x /start-with-wrap.sh

# overwrite entrypoint
ENTRYPOINT ["/start-with-wrap.sh"]

EXPOSE 4000 10080 10088
