FROM nginx

#move files from repo into container being built
COPY ./html /var/www/html
COPY ./config/www.connorlynch.ca.conf /etc/nginx/conf.d/www.connorlynch.ca.conf 
COPY ./config/_.connorlynch.ca.conf /etc/nginx/conf.d/_.connorlynch.ca.conf  
COPY ./cert /cert
COPY ./static ./app/staticfiles
#grant permission to the respective scripts
RUN chmod -R 755 /etc/nginx
RUN chmod -R 755 /cert

#enable ports for http(s) communication
EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]