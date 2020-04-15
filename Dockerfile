FROM alpine:latest

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="VuepressWebhook" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="Pull your vuepress project Git code into a data volume and trigger automatic packaging via Webhook." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.schema-version="1.0"	\
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/vuepress-webhook-docker" 

ENV LANG=C.UTF-8

# Install needed modules
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh go rsync npm yarn && \
    rm  -rf /tmp/* /var/cache/apk/*

# Go config
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# nodejs
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.11/main/ nodejs=12.15.0-r1

# Install webhook
RUN mkdir -p /app/hook \
    && go get github.com/adnanh/webhook

# Copy our Scripts
COPY hooks.json /app/hook/hooks.json
COPY webhook.sh /app/hook/webhook.sh
COPY entrypoint.sh /app/hook/entrypoint.sh


# Add permissions to our scripts
RUN chmod +x /app/hook/webhook.sh

# Expose Webhook port
EXPOSE 9000

# run start script
ENTRYPOINT ["sh", "/app/hook/entrypoint.sh"]
