FROM node:lts-alpine as builder

RUN apk add --no-cache git python3 build-base

# Create app directory
WORKDIR /opt/app

# Install app dependencies
COPY tsconfig.json package.json package-lock.json* /opt/app/
COPY src /opt/app/src
RUN npm install
# Build the app
RUN npm run build


FROM node:lts-alpine
RUN apk add --no-cache git python3 g++ make
WORKDIR /opt/app


COPY package.json package-lock.json* /opt/app/
RUN npm ci --production
COPY --from=builder /opt/app/dist .

# EXPOSE 3000
CMD [ "node", "index.js" ]