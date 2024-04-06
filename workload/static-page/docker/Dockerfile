# docker build -t example/static-page:v0000 .
# kind --name=k8s-in-docker load docker-image example/static-page:v0000
FROM nginx:1.25.4-alpine-slim

COPY src/index.html /usr/share/nginx/html/index.html
COPY src/assets/styles.css /usr/share/nginx/html/assets/styles.css
COPY src/assets/favicon.png /usr/share/nginx/html/assets/favicon.png


# vim: ts=2 sw=2 et:


