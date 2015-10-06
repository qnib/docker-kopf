FROM qnib/nginx

# kopf
ENV KOPF_VERSION 1.5.7
RUN curl -s -L "https://github.com/lmenezes/elasticsearch-kopf/archive/v${KOPF_VERSION}.tar.gz" | tar xz -C /tmp && mv "/tmp/elasticsearch-kopf-${KOPF_VERSION}" /opt/kopf

# nginx
ADD etc/consul-templates/nginx.conf.ctmpl /etc/consul-templates/
ADD etc/supervisord.d/kopf_update.ini /etc/supervisord.d/
