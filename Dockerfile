FROM resin/raspberry-pi-alpine-node:6-slim

RUN mkdir /opt/bot
#    && chown -R node /opt/bot

#ENV HUBOT_VERSION 2.18.0

#USER node
WORKDIR /opt/bot

ADD bot /opt/bot

RUN npm install --production

CMD ["./bin/hubot", "--adapter", "hipchat"]
