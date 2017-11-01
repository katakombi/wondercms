FROM debian:stable

LABEL maintainer="Stefan Kombrink <stefan.kombrink@gmail.com>"

RUN set -x \
	&& apt-get update \
	&& apt-get install -y vim php-fpm php7.0-fpm php-mbstring php-zip php-curl nginx \
	&& apt-get clean 

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY wondercms/cfg/default /etc/nginx/sites-enabled/default
COPY wondercms/cfg/nginx.conf /etc/nginx/nginx.conf
COPY wondercms/cfg/fastcgi.conf /etc/nginx/fastcgi.conf
COPY wondercms/cfg/php.ini /etc/php/7.0/fpm/php.ini
COPY wondercms/cfg/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
COPY wondercms/cfg/www.conf /etc/php/7.0/fpm/pool.d/www.conf

EXPOSE 8080

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
