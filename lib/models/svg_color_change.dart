import 'package:ccosvg/helpers/hsl_color_with_delta.dart';
import 'package:ccosvg/models/svg_color.dart';

enum SvgColorChangeTargetComponent {
  hue,
  saturation,
  lightness,
}

enum SvgColorChangeDeltaKind {
  value,
  percentageInLimit,
}

class SvgColorChange {
  SvgColorChangeTargetComponent targetComponent;
  SvgColorChangeDeltaKind kind;
  int delta;

  SvgColorChange(this.targetComponent, this.kind, this.delta);

  void applyToColor(SvgColor color) {
    if (targetComponent == SvgColorChangeTargetComponent.hue) {
      if (kind == SvgColorChangeDeltaKind.value) {
        color.hslColor = color.hslColor.withHueDelta(delta);
      } else if (kind == SvgColorChangeDeltaKind.percentageInLimit) {
        color.hslColor = color.hslColor.withHueDeltaPercentageInChangeableRange(delta / 100.0);
      }
    } else if (targetComponent == SvgColorChangeTargetComponent.saturation) {
      if (kind == SvgColorChangeDeltaKind.value) {
        color.hslColor = color.hslColor.withSaturationDelta(delta / 100.0);
      } else if (kind == SvgColorChangeDeltaKind.percentageInLimit) {
        color.hslColor = color.hslColor.withSaturationDeltaPercentageInChangeableRange(delta / 100.0);
      }
    } else if (targetComponent == SvgColorChangeTargetComponent.lightness) {
      if (kind == SvgColorChangeDeltaKind.value) {
        color.hslColor = color.hslColor.withLightnessDelta(delta / 100.0);
      } else if (kind == SvgColorChangeDeltaKind.percentageInLimit) {
        color.hslColor = color.hslColor.withLightnessDeltaPercentageInChangeableRange(delta / 100.0);
      }
    }
  }
}
