FROM maven:3.9.0-eclipse-temurin-17

USER root
RUN apt-get update && apt-get install -y curl \
    && curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

USER jenkins