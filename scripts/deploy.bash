#! /usr/bin/env bash

flutter pub global activate peanut && \
flutter pub global run peanut -b production --web-renderer canvaskit && \
git push origin production
