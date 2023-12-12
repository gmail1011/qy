import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

class MineBuyItemState implements Cloneable<MineBuyItemState> {
  String uniqueId;

  VideoModel videoModel;

  MineBuyItemState() {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  MineBuyItemState clone() {
    return MineBuyItemState()
      ..uniqueId = uniqueId
      ..videoModel = videoModel;
  }
}

MineBuyItemState initState(Map<String, dynamic> args) {
  return MineBuyItemState();
}
