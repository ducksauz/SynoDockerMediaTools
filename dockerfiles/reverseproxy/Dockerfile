FROM nginx:alpine

RUN apk --no-cache add --update \
	curl \
	openssl \
    && rm -rf /var/cache/apk/*
 
COPY nginx.conf /etc/nginx/nginx.conf
