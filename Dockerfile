FROM balenalib/raspberry-pi-alpine-node:10

RUN mkdir /opt/bot
WORKDIR /opt/bot

ADD bot /opt/bot

RUN npm install --production

RUN apk add --update redis && rm -rf /var/cache/apk/*

ADD redis.conf /opt/bot/redis.conf

RUN mkdir /data

CMD redis-server redis.conf && ./bin/hubot
