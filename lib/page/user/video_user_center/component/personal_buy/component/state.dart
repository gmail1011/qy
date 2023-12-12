import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

class BuyItemState implements Cloneable<BuyItemState> {
  String uniqueId;

  VideoModel videoModel;

  BuyItemState() {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  BuyItemState clone() {
    return BuyItemState()
      ..uniqueId = uniqueId
      ..videoModel = videoModel;
  }
}

BuyItemState initState(Map<String, dynamic> args) {
  return BuyItemState();
}
