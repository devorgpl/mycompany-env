FROM staticfloat/nginx-certbot
RUN mkdir -p /etc/nginx/user.conf.d
COPY ./mycompany-app.conf /etc/nginx/user.conf.d/
COPY ./mycompany-admin.conf_rename /etc/nginx/user.conf.d/

