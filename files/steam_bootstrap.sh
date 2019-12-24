#!/bin/sh
set -e

if [ -z "${STEAM_TOKEN}" ]; then
  >&2 echo "Please set the STEAM_TOKEN environment variable."
  exit 1
fi

if [ -z "${RCON_PASSWORD}" ]; then
  >&2 echo "Please set the RCON_PASSWORD environment variable."
  exit 1
fi

su steam -c \
     "mkdir -p /steam/cmd \
     && cd /steam/cmd \
     && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -"

su steam -c \
    "/steam/cmd/steamcmd.sh +login anonymous \
        +force_install_dir /steam/csgo-dedicated \
        +app_update 740 validate \
        +quit"

su steam -c "{ \
     echo '@ShutdownOnFailedCommand 1'; \
     echo '@NoPromptForPassword 1'; \
     echo 'login anonymous'; \
     echo 'force_install_dir /steam/csgo-dedicated/'; \
     echo 'app_update 740'; \
     echo 'quit'; \
} > /steam/csgo-dedicated/csgo_update.txt"

su steam -c "{ \
     echo '#!/bin/sh'; \
     echo '/steam/csgo-dedicated/srcds_run -game csgo -console -autoupdate \
       -steam_dir /steam/cmd/ -steamcmd_script /steam/csgo-dedicated/csgo_update.txt \
       -usercon +fps_max 300 -tickrate 128 -port 27015 -tv_port 27020 -net_port_try 1 \
       -maxplayers_override 20 +game_type 0 +game_mode 2  \
       +map de_shortnuke +hostname \"CS:GO 2v2\" +exec scrim16 \
       +sv_setsteamaccount ${STEAM_TOKEN} \
       +rcon_password ${RCON_PASSWORD} +sv_region 0'; \
} > /steam/csgo-dedicated/start.sh"

chmod +x /steam/csgo-dedicated/start.sh
