#! /usr/bin/env bash

INKSCAPE='/Applications/Inkscape.app/Contents/MacOS/inkscape'
IMAGES_DIR='images'

export_ui_icons() {
  IMAGE_PATHS=(
    "images/color_change_delta_kind_0.svg"
    "images/color_change_delta_kind_1.svg"
  )
  IMAGES_EXPORTED_DIR='images/exported'

  for SVG_PATH in ${IMAGE_PATHS[@]}; do
      SVG_NAME=`basename $SVG_PATH`
      PATH_TO_EXPORT="$IMAGES_EXPORTED_DIR/$SVG_NAME"
      mkdir -p $IMAGES_EXPORTED_DIR
      $INKSCAPE $SVG_PATH --actions='select-all;object-to-path;select-all;object-stroke-to-path' \
        --export-text-to-path --export-filename $PATH_TO_EXPORT --export-plain-svg
  done
}

export_app_icon() {
  SVG_PATH='images/app_icon.svg'

  $INKSCAPE $SVG_PATH --export-filename 'assets/app_icon.png' -w 24 -h 24
  $INKSCAPE $SVG_PATH --export-filename 'web/favicon.png' -w 16 -h 16
  $INKSCAPE $SVG_PATH --export-filename 'web/icons/Icon-192.png' -w 192 -h 192
  $INKSCAPE $SVG_PATH --export-filename 'web/icons/Icon-512.png' -w 512 -h 512
}

export_ui_icons
export_app_icon
