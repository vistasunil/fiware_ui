ARG  NODE_MAJOR_VERSION=10
ARG  NODE_VERSION=10.17.0-slim

FROM node:${NODE_VERSION} AS build-env

RUN mkdir -p /usr/src/app/node_modules && chown -R node:node /usr/src/app

RUN apt-get update && apt-get -y install cron

# Copy hello-cron file to the cron.d directory
COPY cron-file /etc/cron.d/cron-file

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron-file

# Apply cron job
RUN crontab /etc/cron.d/cron-file

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

#RUN chmod 777 /usr/sbin/cron

# Run the command on container startup
#CMD cron && tail -f /var/log/cron.log

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

#USER node

RUN npm install

#COPY --chown=node:node . .
COPY . .
#EXPOSE 8080

#CMD [ "sh", "-c", "npm start &&  /usr/sbin/cron -f" ]
CMD cron && npm start 
#/usr/src/app/fetch.sh && npm start
