FROM balenalib/raspberry-pi-alpine-node:10

RUN mkdir /opt/bot
WORKDIR /opt/bot

ADD bot/package.json /opt/bot/package.json
RUN npm install --production

RUN apk add --update redis && rm -rf /var/cache/apk/*

RUN mkdir /data

ADD bot /opt/bot
ADD redis.conf /opt/bot/redis.conf

CMD redis-server redis.conf && ./bin/hubot
