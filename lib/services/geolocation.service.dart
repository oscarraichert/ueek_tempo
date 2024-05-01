import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<String?> getCurrentLocation() async {
    LocationPermission locationPermission;

    var locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      return Future.error('Ativar localização do dispositivo.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Permitir que o aplicativo acesse a localização do dispositivo.');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Permissão de acesso a localização permanentemente negada, não podemos pedir permissão.');
    }

    var currentPosition = await Geolocator.getCurrentPosition();
    var geoPosition = await GeoCode().reverseGeocoding(latitude: currentPosition.latitude, longitude: currentPosition.longitude);

    return geoPosition.region;
  }
}
