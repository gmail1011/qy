import 'package:chat_online_customers/chat_widget/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_svg/svg.dart';

class SingleVideoItem extends StatefulWidget{

  String videoUrl;
  String videoCover;
  SingleVideoItem({this.videoUrl,this.videoCover});
  @override
  State<StatefulWidget> createState() {

    return SingleVideoItemState();
  }

}

class SingleVideoItemState extends State<SingleVideoItem> with WidgetsBindingObserver{
  bool isPlaying = false;

  SingleController enablePlay  = SingleController(true);
  IjkBaseVideoController playCtrl;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        PrintUtil().log("==========================didChangeAppLifecycleState paused");
        if(playCtrl!=null){
          playCtrl.pause();
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SinglePlayer(widget.videoUrl,
                widget.videoUrl,
                onInited: (c) async {
                  isPlaying = true;
                  setState(() {

                  });

                },

                updateCallBack: (c) async {

                  int timeNow = c.currentPos.inSeconds;

                },

                loop: true,
                onRelease: (c) {
                  CacheServer().cancelM3u8(widget.videoUrl);
                },
                onCreateController: (c) {
                  playCtrl = c;
                },
                onComplete: (c){

                },


                playerBuilder: (c) => VPlayer(
                  controller: c,

                  showProgress: true,
                  progressColors: VideoProgressColors(backgroundColor: Colors.black),
                  resolutionWidth: MediaQuery.of(context).size.width,
                  resolutionHeight: MediaQuery.of(context).size.height,
                  onDoubleTap: (c){

                  },
                  onTap: (c){
                    if(c.isPlaying){
                      c.pause();
                    }else{
                      c.start();
                    }
                  },

                ),
                singleController: enablePlay),

          ],
        ),
      ),
    );
  }

}