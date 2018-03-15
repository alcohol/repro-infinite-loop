FROM php:7.0-fpm-alpine

ARG nr_license_key
ARG nr_app_name=infinite-loop
ARG nr_version=8.0.0.204-linux-musl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Based on https://docs.newrelic.com/docs/agents/php-agent/installation/php-agent-installation-tar-file
RUN curl -sS "http://download.newrelic.com/php_agent/release/newrelic-php5-${nr_version}.tar.gz" | gzip -dc | tar xf - \
 && cd newrelic-php5-${nr_version} \
 && sed -i -e 's/> \${phpi} 2/2/' ./newrelic-install \
 && NR_INSTALL_SILENT=false ./newrelic-install install \
 && printf "\n\nnewrelic.enabled = true\n\
newrelic.framework = symfony2\n\
newrelic.license = $nr_license_key\n\
newrelic.appname = $nr_app_name\n" >> /usr/local/etc/php/conf.d/newrelic.ini \
 && chmod 777 . -R \
 && chmod 777 /var/log/newrelic

WORKDIR /opt/app
