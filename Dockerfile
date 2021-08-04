# FROM alpine:edge
FROM gcr.io/p3marketers-manage/crm-app:crm-app-latest as crm-app
WORKDIR /app
RUN apk add --no-cache jq npm
ARG NPM_AUTH_TOKEN
ENV NPM_AUTH_TOKEN=${NPM_AUTH_TOKEN}

COPY ./package.json .
COPY ./.npmrc .

RUN cat .npmrc
RUN npm i