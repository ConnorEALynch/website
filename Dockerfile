FROM nginx
COPY /html /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf

RUN  apt-get update \
apt-get install certbot \
apt-get install python3-certbot-nginx

CMD nginx
#ENTRYPOINT ["nginx"]