FROM ubuntu:20.04
LABEL maintainer Ed Arnold
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y python3-pip wget libfontconfig

RUN set -xeu \
  \
  && PHANTOM_VERSION="phantomjs-2.1.1" \
  && ARCH=$(uname -m) \
  && PHANTOM_JS="$PHANTOM_VERSION-linux-$ARCH" \
  && wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 \
  && tar xvjf $PHANTOM_JS.tar.bz2 \
  && mv $PHANTOM_JS /usr/local/share \
  && ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
  && rm -f $PHANTOM_JS.tar.bz2

EXPOSE 5000
EXPOSE 8093

RUN mkdir /opt/flaskapp
ADD . /opt/flaskapp/CTF_app_xss1
RUN pip3 install -r /opt/flaskapp/CTF_app_xss1/requirements.txt
RUN mkdir /var/log/flaskapp/

CMD ["/opt/flaskapp/CTF_app_xss1/start.sh"]
