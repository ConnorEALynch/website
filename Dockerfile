FROM nginx

RUN chmod 777 docker-entrypoint.sh
RUN chmod -R 777 /docker-entrypoint.d

RUN rm /etc/nginx/conf.d/default.conf
COPY ./html /var/www/html
COPY ./config/nginx.conf /etc/nginx/conf.d/nginx.conf 
COPY ./config/docker-entrypoint.sh /docker-entrypoint.sh 

EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx


CMD ["nginx", "-g", "daemon off;"]
