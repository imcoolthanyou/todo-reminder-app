import 'package:flutter/material.dart';

// loading screen while app starts up
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // spinner thingy
      ),
    );
  }
}