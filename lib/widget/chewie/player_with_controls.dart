import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'chewie_player.dart';
import 'material_controls.dart';

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    double _calculateAspectRatio(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;

      return width > height ? width / height : height / width;
    }

    Widget _buildControls(
      BuildContext context,
      ChewieController chewieController,
    ) {
      final controls = const MaterialControls();
      return chewieController.showControls
          ? chewieController.customControls ?? controls
          : Container();
    }

    Stack _buildPlayerWithControls(
        ChewieController chewieController, BuildContext context) {
      return Stack(
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          Center(
            child: AspectRatio(
              aspectRatio: chewieController.aspectRatio ??
                  chewieController.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(chewieController.videoPlayerController),
            ),
          ),
          chewieController.overlay ?? Container(),
          if (!chewieController.isFullScreen)
            _buildControls(context, chewieController)
          else
            SafeArea(
              child: _buildControls(context, chewieController),
            ),
        ],
      );
    }

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }
}
