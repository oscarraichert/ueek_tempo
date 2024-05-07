import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ueek_tempo/models/forecast.model.dart';
import 'package:ueek_tempo/services/forecast.service.dart';
import 'package:ueek_tempo/services/geolocation.service.dart';
import 'package:ueek_tempo/utils/assets.dart';
import 'package:ueek_tempo/widgets/bottom_button.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  var geolocationFuture = GeolocationService.getCurrentLocation();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    geolocationFuture = GeolocationService.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.zero,
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(ASSETS.forecastBackgroundImg),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(ASSETS.ueekLogo),
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [STYLES.cardBoxShadow],
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  getForecastRow(),
                                  const Divider(
                                    color: STYLES.dividerColor,
                                    height: 40,
                                  ),
                                  getLocationRow(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BottomButton.build('Atualizar', () => setState(() => ())),
          ],
        ),
      ),
    );
  }

  FutureBuilder<ForecastModel> getForecastRow() {
    return FutureBuilder(
      future: geolocationFuture.then((location) => ForecastService.getCurrentForecast(location.latitude, location.longitude)),
      builder: (BuildContext context, AsyncSnapshot<ForecastModel> snapshot) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTemperature(snapshot),
              getWeatherCondition(snapshot),
            ],
          ),
          getWeatherIcon(snapshot),
        ],
      ),
    );
  }

  Builder getTemperature(AsyncSnapshot<ForecastModel> snapshot) {
    return Builder(
      builder: (context) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return Text(
            '${snapshot.data!.temperature.round()}${snapshot.data!.tempUnit}',
            style: STYLES.temperatureStyle,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            '...',
            style: STYLES.temperatureStyle,
          );
        }
        return const Text(
          'Indisponível',
          style: STYLES.temperatureStyle,
        );
      },
    );
  }

  Builder getWeatherCondition(AsyncSnapshot<ForecastModel> snapshot) {
    return Builder(
      builder: (context) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return Text(
            ForecastService.getWeatherCondition(snapshot.data!.weatherCode).$1,
            style: STYLES.smallText,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            '-',
            style: STYLES.smallText,
          );
        }

        return const Text(
          'Indisponível',
          style: STYLES.smallText,
        );
      },
    );
  }

  Builder getWeatherIcon(AsyncSnapshot<ForecastModel> snapshot) {
    return Builder(
      builder: (context) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return SvgPicture.asset(
            ForecastService.getWeatherCondition(snapshot.data!.weatherCode).$2,
            width: 24,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }

        return const Text('');
      },
    );
  }

  Row getLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              ASSETS.locationMarker,
            ),
            const SizedBox(width: 5),
            getLocation(),
          ],
        ),
        const Text(
          'HOJE',
          style: STYLES.smallText,
        ),
      ],
    );
  }

  FutureBuilder<String?> getLocation() {
    return FutureBuilder(
      future: geolocationFuture.then((value) => GeolocationService.getReverseGeocode(value)),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Text(
            snapshot.data!,
            style: STYLES.smallText,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            'Carregando...',
            style: STYLES.smallText,
          );
        }
        WidgetsBinding.instance.addPostFrameCallback(
          (Duration duration) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Alerta'),
              content: Text('${snapshot.error}'),
              titleTextStyle: STYLES.dialogTitle,
              contentTextStyle: STYLES.dialogContent,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: STYLES.dialogButton,
                  ),
                ),
              ],
            ),
          ),
        );

        return const Text(
          'Indisponível',
          style: STYLES.smallText,
        );
      },
    );
  }
}

abstract class STYLES {
  static const temperatureStyle = TextStyle(
    fontFamily: 'Sarabun',
    fontWeight: FontWeight.w600,
    fontSize: 22,
    color: Color.fromRGBO(0, 178, 255, 1),
  );

  static const smallText = TextStyle(fontSize: 10);

  static const cardBoxShadow = BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 44);

  static const dividerColor = Color.fromRGBO(25, 26, 28, 1);

  static const dialogTitle = TextStyle(color: Colors.black, fontSize: 20);

  static const dialogContent = TextStyle(color: Colors.black, fontSize: 14);

  static const dialogButton = TextStyle(fontSize: 16);
}
