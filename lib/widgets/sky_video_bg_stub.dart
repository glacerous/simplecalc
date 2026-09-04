import 'package:flutter/material.dart';

class SkyBackgroundPlatform extends StatelessWidget {
  const SkyBackgroundPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/blue_sky_poster.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
