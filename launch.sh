#!/bin/bash

set -x

if [ -w "/data" ]; then

FORGE_VERSION=1.12.2-14.23.5.2860
cd /data

if ! [[ "$EULA" = "false" ]]; then
  echo "eula=true" > eula.txt
else
  echo "You must accept the EULA to install."
exit 99
fi

if ! [[ -f "RLCraft%20Server%20Pack%201.12.2%20-%20Release%20v2.9.zip" ]]; then
  curl -Lo 'RLCraft%20Server%20Pack%201.12.2%20-%20Release%20v2.9.zip' 'https://edge.forgecdn.net/files/3575/916/RLCraft%20Server%20Pack%201.12.2%20-%20Release%20v2.9.zip' && unzip -u -o 'RLCraft%20Server%20Pack%201.12.2%20-%20Release%20v2.9.zip' -d /data
  curl -Lo forge-${FORGE_VERSION}-installer.jar 'https://maven.minecraftforge.net/net/minecraftforge/forge/'${FORGE_VERSION}'/forge-'${FORGE_VERSION}'-installer.jar'
  java -jar forge-${FORGE_VERSION}-installer.jar --installServer && rm -f forge-${FORGE_VERSION}-installer.jar

fi

if [[ -n "$MOTD" ]]; then
  sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
  echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties
sed -i 's/allow-flight.*/allow-flight=true/g' server.properties
sed -i 's/difficulty.*/difficulty=3/g' server.properties
sed -i 's/max-tick-time.*/max-tick-time=-1/g' server.properties
sed -i 's/enable-command-block.*/enable-command-block=true/g' server.properties

java -server ${JVM_OPTS} -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -Xmn128M ${JAVA_PARAMETERS} -jar forge-${FORGE_VERSION}.jar nogui

else
  echo "Directory is not writable, check permissions in /mnt/user/appdata/rlcraft"
  exit 66
fi