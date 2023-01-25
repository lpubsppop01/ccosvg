FROM gitpod/workspace-flutter

USER gitpod

RUN git config --global url."https://github.com/".insteadOf git@github.com:
