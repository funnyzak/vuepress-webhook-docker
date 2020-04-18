FROM funnyzak/git-webhook-node-build

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


ENV BUILD_COMMAND npm run build
ENV INSTALL_DEPS_COMMAND npm install
ENV OUTPUT_DIRECTORY .vuepress/dist/
