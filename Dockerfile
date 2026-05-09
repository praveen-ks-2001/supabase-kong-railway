FROM kong/kong:3.9.1

USER root

COPY kong.yml /home/kong/temp.yml
COPY kong-entrypoint.sh /home/kong/kong-entrypoint.sh

RUN chmod +x /home/kong/kong-entrypoint.sh && \
    chown kong:kong /home/kong/temp.yml /home/kong/kong-entrypoint.sh

USER kong

ENV KONG_DATABASE=off \
    KONG_DECLARATIVE_CONFIG=/tmp/kong.yml \
    KONG_DNS_ORDER=LAST,A,CNAME \
    KONG_PLUGINS=request-transformer,cors,key-auth,acl,basic-auth,request-termination,ip-restriction,post-function \
    KONG_NGINX_PROXY_PROXY_BUFFER_SIZE=160k \
    KONG_NGINX_PROXY_PROXY_BUFFERS=64\ 160k

EXPOSE 8000 8443

HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD kong health || exit 1

ENTRYPOINT ["/home/kong/kong-entrypoint.sh"]
