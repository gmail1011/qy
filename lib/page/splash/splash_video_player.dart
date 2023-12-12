import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app/assets/images.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:video_player/video_player.dart';

class SplashVideoPlayer extends StatefulWidget {
  @override
  _SplashVideoPlayerState createState() => _SplashVideoPlayerState();
}

class _SplashVideoPlayerState extends State<SplashVideoPlayer> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset(AssetsImages.SPLASH1);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screen.screenWidth,
      height: screen.screenHeight,
      child: VideoPlayer(_controller),
    );
  }
}
