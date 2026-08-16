import 'dart:ui';
import 'package:flutter/material.dart';

import '../widgets/on_boarding/column_layer.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/on_boarding.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(14, 15, 19, 0.44),
                      Color.fromRGBO(14, 15, 19, 0.85),
                      Color(0xFF0E0F13),
                    ],
                    stops: [0.0, 0.57, 1.0],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.8, sigmaY: 1),
                  child: Container(
                    color: Colors.transparent, // مهم حتى يشتغل البلور
                  ),
                ),
              ),
            ),
          ),
          ColumnLayer(),
        ],
      ),
    );
  }
}
