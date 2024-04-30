import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage('assets/background_img.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 45, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/ueek_logo.svg'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
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
                        child: const Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '28°C',
                                        style: TextStyle(
                                          fontFamily: 'Sarabun',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: Color.fromRGBO(0, 178, 255, 1),
                                        ),
                                      ),
                                      Text(
                                        'Chuvoso',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(color: Color.fromRGBO(25, 26, 28, 1), height: 40,),
                            ],
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
      ),
    );
  }
}
