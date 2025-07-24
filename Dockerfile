FROM wordpress:php8.2-apache
EXPOSE 8080
git add Dockerfile
git commit -m "Add Dockerfile for Cloud Build"
git push origin main
