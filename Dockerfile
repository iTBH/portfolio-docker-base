FROM php:fpm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-transport-https gnupg libreoffice-writer pdftk imagemagick ghostscript zip unzip git libjpeg-dev libpng-dev libfreetype6-dev libmcrypt-dev libxml2-dev libopencv-dev ffmpeg \
	&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
	&& curl -sL https://deb.nodesource.com/setup_8.x | bash - \
	&& apt-get install -y --no-install-recommends nodejs yarn \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) pdo_mysql gd opcache \
	&& rm -rf /var/lib/apt/lists/*


# Install composer
RUN curl -o /usr/local/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/local/bin/composer && composer global require hirak/prestissimo

# Install caddy webserver
RUN curl https://getcaddy.com | bash -s personal

RUN yarn global add webpack cross-env laravel-mix gulp

RUN echo "post_max_size=1G" > /usr/local/etc/php/php.ini \
    && echo "upload_max_filesize=1G" >> /usr/local/etc/php/php.ini \
    && echo "max_file_uploads=100" >> /usr/local/etc/php/php.ini \
    && echo "session.gc_maxlifetime=9999" >> /usr/local/etc/php/php.ini \
    && echo "session.cache-expire=9999" >> /usr/local/etc/php/php.ini \
    && echo "session.cookie-lifetime=9999" >> /usr/local/etc/php/php.ini