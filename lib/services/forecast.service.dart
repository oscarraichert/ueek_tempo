import 'package:http/http.dart' as http;

class ForecastService {
  static const apiUri = 'https://api.open-meteo.com/v1/';

  void getCurrentForecast() {
    http.get(Uri.parse('${apiUri}forecast?latitude=-27.81&longitude=-50.32'));
  }
}