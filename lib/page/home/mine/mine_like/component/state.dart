import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

class MineLikeItemState implements Cloneable<MineLikeItemState> {
  String uniqueId;

  VideoModel videoModel;

  MineLikeItemState() {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  MineLikeItemState clone() {
    return MineLikeItemState()
      ..videoModel = videoModel
      ..uniqueId = uniqueId;
  }
}

MineLikeItemState initState(Map<String, dynamic> args) {
  return MineLikeItemState();
}
