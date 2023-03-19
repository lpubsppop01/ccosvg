# CCoSVG

A simple web app that lists and changes colors contained in a SVG file.

This app is under development, but available [here](https://ccosvg.lpubsppop01.com).

## Features

### 1. Open SVG File

Tap the "Open SVG File" button on the start page and select the SVG file you want to edit the colors.
The SVG content image and color table will be shown.

### 2. Edit Colors

The color table contains checkboxes for each row.
When check some of them, the edit buttons will be shown beside "H", "S" and "L" on the header row.
Tap the edit button to edit Hue, Saturation or Lightness.

### 3. Download Result

After color editing, download the resulting SVG file form the download button on the image preview area.

## Notes

The aim of this app is to change colors of illustrations in batch on iPad.
Illustrator for iPad doesn't contains "Recolor Artwork" feature that the desktop version contains.

The feature seems to be protected by the following patents.
- [Combined color harmony generation and artwork recoloring mechanism - Google Patents](https://patents.google.com/patent/US8085276)
- [Color selection interface - Google Patents](https://patents.google.com/patent/US8013869)

I created this app for personal use, but I also intended to publish it, so I took care to avoid the above patents. This app doesn't consider  relationships between colors, but simply change them in batch.
It also only contains generic UI controls.

I'm a beginner in illustration, and I've only seen "Recolor Artwork" in the video,
so it may not be similar in the first place.

## Author

[lpubsppop01](https://github.com/lpubsppop01)

## License

[zlib License](https://github.com/lpubsppop01/ccosvg/raw/master/LICENSE.txt)
