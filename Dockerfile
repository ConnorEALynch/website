FROM nginx

#RUN rm /etc/nginx/conf.d/default.conf
COPY ./html/index.html /usr/share/nginx/html/index.html
COPY ./config/domain-name.conf /etc/nginx/conf.d/domain-name.conf 
#COPY ./config/default /etc/nginx/sites-available/default

EXPOSE 80/tcp

RUN apt-get update
RUN apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx

RUN chmod +x docker-entrypoint.sh