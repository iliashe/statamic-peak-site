# use php8.2 image
FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    gnupg \
    bash

# install Node.js 20.x LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install PHP extensions
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install ctype
RUN docker-php-ext-install exif
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pdo
RUN docker-php-ext-install xml

# install composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# set working directory
WORKDIR /var/www/html

# Install Statamic CLI globally using Composer
RUN composer global require statamic/cli --no-interaction

# Ensure Composer global bin is in the PATH
ENV PATH="$PATH:/root/.composer/vendor/bin"

EXPOSE 80

# Expose port 80
EXPOSE 80

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]