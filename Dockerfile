FROM alpine:edge
WORKDIR /app
RUN apk add --no-cache jq npm

COPY ./package.json .

RUN npm i