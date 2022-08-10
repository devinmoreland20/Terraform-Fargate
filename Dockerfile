FROM --platform=linux/amd64 ubuntu:latest
RUN apt-get update -y && apt-get install nginx -y
CMD nginx -g 'daemon off;'