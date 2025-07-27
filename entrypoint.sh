#!/bin/bash
set -e

# 🔧 Fix file permissions for WordPress
chown -R www-data:www-data /var/www/html

# 📦 Install any missing dependencies (optional)
# apt-get update && apt-get install -y curl unzip

# 🧙‍♂️ Run WP-CLI commands if wp-cli is available
if command -v wp &> /dev/null; then
  echo "✅ WP-CLI detected, running setup..."
  wp plugin update --all --allow-root
  wp theme activate astra --allow-root
  wp option update blogname "Glyst Health" --allow-root
else
  echo "⚠️ WP-CLI not found. Skipping WordPress customization."
fi

# 🚀 Start Apache or PHP-FPM (adjust based on your base image)
exec "$@"
