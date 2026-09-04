// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class SkyBackgroundPlatform extends StatefulWidget {
  const SkyBackgroundPlatform({super.key});

  @override
  State<SkyBackgroundPlatform> createState() => _SkyBackgroundPlatformState();
}

class _SkyBackgroundPlatformState extends State<SkyBackgroundPlatform> {
  static bool _registered = false;
  static const String _viewType = 'sky-video-element-v1';

  @override
  void initState() {
    super.initState();
    if (!_registered) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final video = html.VideoElement()
          ..src = 'blue_sky_loop.mp4?v=1'
          ..autoplay = true
          ..loop = true
          ..muted = true
          ..setAttribute('playsinline', 'true')
          ..style.objectFit = 'cover'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = 'none'
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.left = '0';
        video.play();
        return video;
      });
      _registered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
