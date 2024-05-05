import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ueek_tempo/models/forecast.model.dart';
import 'package:ueek_tempo/utils/assets.dart';

class ForecastService {
  static const apiUri = 'https://api.open-meteo.com/v1/';

  static Future<ForecastModel> getCurrentForecast(double latitude, double longitude) async {
    var response = await http.get(Uri.parse('${apiUri}forecast?current=temperature_2m,weather_code&latitude=$latitude&longitude=$longitude&timezone=auto'));

    log('getCurrentForecast');

    return ForecastModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  static const weathers = <List<int>, (String, String)>{
    [0, 1]: ('Céu Limpo', ASSETS.iconSunny),
    [2]: ('Parcialmente Nublado', ASSETS.iconPartlyCloudy),
    [3]: ('Nublado', ASSETS.iconCloudy),
    [45, 48]: ('Nevoeiro', ASSETS.iconFoggy),
    [51, 53, 55, 56, 57]: ('Chuvisco', ASSETS.iconDrizzle),
    [61, 63, 65, 66, 67]: ('Chuvoso', ASSETS.iconRainy),
    [71, 73, 75, 77, 85, 86]: ('Neve', ASSETS.iconSnowy),
    [80, 81, 82]: ('Aguaceiro', ASSETS.iconRainy),
    [95, 96, 99]: ('Tempestade', ASSETS.iconThunderstorms),
    [100]: ('Indisponível', ''),
  };
}
