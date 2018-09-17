FROM ubuntu:16.04
LABEL maintainer Ed Arnold
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y python-pip sqlite3 lib32z1-dev python-dev libxml2-dev libxslt-dev libffi-dev libssl-dev libfontconfig git wget

RUN apt-get install build-essential chrpath libssl-dev libxft-dev -y \
      && apt-get install libfreetype6 libfreetype6-dev -y \
      && apt-get install libfontconfig1 libfontconfig1-dev -y

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
RUN pip install -r /opt/flaskapp/CTF_app_xss1/requirements.txt
RUN mkdir /var/log/flaskapp/

CMD ["/opt/flaskapp/CTF_app_xss1/start.sh"]
