FROM debian

RUN apt update
RUN apt install -y curl git unzip lv
RUN echo '. /usr/share/bash-completion/completions/git' >> ~/.bashrc

# Flutter SDK
RUN git clone -b 3.7.7 https://github.com/flutter/flutter.git /opt/flutter
ENV PATH="/opt/flutter/bin:$PATH"

# Firebase CLI
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt update
RUN apt install -y nodejs
RUN npm install -g firebase-tools
