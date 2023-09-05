FROM nginx

COPY ./html /var/www/html
COPY ./config/www.connorlynch.ca.conf /etc/nginx/conf.d/www.connorlynch.ca.conf 
# COPY ./config/nginx.conf /etc/nginx/conf.d/nginx.conf 
COPY ./config/docker-entrypoint.sh /docker-entrypoint.sh 
COPY ./config/lego-script.sh /etc/nginx/lego-script.sh

RUN chmod 755 docker-entrypoint.sh
RUN chmod -R 755 /docker-entrypoint.d
RUN chmod 644 /lego-script.sh

EXPOSE 80
EXPOSE 443

RUN apt-get update
RUN apt-get -y install lego
RUN apt-get -y install cron

# RUN crontab -l | { cat; echo "7 */12 * * * bash MODE=renew /etc/nginx/lego-script.sh"; } | crontab -

CMD ["nginx-debug", "-g", "daemon off;"]
