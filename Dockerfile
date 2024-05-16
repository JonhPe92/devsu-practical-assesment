# syntax=docker/dockerfile:1


ARG NODE_VERSION=20.11.0

FROM node:${NODE_VERSION}-alpine


WORKDIR /home/node/devsu-app

COPY package*.json ./

# Use production node environment by default.
ENV NODE_ENV production

#Default envar for port, this can be overrided via ConfigMap
ENV PORT 8000 

RUN npm install

# Copy the rest of the source files into the image.
COPY . .

# Run the application as a non-root user.
USER node

# Expose the port that the application listens on.
EXPOSE ${PORT}

# Run the application.
CMD npm start
