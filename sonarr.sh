#! /bin/sh

# Start Sonarr
/sbin/su-exec sonarr /usr/bin/mono /opt/sonarr/NzbDrone.exe \
   --no-browser \
   -data=/media-apps/data/sonarr

