import 'dart:async';

import 'package:belffin/utils/constants.dart';
import 'package:belffin/views/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool animate = false;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick == 4) {
        timer.cancel();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Homepage()));
      } else {
        animate = !animate;
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: websiteColor,
      body: Center(
        child: AnimatedContainer(
          height: animate?130:90,
          width: animate?130:90,
          padding: const EdgeInsets.all(10),
          duration: const Duration(milliseconds: 1200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(logo),
        ),
      ),
    );
  }
}
