import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ueek_tempo/models/forecast.model.dart';
import 'package:ueek_tempo/services/forecast.service.dart';
import 'package:ueek_tempo/services/geolocation.service.dart';
import 'package:ueek_tempo/utils/assets.dart';
import 'package:ueek_tempo/utils/styles.dart';
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
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 44,
                              ),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                    future: geolocationFuture.then((location) => ForecastService.getCurrentForecast(location.latitude, location.longitude)),
                                    builder: (BuildContext context, AsyncSnapshot<ForecastModel> snapshot) {
                                      return Row(
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
                                      );
                                    },
                                  ),
                                  const Divider(
                                    color: Color.fromRGBO(25, 26, 28, 1),
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(ASSETS.locationMarker),
                                          const SizedBox(width: 5),
                                          getLocation(),
                                        ],
                                      ),
                                      const Text(
                                        'HOJE',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
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

  FutureBuilder<String?> getLocation() {
    return FutureBuilder(
      future: geolocationFuture.then((value) => GeolocationService.getReverseGeocode(value)),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Text(
            snapshot.data!,
            style: const TextStyle(fontSize: 10),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            'Carregando...',
            style: TextStyle(fontSize: 10),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback(
          (Duration duration) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Erro'),
              content: Text('${snapshot.error}'),
              titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
              contentTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );

        return const Text(
          'Indisponível',
          style: TextStyle(fontSize: 10),
        );
      },
    );
  }

  Builder getWeatherIcon(AsyncSnapshot<ForecastModel> snapshot) {
    return Builder(
      builder: (context) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return SvgPicture.asset(
            ForecastService.weathers.entries.firstWhere((element) => element.key.contains(snapshot.data!.weatherCode)).value.$2,
            width: 24,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            '...',
            style: TextStyle(fontSize: 22),
          );
        }

        return const Text('');
      },
    );
  }

  Builder getWeatherCondition(AsyncSnapshot<ForecastModel> snapshot) {
    return Builder(
      builder: (context) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return Text(
            ForecastService.weathers.entries.firstWhere((element) => element.key.contains(snapshot.data!.weatherCode)).value.$1,
            style: const TextStyle(fontSize: 10),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            '...',
            style: TextStyle(fontSize: 10),
          );
        }

        return const Text(
          'Indisponível',
          style: TextStyle(fontSize: 10),
        );
      },
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
}
