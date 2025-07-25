FROM wordpress:php8.2-apache

EXPOSE 8080
ENV PORT=8080
wp theme install astra --activate --path=/var/www/html
define('FS_METHOD', 'direct');
# Set correct ownership first
RUN chown -R www-data:www-data /var/www/html
wp astra-sites import health-wellness --path=/var/www/html

# Use WP-CLI to install plugins and starter templates
RUN su -s /bin/bash www-data -c "\
    wp plugin install woocommerce --activate --path=/var/www/html --allow-root && \
    wp plugin install health-and-fitness --activate --path=/var/www/html --allow-root && \
    wp plugin install astra-sites --activate --path=/var/www/html --allow-root \
"

# Optional: Auto-import Health & Wellness homepage template
# Note: This requires Astra Sites plugin and API fetch via WP-CLI or custom JSON

# Install dependencies and Astra theme
RUN apt-get update && apt-get install -y unzip curl && \
    curl -L https://downloads.wordpress.org/theme/astra.4.6.10.zip -o /tmp/astra.zip && \
    unzip /tmp/astra.zip -d /var/www/html/wp-content/themes && \
    rm /tmp/astra.zip

# Replace default port
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf \
 && sed -i "s/80/${PORT}/" /etc/apache2/sites-available/000-default.conf

# Copy wp-config and install WP-CLI to activate Astra
COPY wp-config.php /var/www/html/wp-config.php
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    wp theme activate astra --path=/var/www/html

CMD ["apache2-foreground"]
