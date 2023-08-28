FROM nginx

#RUN rm /etc/nginx/conf.d/default.conf
COPY ./html /var/www/html
COPY ./config/nginx.conf /etc/nginx/conf.d/nginx.conf 
#COPY ./config/default /etc/nginx/sites-available/default

EXPOSE 80
EXPOSE 443
RUN apt-get update
RUN apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx
