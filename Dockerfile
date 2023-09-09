FROM nginx

#move files from repo into container being built
COPY ./html /var/www/html
COPY ./config/www.connorlynch.ca.conf /etc/nginx/conf.d/www.connorlynch.ca.conf 
COPY ./config/docker-entrypoint.sh /docker-entrypoint.sh 
COPY ./config/lego-script.sh /etc/nginx/lego-script.sh

#grant permission to the respective scripts
RUN chmod 755 docker-entrypoint.sh
RUN chmod -R 755 /docker-entrypoint.d
RUN chmod 755 /etc/nginx/lego-script.sh

#enable ports for http(s) communication
EXPOSE 80
EXPOSE 443

#get package updates for image and install needed software
RUN apt-get update
RUN apt-get -y install lego
#RUN apt-get -y install cron

#RUN crontab -l | { cat; echo "7 */12 * * * bash MODE=renew /etc/nginx/lego-script.sh"; } | crontab -

ENTRYPOINT ["/docker-entrypoint.sh"]