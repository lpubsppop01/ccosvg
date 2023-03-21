FROM gitpod/workspace-flutter

# Firebase CLI
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt update
RUN apt install -y nodejs
RUN npm install -g firebase-tools

USER gitpod

# Flutter SDK
RUN git clone -b 3.7.7 https://github.com/flutter/flutter.git $HOME/opt/flutter
ENV PATH="$HOME/opt/flutter/bin:$PATH"
