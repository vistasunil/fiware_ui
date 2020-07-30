ARG  NODE_MAJOR_VERSION=10
ARG  NODE_VERSION=10.17.0-slim

FROM node:${NODE_VERSION} AS build-env

RUN mkdir -p /usr/src/app/node_modules && chown -R node:node /usr/src/app

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

USER node

RUN npm install

COPY --chown=node:node . .

#EXPOSE 8080

CMD [ "npm", "start" ]
