import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';

enum MyDownloadAction { beginUpdateList, updateListOkay }

class MyDownloadActionCreator {
  static Action onUpdateList(List<VideoModel> list) {
    return Action(MyDownloadAction.updateListOkay, payload: list);
  }

  static Action beginUpdateList() {
    return Action(MyDownloadAction.beginUpdateList);
  }
}
