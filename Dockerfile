FROM node:6.2.0

RUN mkdir /opt/bot \
    && useradd -ms /bin/bash node \
    && chown -R node /opt/bot

ENV HUBOT_VERSION 2.18.0

USER node
WORKDIR /opt/bot

ADD bot /opt/bot

RUN npm install --production

CMD ["./bin/hubot", "--adapter", "hipchat"]
