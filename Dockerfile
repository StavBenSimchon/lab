FROM alpine:edge
WORKDIR /app
RUN apk add --no-cache jq npm
ARG NPM_AUTH_TOKEN
ENV NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}

COPY ./package.json .
COPY ./.npmrc .

RUN cat .npmrc
RUN npm i