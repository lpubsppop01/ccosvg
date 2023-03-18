FROM debian

RUN apt update
RUN apt install -y curl git unzip

RUN git clone -b 3.7.7 https://github.com/flutter/flutter.git
ENV PATH="/flutter/bin:$PATH"
