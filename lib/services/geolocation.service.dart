import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ueek_tempo/models/location.model.dart';

class GeolocationService {
  static Future<LocationModel> getCurrentLocation() async {
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

    var currentPosition = await Geolocator.getCurrentPosition();
    var geoPosition = await GeoCode().reverseGeocoding(latitude: currentPosition.latitude, longitude: currentPosition.longitude);

    var location = LocationModel(region: geoPosition.region, latitude: currentPosition.latitude, longitude: currentPosition.longitude);

    return location;
  }
}
