import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:video_player/video_player.dart';

class YuePaoBannerState implements Cloneable<YuePaoBannerState> {
  List<YuePaoResources> resources = [];
  VideoPlayerController videoPlayerController;
  // 索引
  var selectIndex = 0;

  @override
  YuePaoBannerState clone() {
    return YuePaoBannerState()
    ..selectIndex = selectIndex
    ..videoPlayerController = videoPlayerController
    ..resources = resources;
  }
}

YuePaoBannerState initState(Map<String, dynamic> args) {
  return YuePaoBannerState()
  ..resources = args['resources']
  ..selectIndex = args['index'];
}
