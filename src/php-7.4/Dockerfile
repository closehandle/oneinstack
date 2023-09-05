FROM php:7.4-fpm-alpine

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions apcu-stable
RUN install-php-extensions bcmath-stable
RUN install-php-extensions bz2-stable
RUN install-php-extensions exif-stable
RUN install-php-extensions gd-stable
RUN install-php-extensions gmp-stable
RUN install-php-extensions igbinary-stable
RUN install-php-extensions imagick-stable
RUN install-php-extensions imap-stable
RUN install-php-extensions intl-stable
RUN install-php-extensions ioncube_loader-stable
RUN install-php-extensions ldap-stable
RUN install-php-extensions mysqli-stable
RUN install-php-extensions opcache-stable
RUN install-php-extensions pcntl-stable
RUN install-php-extensions pdo_mysql-stable
RUN install-php-extensions redis-stable
RUN install-php-extensions sockets-stable
RUN install-php-extensions ssh2-stable
RUN install-php-extensions zip-stable

ADD docker.conf /usr/local/etc/php-fpm.d/docker.conf
ADD www.conf    /usr/local/etc/php-fpm.d/www.conf
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/conf.d/php.ini
RUN rm -f /usr/local/etc/php-fpm.d/www.conf.default
RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf
RUN sed -E -i 's|^;date.timezone =.*|date.timezone = Asia/Shanghai|g' /usr/local/etc/php/conf.d/php.ini
RUN sed -E -i 's|^post_max_size = .*|post_max_size = 1024M|g' /usr/local/etc/php/conf.d/php.ini
RUN sed -E -i 's|^upload_max_filesize = .*|upload_max_filesize = 1024M|g' /usr/local/etc/php/conf.d/php.ini
RUN sed -E -i 's|^max_execution_time = .*|max_execution_time = 30|g' /usr/local/etc/php/conf.d/php.ini
RUN sed -E -i 's|^short_open_tag = .*|short_open_tag = On|g' /usr/local/etc/php/conf.d/php.ini
RUN sed -E -i 's|^expose_php = .*|expose_php = Off|g' /usr/local/etc/php/conf.d/php.ini
