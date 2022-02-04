FROM node:14 AS development
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install \
    && npm install pm2 -g