FROM alpine:3.7

RUN set -x ; \
  addgroup -g 1000 -S media ; \
adduser -u 1000 -D -S -G  media media  && exit 0 ; exit 1

RUN apk -U upgrade 
RUN apk add --no-cache ca-certificates openssl xz tar sqlite sqlite-libs gcc g++ git make unrar wget unzip curl tzdata libmms zlib zlib-dev 

ENV MONO_VERSION=5.4.1.7-2

RUN wget https://archive.archlinux.org/packages/m/mono/mono-$MONO_VERSION-x86_64.pkg.tar.xz
RUN tar -xJf /mono-$MONO_VERSION-x86_64.pkg.tar.xz &&  mozroots --import --ask-remove

