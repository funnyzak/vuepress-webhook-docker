FROM alpine:latest

LABEL maintainer="potato<silenceace@gmail.com>" \
        org.label-schema.name="webhook"

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
