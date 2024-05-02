class ForecastModel {
  final String tempUnit;
  final double temperature;
  final int weatherCode;

  const ForecastModel({required this.tempUnit, required this.temperature, required this.weatherCode});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'current_units': {
          'temperature_2m': String tempUnit,
        },
        'current': {
          'temperature_2m': double temperature,
          'weather_code': int weatherCode,
        },
      } =>
        ForecastModel(tempUnit: tempUnit, temperature: temperature, weatherCode: weatherCode),
      _ => throw const FormatException('Failed to convert json.'),
    };
  }
}
