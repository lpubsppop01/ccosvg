enum SettingsChangeTarget {
  toleranceDegree,
  toleranceRatio,
}

class SettingsChange {
  SettingsChangeTarget target;
  Object newValue;

  SettingsChange(this.target, this.newValue);
}
