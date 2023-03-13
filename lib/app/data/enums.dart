enum RecordStates {
  none,
  recording,
}

enum SensorType {
  strainGauge('strainGauge', 'Strain Gauge'),
  imu('imu', 'IMU'),
  analog('analog', 'Analog'),
  gps('gps', 'GPS'),
  analog3ch('analog3ch', 'Analog 3CH');

  const SensorType(this.code, this.displayName);
  final String code;
  final String displayName;

  factory SensorType.getByCode(String code) => SensorType.values.firstWhere((value) => value.code == code);
}
