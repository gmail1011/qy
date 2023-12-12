import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/flutter_base.dart';

class AudiobookState with EagleHelper implements Cloneable<AudiobookState> {
  AudioBookHomeModel audioBookHomeModel;
  PullRefreshController pullRefreshController = PullRefreshController();
  bool isLoading = false;
  @override
  AudiobookState clone() {
    return AudiobookState()
      ..audioBookHomeModel = audioBookHomeModel
      ..isLoading = isLoading
      ..pullRefreshController = pullRefreshController;
  }
}

AudiobookState initState(Map<String, dynamic> args) {
  return AudiobookState();
}
