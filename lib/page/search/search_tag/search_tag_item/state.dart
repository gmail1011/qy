import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_home_model.dart';
import 'package:flutter_app/model/video_model.dart';

class SearchTagItemState implements Cloneable<SearchTagItemState> {
  VideoModel videoModel;
  ToneListBean bean;

  SearchTagItemState({this.videoModel,this.bean});

  @override
  SearchTagItemState clone() {
    return SearchTagItemState()
      ..videoModel = videoModel
      ..bean = bean;
  }
}

SearchTagItemState initState(Map<String, dynamic> args) {
  return SearchTagItemState();
}
