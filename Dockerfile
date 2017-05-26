FROM python:2.7-slim
MAINTAINER Luis Muniz <luis.muniz@b2boost.com>

# Yay devcron
RUN pip install https://bitbucket.org/dbenamy/devcron/get/tip.tar.gz

# Setup defaults
ADD cron /cron
ADD scripts /scripts
ADD util /util

VOLUME ["/cron"]

CMD ["devcron.py", "/cron/crontab"]
