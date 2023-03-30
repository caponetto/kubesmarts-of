FROM --platform=linux/amd64 registry.access.redhat.com/ubi8/ubi-minimal:8.5

RUN microdnf --disableplugin=subscription-manager -y install httpd \
  && microdnf --disableplugin=subscription-manager clean all \
  && sed -i -e 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf \
  && sed -i -e 's/#ServerName www.example.com:80/ServerName 127.0.0.1:8080/' /etc/httpd/conf/httpd.conf \
  && echo 'Header set Cache-Control "max-age=3600, public"' >> /etc/httpd/conf/httpd.conf \
  && chgrp -R 0 /var/log/httpd /var/run/httpd /var/www/html \
  && chmod -R g=u /var/log/httpd /var/run/httpd /var/www/html

COPY . /var/www/html

EXPOSE 8080

ENTRYPOINT ["httpd", "-D", "FOREGROUND"]