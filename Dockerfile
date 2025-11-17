# syntax=docker/dockerfile:1

FROM openjdk:8u312-jre

LABEL version="2.9.3"
LABEL homepage.group=Minecraft
LABEL homepage.name="RLCraft 1.12.2 - Release v2.9.3"
LABEL homepage.icon="https://media.forgecdn.net/avatars/468/243/637751369169569212.png"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://RLCraft:25565

RUN apt-get update && apt-get install -y curl unzip && \
    adduser --uid 1000 --gid 1000 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

# Remove default MOTD to avoid sed error
ENV MOTD ""

CMD ["/launch.sh"]