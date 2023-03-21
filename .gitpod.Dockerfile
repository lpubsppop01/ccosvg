FROM gitpod/workspace-flutter

USER root

RUN apt update
RUN apt install -y curl git unzip lv
RUN echo '. /usr/share/bash-completion/completions/git' >> ~/.bashrc

# Firebase CLI
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt update
RUN apt install -y nodejs
RUN npm install -g firebase-tools

USER gitpod

# Flutter SDK
RUN git clone -b 3.7.7 https://github.com/flutter/flutter.git $HOME/flutter
ENV PATH="$HOME/flutter/bin:$PATH"
