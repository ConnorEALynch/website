FROM nginx
COPY /html /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf

RUN  apt-get update
RUN apt-get install certbot 
RUN apt-get install python3-certbot-nginx

CMD nginx
#ENTRYPOINT ["nginx"]