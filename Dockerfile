FROM wordpress:php8.2-apache
EXPOSE 8080
ENV PORT=8080
RUN sed -i "s/80/\${PORT}/" /etc/apache2/ports.conf \
 && sed -i "s/80/\${PORT}/" /etc/apache2/sites-available/000-default.conf
CMD ["apache2-foreground"]
