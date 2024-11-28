FROM maven:3.9.0-eclipse-temurin-17

USER root

RUN apt-get update
RUN apt-get install -y curl apt-transport-https ca-certificates gnupg2 software-properties-common apt-utils
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       bullseye stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
RUN if ! getent group docker; then groupadd docker; fi
RUN if ! id -u jenkins > /dev/null 2>&1; then useradd jenkins; fi
RUN usermod -aG docker jenkins

USER jenkins