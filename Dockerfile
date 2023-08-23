FROM nginx
COPY /html /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf

RUN apt-get update
RUN apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx

CMD nginx
#ENTRYPOINT ["nginx"]