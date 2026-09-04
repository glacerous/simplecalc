import 'package:flutter/material.dart';

import 'sky_video_bg_stub.dart'
    if (dart.library.html) 'sky_video_bg_web.dart'
    as bg_impl;

class SkyBackground extends StatelessWidget {
  const SkyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const bg_impl.SkyBackgroundPlatform();
  }
}
