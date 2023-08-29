FROM nginx

RUN chmod +x docker-entrypoint.sh

COPY ./html /var/www/html
COPY ./config/nginx.conf /etc/nginx/conf.d/nginx.conf 

EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx
