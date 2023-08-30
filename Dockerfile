FROM nginx

RUN chmod 777 docker-entrypoint.sh
RUN chmod -R 777 /docker-entrypoint.d

COPY ./html /var/www/html
COPY ./config/nginx.conf /etc/nginx/conf.d/nginx.conf 

EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx
