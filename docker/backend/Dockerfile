FROM php:8.4-fpm

# install dependencies
RUN apt-get update && apt-get install -y \
  curl \
  git \
  zip \
  unzip \
  libpng-dev \
  libzip-dev \
  default-mysql-client

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
  mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Create a writable directory in /tmp and symlink it to /.symfony5
RUN mkdir -p /tmp/symfony && \
  ln -s /tmp/symfony /.symfony

# Set environment variable to point to the new writable directory
ENV SYMFONY_CLI_HOME=/tmp/symfony

# install php extensions
RUN docker-php-ext-install pdo pdo_mysql zip gd

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# ________________________________________________________________________________
# SETTING USER ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# --------------------------------------------------------------------------------

# Create a non-root user with a specific UID and GID to match your local user
ARG USERNAME=symfony

ARG GROUP=symfony

# Replace with your local group ID, or use an ARG to pass it in build time
ARG UID=1000

# Replace with your local group ID, or use an ARG to pass it in build time
ARG GID=1000

# Create the non-root user and group
RUN groupadd -g ${GID} ${GROUP}
RUN useradd -u ${UID} -g ${GROUP} -m ${USERNAME}

# Set the ownership of the /var/www directory to the non-root user
RUN chown -R ${UID}:${GID} /var/www

# Switch to the non-root user
USER ${UID}
