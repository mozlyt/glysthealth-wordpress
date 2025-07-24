
FROM wordpress:php8.2-apache

EXPOSE 8080
ENV PORT=8080

# Install dependencies and Astra theme
RUN apt-get update && apt-get install -y unzip curl && \
    curl -L https://downloads.wordpress.org/theme/astra.4.6.10.zip -o /tmp/astra.zip && \
    unzip /tmp/astra.zip -d /var/www/html/wp-content/themes && \
    rm /tmp/astra.zip

# Replace default port
RUN sed -i "s/80/${PORT}/" /etc/apache2/ports.conf \
 && sed -i "s/80/${PORT}/" /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]
