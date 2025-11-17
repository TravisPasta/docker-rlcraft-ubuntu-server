#!/bin/bash
set -x

FORGE_VERSION=1.12.2-14.23.5.2860
PACK_ZIP="RLCraft Server Pack 1.12.2 - Release v2.9.3.zip"
PACK_URL="https://edge.forgecdn.net/files/4612/990/RLCraft%20Server%20Pack%201.12.2%20-%20Release%20v2.9.3.zip"

# Ensure /data exists
mkdir -p /data
cd /data

# ======================
#  EULA
# ======================
if [[ "$EULA" != "false" ]]; then
    echo "eula=true" > eula.txt
else
    echo "You must accept the EULA to install."
    exit 99
fi

# ======================
#  Download + Install Server
# ======================
if [[ ! -d "mods" ]]; then
    echo "Downloading RLCraft pack..."
    curl -Lo "$PACK_ZIP" "$PACK_URL"
    unzip -o "$PACK_ZIP" -d /data

    echo "Installing Forge..."
    curl -Lo forge-installer.jar \
        "https://maven.minecraftforge.net/net/minecraftforge/forge/${FORGE_VERSION}/forge-${FORGE_VERSION}-installer.jar"

    java -jar forge-installer.jar --installServer

    rm -f forge-installer.jar
fi

# ======================
#  Server Properties
# ======================
# Only modify MOTD if provided
if [[ -n "$MOTD" ]]; then
    sed -i "s/^motd=.*/motd=$MOTD/" server.properties
fi

# Set ops (simple mode)
if [[ -n "$OPS" ]]; then
    echo "$OPS" | tr ',' '\n' > ops.txt
fi

# Basic config tweaks
sed -i 's/^server-port=.*/server-port=25565/' server.properties
sed -i 's/^allow-flight=.*/allow-flight=true/' server.properties
sed -i 's/^difficulty=.*/difficulty=3/' server.properties
sed -i 's/^max-tick-time=.*/max-tick-time=-1/' server.properties
sed -i 's/^enable-command-block=.*/enable-command-block=true/' server.properties

# ======================
#  Start Server
# ======================
java -server ${JVM_OPTS} \
    -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy \
    -Xmn128M \
    ${JAVA_PARAMETERS} \
    -jar forge-${FORGE_VERSION}.jar nogui
