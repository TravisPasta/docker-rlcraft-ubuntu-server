# syntax=docker/dockerfile:1

FROM openjdk:8u312-jre

LABEL version="2.9.3"
LABEL homepage.group=Minecraft
LABEL homepage.name="RLCraft 1.12.2 - Release v2.9.3"
LABEL homepage.icon="https://media.forgecdn.net/avatars/468/243/637751369169569212.png"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://RLCraft:25565

RUN apt-get update && apt-get install -y curl unzip && \
    groupadd -g 1000 minecraft && \
    useradd -u 1000 -g 1000 -d /data -m minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

# Remove default MOTD to avoid sed error
ENV MOTD ""

CMD ["/launch.sh"]