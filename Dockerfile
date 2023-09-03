FROM nginx

COPY ./html /var/www/html
COPY ./config/www.connorlynch.ca.conf /etc/nginx/conf.d/www.connorlynch.ca.conf 
# COPY ./config/nginx.conf /etc/nginx/conf.d/nginx.conf 
COPY ./config/docker-entrypoint.sh /docker-entrypoint.sh 

RUN chmod 777 docker-entrypoint.sh
RUN chmod -R 777 /docker-entrypoint.d

EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get -y install lego

CMD ["nginx-debug", "-g", "daemon off;"]
