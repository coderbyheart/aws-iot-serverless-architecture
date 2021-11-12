FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:16

RUN wget https://github.com/jgm/pandoc/releases/download/2.16.1/pandoc-2.16.1-1-amd64.deb && \
    sudo dpkg -i pandoc-2.16.1-1-amd64.deb && \
    pandoc -v

RUN npm install -g npm@8

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends inotify-tools