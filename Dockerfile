FROM frolvlad/alpine-glibc:alpine-3.7

ENV MEDIAINFO_VERSION='0.7.91'

RUN apk -U upgrade && \
    apk add --no-cache \
      ca-certificates \
      openssl \
      xz \
      tar \
      sqlite \
      sqlite-libs \
      gcc g++ git make \
      unrar \
      wget \
      unzip \
      curl \
      tzdata \
      libmms \
      zlib zlib-dev && \
\
    export MONO_VERSION=4.8.0.495-1 && \
    wget https://archive.archlinux.org/packages/m/mono/mono-$MONO_VERSION-x86_64.pkg.tar.xz && \
    tar -xJf /mono-$MONO_VERSION-x86_64.pkg.tar.xz && \
    mozroots --import --ask-remove && \
\
    wget "https://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VERSION}/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" \
        -O "/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
    wget "https://mediaarea.net/download/binary/libmediainfo0/${MEDIAINFO_VERSION}/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" \
        -O "/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
    tar -xf "/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
    tar -xf "/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" && \
\
    cd /MediaInfo_CLI_GNU_FromSource && \
      ./CLI_Compile.sh && \
    cd /MediaInfo_CLI_GNU_FromSource/MediaInfo/Project/GNU/CLI/ && \
      make install && \
\
    cd /MediaInfo_DLL_GNU_FromSource && \
      ./SO_Compile.sh && \
    cd /MediaInfo_DLL_GNU_FromSource/MediaInfoLib/Project/GNU/Library && \
      make install && \
    cd /MediaInfo_DLL_GNU_FromSource/ZenLib/Project/GNU/Library && \
      make install && \
\
    adduser -u 1000 -S media -G users && \
    mkdir -p /media-apps/data/sonarr /sabnzbd/Tv /sonarr && \
    chown -R media:users /media-apps/data/sonarr /tvseries && \
\
    wget https://update.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz -O /NzbDrone.master.tar.gz && \
    tar -xf /NzbDrone.master.tar.gz --strip 1 -C /sonarr && \
    chown -R media:users /sonarr && \
\
    apk del \
      make \
      g++ gcc git sqlite && \
    rm -rf \
      "/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" \
      "/MediaInfo_DLL_${MEDIAINFO_VERSION}_GNU_FromSource.tar.xz" \
      /mono-$MONO_VERSION-x86_64.pkg.tar.xz \
      /NzbDrone.master.tar.gz \
      /MediaInfo_CLI_GNU_FromSource \
      /MediaInfo_DLL_GNU_FromSource \
      /tmp/* \
      /var/cache/apk/*

EXPOSE 8989

USER media

VOLUME ["/media-apps/data/sonarr", "/sabnzbd/Tv"]

CMD ["/usr/bin/mono", "/sonarr/NzbDrone.exe", "--no-browser", "-data=/media-apps/data/sonarr"]
