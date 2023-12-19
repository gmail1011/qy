import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:video_player/video_player.dart';

import 'images_animation.dart';


bool isPlayingMedia = false;

class ChatItemAudioWidget extends StatefulWidget {
  final CommentModel model;

   ChatItemAudioWidget({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatItemAudioWidgetState();
  }
}

class _ChatItemAudioWidgetState extends State<ChatItemAudioWidget> {
  CommentModel get model => widget.model;
  VideoPlayerController controller;
  int get  audioDuration => 10;
  bool isPlaying = false;
  bool _mPlayerIsInited = true;
  String errorStr = "";
  bool get isLeftStyle => GlobalStore.isMe(widget.model?.userID) != true;


  @override
  void initState() {
    super.initState();
  //  initController();
  }

  void initController() async {
    try {
      String url = model?.content ?? "";
      controller = VideoPlayerController.network(url);
      await controller?.initialize();
      controller?.addListener(_lister);
      _mPlayerIsInited = true;
    } catch (e) {
      _mPlayerIsInited = true;
      errorStr = e.toString();
      debugLog("audio error: $e");
    }
    setState(() {});
  }


  void _lister() {
    if(controller != null && controller?.value?.initialized == true){
      int position = controller?.value?.position?.inSeconds ?? 0;
      if((audioDuration ?? 0) > 0){
        if(controller?.value?.isPlaying != true && controller?.value?.isBuffering != true){
          if(isPlaying) {
            isPlaying = false;
            controller?.pause();
            controller?.seekTo(Duration.zero);
            setState(() {});
            isPlayingMedia = false;
          }
        }
        if(position == audioDuration) {
          if(isPlaying) {
            isPlaying = false;
            controller?.pause();
            controller?.seekTo(Duration.zero);
            setState(() {});
            isPlayingMedia = false;
          }
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // if (_mPlayerIsInited && errorStr.isEmpty) {
        //   if (isPlaying) {
        //     controller?.pause();
        //     isPlayingMedia = false;
        //   } else {
        //     controller?.play();
        //     isPlayingMedia = true;
        //   }
        //
        // }
        isPlaying = !isPlaying;
        setState(() {});
      },
      child: _buildAudioItem(),
    );
  }

  Widget _buildAudioItem() {
    return SizedBox(
      height: 40,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (controller != null)
            SizedBox(
              width: 80,
              height: 30,
              child: VideoPlayer(controller),
            ),
          Container(
            height: 40,
            width: 120,
            padding:  EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: isLeftStyle ?  Color(0xff333333) : AppColors.primaryTextColor,
              borderRadius: BorderRadius.only(
                bottomLeft:  Radius.circular(8),
                bottomRight:  Radius.circular(8),
                topLeft: Radius.circular(isLeftStyle ? 0 : 8),
                topRight: Radius.circular(isLeftStyle ? 8 : 0),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  left: isLeftStyle ? 0 : null,
                  right: isLeftStyle ? null : 0,
                  child: Row(
                    children: [
                      if (!isLeftStyle) ...[
                        if (!_mPlayerIsInited)
                          CupertinoActivityIndicator(
                            radius: 8,
                          ),
                        if (audioDuration != null)
                          Text(
                            "$audioDuration\"     ",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                      ],
                      _buildAudioPlayAnimation(),
                      if (isLeftStyle) ...[
                        if (audioDuration != null)
                          Text(
                            "     $audioDuration\"",
                            style:  TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        if (!_mPlayerIsInited)
                           CupertinoActivityIndicator(
                            radius: 8,
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            //  child:
          )
        ],
      ),
    );
  }

  Widget _buildAudioPlayAnimation() {
    if (isPlaying) {
      return ImagesAnimation(
        isLeftStyle: isLeftStyle,
        w: 12,
        h: 16,
        durationSeconds: 1,
        entry: ImagesAnimationEntry(0, 2),
      );
    } else {
      return Transform.rotate(
        //旋转90度
        angle: isLeftStyle ? 0 : pi,
        child: Image.asset(
          "assets/images/cI2.png",
          gaplessPlayback: true, //避免图片闪烁
          width: 12,
          height: 16,
          color: Colors.white,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.removeListener(_lister);
    controller?.dispose();
    super.dispose();
  }
}
