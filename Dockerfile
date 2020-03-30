FROM openjdk:alpine
MAINTAINER Joel Collins <joel@jtcollins.net>

USER root
WORKDIR /minecraft

VOLUME /minecraft/world
VOLUME /minecraft/settings

EXPOSE 25565

RUN apk update && apk add curl bash

# Download and unzip minecraft files
RUN mkdir -p /minecraft/settings
RUN mkdir -p /minecraft/world

RUN wget https://edge.forgecdn.net/files/2700/189/All+the+Mods+3+Lite-v3.1.0-Serverfiles-FULL.zip -O server_files.zip
RUN unzip server_files.zip
RUN rm server_files.zip

# Accept EULA
RUN echo "# EULA accepted on $(date)" > /minecraft/eula.txt && \
    echo "eula=TRUE" >> eula.txt

# Fix borked settings.cfg by sticking a semi-colon at the end of each line
RUN sed -i "s/$/;/g" settings.cfg

# Startup script
COPY start.sh /minecraft/
RUN chmod +x /minecraft/*.sh

CMD ["/bin/bash", "/minecraft/start.sh"]
