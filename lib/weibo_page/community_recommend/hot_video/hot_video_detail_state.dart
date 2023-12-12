import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/common_post_res.dart';

class HotVideoDetailState implements Cloneable<HotVideoDetailState> {
  CommonPostRes commonPostResHotVideo;
  String id;

  @override
  HotVideoDetailState clone() {
    return HotVideoDetailState()
      ..commonPostResHotVideo = commonPostResHotVideo
      ..id = id;
  }
}

HotVideoDetailState initState(Map<String, dynamic> args) {
  return HotVideoDetailState()..id = (args == null ? null : args["id"]);
}
