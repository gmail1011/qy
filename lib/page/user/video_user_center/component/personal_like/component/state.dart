import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

class LikeItemState implements Cloneable<LikeItemState> {
  String uniqueId;

  VideoModel videoModel;

  LikeItemState() {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  LikeItemState clone() {
    return LikeItemState()
      ..videoModel = videoModel
      ..uniqueId = uniqueId;
  }
}

LikeItemState initState(Map<String, dynamic> args) {
  return LikeItemState();
}
