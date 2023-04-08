import 'package:ccosvg/models/settings_change.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SettingsChange() should work', () {
    var instance = SettingsChange(SettingsChangeTarget.toleranceDegree, 20);
    expect(instance.target, SettingsChangeTarget.toleranceDegree);
    expect(instance.newValue, 20);
  });
}
