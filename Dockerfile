FROM golang

LABEL maintainer="potato" \
        org.label-schema.name="vuepress-web"

ENV LANG=C.UTF-8

# Install needed modules
RUN apt-get update
RUN apt-get install -y git ssh bash rsync

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get update && apt-get install -y nodejs

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
