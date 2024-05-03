import 'package:flutter/material.dart';

class BottomButton {
  static Column build(String title, void Function() func) {
    return Column(
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
                      onPressed: func,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color.fromRGBO(0, 178, 255, 1),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 20,
                          color: Color.fromRGBO(252, 252, 252, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
  }
}