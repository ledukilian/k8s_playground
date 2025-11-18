FROM nginx:1.27-alpine

COPY app/ /usr/share/nginx/html/

RUN mkdir -p /usr/share/nginx/html/config \
  && echo '{"banner":"local build","apiBaseUrl":"/api","featureFlags":{"enableDebugPanel":true}}' \
     > /usr/share/nginx/html/config/app-config.json

EXPOSE 80

