#! /usr/bin/env bash

INKSCAPE='/Applications/Inkscape.app/Contents/MacOS/inkscape'
IMAGES_DIR='images'
IMAGES_EXPORTED_DIR='images/exported'

for SVG_PATH in $IMAGES_DIR/*.svg; do
    SVG_NAME=`basename $SVG_PATH`
    PATH_TO_EXPORT="$IMAGES_EXPORTED_DIR/$SVG_NAME"
    mkdir -p $IMAGES_EXPORTED_DIR
    $INKSCAPE $SVG_PATH --actions='select-all;object-to-path;select-all;object-stroke-to-path' \
      --export-text-to-path --export-filename $PATH_TO_EXPORT --export-plain-svg
done
