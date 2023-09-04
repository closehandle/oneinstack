FROM nginx:alpine

ADD ffdhe2048.txt /etc/nginx
ADD fastcgi.conf  /etc/nginx
ADD nginx.conf    /etc/nginx
ADD vhost.conf    /etc/nginx
ADD rewrite       /etc/nginx/rewrite
ADD ssl           /etc/nginx/ssl
ADD default.crt   /etc/nginx/ssl/default.crt
ADD default.key   /etc/nginx/ssl/default.key

RUN rm -fr /etc/nginx/conf.d
RUN rm -fr /etc/nginx/modules
RUN rm -f  /etc/nginx/*_params
