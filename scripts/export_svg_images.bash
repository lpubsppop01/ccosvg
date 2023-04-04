#! /usr/bin/env bash

INKSCAPE=inkscape
if hash inkscape 2> /dev/null; then
  INKSCAPE=inkscape
elif [ -x '/Applications/Inkscape.app/Contents/MacOS/inkscape' ]; then
  INKSCAPE='/Applications/Inkscape.app/Contents/MacOS/inkscape'
else
  echo 'Error: Cannot execute inkscape'
  exit 1
fi
IMAGES_DIR='images'

export_ui_icons() {
  IMAGE_PATHS=(
    'images/color_change_delta_kind_0.svg'
    'images/color_change_delta_kind_1.svg'
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
  $INKSCAPE 'images/app_icon.svg' --export-filename 'web/favicon.png' -w 16 -h 16
  $INKSCAPE 'images/app_icon.svg' --export-filename 'web/icons/Icon-132.png' -w 132 -h 132  # 44x3
  $INKSCAPE 'images/app_icon_maskable.svg' --export-filename 'web/icons/Icon-192.png' -w 192 -h 192
  $INKSCAPE 'images/app_icon_maskable.svg' --export-filename 'web/icons/Icon-512.png' -w 512 -h 512
  $INKSCAPE 'images/app_icon_maskable.svg' --export-filename 'web/icons/Icon-maskable-192.png' -w 192 -h 192
  $INKSCAPE 'images/app_icon_maskable.svg' --export-filename 'web/icons/Icon-maskable-512.png' -w 512 -h 512
}

export_ui_icons
export_app_icon
