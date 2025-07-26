# 🏗️ Base WordPress image with Apache and PHP 8.2
FROM wordpress:php8.2-apache

# 📦 Install system dependencies
RUN apt-get update && apt-get install -y unzip curl && apt-get clean

# ⚙️ Replace Apache default port with 8080
ENV PORT=8080
EXPOSE 8080
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf && \
    sed -i "s/80/${PORT}/" /etc/apache2/sites-available/000-default.conf

# 🛎️ Add custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 🎨 Mount plugins directory for Cloud volume flexibility
VOLUME /var/www/html/wp-content/plugins

# 🚀 Start Apache via entrypoint
ENTRYPOINT ["/entrypoint.sh"]
