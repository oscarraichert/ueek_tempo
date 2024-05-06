import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationService {
  static Future<Position> getCurrentLocation() async {
    LocationPermission locationPermission;

    var locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled) {
      return Future.error('Ativar localização do dispositivo.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Permita que o aplicativo acesse a localização do dispositivo.');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Permissão de acesso a localização permanentemente negada, habilitar nas configurações.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  }

  static Future<String?> getReverseGeocode(Position currentPosition) async {
    var geoPosition = await placemarkFromCoordinates(currentPosition.latitude, currentPosition.longitude);
    return '${geoPosition.first.subAdministrativeArea}, ${geoPosition.first.administrativeArea}';
  }
}
