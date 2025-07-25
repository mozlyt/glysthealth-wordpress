# 🏗️ Base WordPress image with Apache and PHP 8.2
FROM wordpress:php8.2-apache

# 📦 Install system dependencies (curl, unzip)
RUN apt-get update && apt-get install -y unzip curl && apt-get clean

# ⚙️ Replace Apache default port with 8080
ENV PORT=8080
EXPOSE 8080
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf && \
    sed -i "s/80/${PORT}/" /etc/apache2/sites-available/000-default.conf

# 🔧 Copy custom wp-config (ensure FS_METHOD is set inside this file)
COPY wp-config.php /var/www/html/wp-config.php

# 🚀 Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# 🎨 Install Astra theme and key plugins using WP-CLI
RUN chown -R www-data:www-data /var/www/html && \
    su -s /bin/bash www-data -c "\
        wp theme install astra --activate --path=/var/www/html && \
        wp plugin install woocommerce --activate --path=/var/www/html && \
        wp plugin install health-and-fitness --activate --path=/var/www/html && \
        wp plugin install astra-sites --activate --path=/var/www/html \
    "

# 🛎️ Start Apache
CMD ["apache2-foreground"]
