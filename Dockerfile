FROM wordpress:php8.2-apache

EXPOSE 8080
ENV PORT=8080

# Install dependencies
RUN apt-get update && apt-get install -y unzip curl && apt-get clean

# Replace Apache default port
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf && \
    sed -i "s/80/${PORT}/" /etc/apache2/sites-available/000-default.conf

# Copy wp-config with FS_METHOD (FS_METHOD should be inside this file)
COPY wp-config.php /var/www/html/wp-config.php

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Set ownership and install theme + plugins
RUN chown -R www-data:www-data /var/www/html && \
    su -s /bin/bash www-data -c "\
        wp theme install astra --activate --path=/var/www/html && \
        wp plugin install woocommerce --activate --path=/var/www/html && \
        wp plugin install health-and-fitness --activate --path=/var/www/html && \
        wp plugin install astra-sites --activate --path=/var/www/html \
    "

CMD ["apache2-foreground"]
