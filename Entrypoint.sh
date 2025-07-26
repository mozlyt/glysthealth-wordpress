#!/bin/bash
# 🏗️ Install Astra theme and key plugins using WP-CLI
su -s /bin/bash www-data -c "\
    wp theme install astra --activate --path=/var/www/html && \
    wp plugin install woocommerce health-and-fitness astra-sites --activate --path=/var/www/html \
"
exec apache2-foreground
