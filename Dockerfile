FROM golang:1.14-alpine

ENV DEX_VERSION v2.26.0

RUN \
     apk add --no-cache --update alpine-sdk && \
     git clone -b ${DEX_VERSION} https://github.com/dexidp/dex && \
     cd dex && make

FROM alpine:3.12

RUN apk add --update ca-certificates openssl

USER 1000:0

COPY --from=0 /go/dex/bin/dex /usr/bin/dex
COPY --from=0 /go/dex/web /usr/share/dex/web

WORKDIR /usr/share/dex

ENTRYPOINT ["dex"]

CMD ["version"]
