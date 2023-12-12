import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/chewie/material_controls.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:video_player/video_player.dart';
import '../../utils/EventBusUtils.dart';

class AiVideoPage extends StatefulWidget {
  String videoUrl;
  String title;
  bool isTemple;
  int index;
  bool loadingCompulete = false;

  AiVideoPage(this.videoUrl, this.title, {this.isTemple = false, this.index});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AiVideoPageState();
  }
}

class _AiVideoPageState extends State<AiVideoPage> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  String videoUrl;

  @override
  void initState() {
    super.initState();

    initData();
  }

  @override
  void dispose() {
    super.dispose();

    videoPlayerController.dispose();
    chewieController.dispose();
  }

  Future initData() async {

    videoUrl = CacheServer().getLocalUrl(widget.videoUrl);

    videoPlayerController = VideoPlayerController.network(videoUrl);

    await videoPlayerController.initialize();
    widget.loadingCompulete = true;
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: true,
      customControls: MaterialControls(),
      allowPlaybackSpeedChanging: false,
      allowMuting: false,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppbar(
        title: widget.title,
      ),
      body:widget.loadingCompulete?(chewieController == null
          ? Container()
          : Stack(
        children: [
          Chewie(controller: chewieController),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: GestureDetector(
          //     onTap: () {
          //       bus.emit(EventBusUtils.changeAITemple, widget.index);
          //       safePopPage();
          //     },
          //     child: Container(
          //       height: 52,
          //       alignment: Alignment.center,
          //       margin: EdgeInsets.only(bottom: 30),
          //       child: Image.asset(
          //         "assets/images/hls_ai_btn_use_temple.png",
          //         width: 228,
          //         height: 44,
          //       ),
          //     ),
          //   ),
          // )
        ],
      )):(LoadingWidget(title: "加载中..."))
    );
  }
}
