FROM sdhibit/alpine-runit:3.6

# Add Testing Repository
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install apk packages
RUN apk --update upgrade \
 && apk --no-cache add \
  ca-certificates \
  libmediainfo@testing \
  mono@testing \
  sqlite \
  tar \
  unrar

# Set Sonarr Package Information
ENV PKG_NAME NzbDrone
ENV PKG_VER 2.0
ENV PKG_BUILD 0.5228
ENV APP_BASEURL https://update.sonarr.tv/v2/master/mono
ENV APP_PKGNAME ${PKG_NAME}.master.${PKG_VER}.${PKG_BUILD}.mono.tar.gz
ENV APP_URL ${APP_BASEURL}/${APP_PKGNAME}
ENV APP_PATH /opt/sonarr

# Download & Install Sonarr
RUN mkdir -p ${APP_PATH} \
 && curl -kL ${APP_URL} | tar -xz -C ${APP_PATH} --strip-components=1 

# Create user and change ownership
RUN mkdir /config \
 && addgroup -g 1000 -S media \
 && adduser -u 1000 -SHG media media \
 && chown -R media:media \
    ${APP_PATH} \
    "/media-apps/data/sonarr"

VOLUME ["/media-apps/data/sonarr"]

# Default Sonarr server ports
EXPOSE 8989
EXPOSE 9898

WORKDIR ${APP_PATH}

# Add services to runit
ADD sonarr.sh /etc/service/sonarr/run
RUN chmod +x /etc/service/*/run
