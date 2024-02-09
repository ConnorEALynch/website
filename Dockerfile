FROM nginx

#move files from repo into container being built
COPY ./html /var/www/html
COPY ./config/www.connorlynch.ca.conf /etc/nginx/conf.d/www.connorlynch.ca.conf 
COPY ./docker-entrypoint.sh /docker-entrypoint.sh 
COPY ./cert /cert

#grant permission to the respective scripts
RUN chmod 755 docker-entrypoint.sh
RUN chmod -R 755 /etc/nginx
RUN chmod -R 755 /cert

#enable ports for http(s) communication
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
