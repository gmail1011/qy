import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

class WorkItemState implements Cloneable<WorkItemState> {
  String uniqueId;

  VideoModel videoModel;

  WorkItemState() {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  WorkItemState clone() {
    return WorkItemState()
      ..videoModel = videoModel
      ..uniqueId = uniqueId;
  }
}

WorkItemState initState(Map<String, dynamic> args) {
  return WorkItemState();
}
