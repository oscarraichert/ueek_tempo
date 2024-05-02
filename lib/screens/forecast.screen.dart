import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ueek_tempo/models/forecast.model.dart';
import 'package:ueek_tempo/models/location.model.dart';
import 'package:ueek_tempo/services/forecast.service.dart';
import 'package:ueek_tempo/services/geolocation.service.dart';

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
            image: AssetImage('assets/images/background_img.png'),
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
                  SvgPicture.asset('assets/images/ueek_logo.svg'),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder(
                                            future: geolocationFuture.then((location) => ForecastService.getCurrentForecast(location)),
                                            builder: (BuildContext context, AsyncSnapshot<ForecastModel> snapshot) {
                                              var tempStyle = const TextStyle(
                                                fontFamily: 'Sarabun',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                                color: Color.fromRGBO(0, 178, 255, 1),
                                              );
                                              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                                                return Text(
                                                  '${snapshot.data!.temperature.round()}${snapshot.data!.tempUnit}',
                                                  style: tempStyle,
                                                );
                                              }
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Text(
                                                  '...',
                                                  style: tempStyle,
                                                );
                                              }
                                              return Text(
                                                'Indisponível',
                                                style: tempStyle,
                                              );
                                            },
                                          ),
                                          const Text(
                                            'Chuvoso',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/icon_rainy.svg',
                                        width: 24,
                                      ),
                                    ],
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
                                          Image.asset('assets/images/location_marker.png'),
                                          const SizedBox(width: 5),
                                          FutureBuilder(
                                            future: geolocationFuture,
                                            builder: (BuildContext context, AsyncSnapshot<LocationModel> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done && snapshot.data?.region != null) {
                                                return Text(
                                                  '${snapshot.data!.region}',
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
                                          ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(41, 44, 53, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 124,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: ElevatedButton(
                      onPressed: () => setState(() => ()),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color.fromRGBO(0, 178, 255, 1),
                      ),
                      child: const Text(
                        'Atualizar',
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 20,
                          color: Color.fromRGBO(252, 252, 252, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
