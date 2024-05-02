import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ueek_tempo/models/forecast.model.dart';
import 'package:ueek_tempo/models/location.model.dart';

class ForecastService {
  static const apiUri = 'https://api.open-meteo.com/v1/';

  static Future<ForecastModel> getCurrentForecast(LocationModel location) async {
    var response = await http.get(Uri.parse('${apiUri}forecast?current=temperature_2m,weather_code&latitude=${location.latitude}&longitude=${location.longitude}&timezone=auto'));

    return ForecastModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}