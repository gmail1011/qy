import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchVideoState with EagleHelper implements Cloneable<SearchVideoState> {
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();
  List<VideoModel> searchVideos = [];
  String keywords = '';
  int pageSize = 10;
  int pageNumber = 1;

  @override
  SearchVideoState clone() {
    return SearchVideoState()
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController
      ..searchVideos = searchVideos
      ..keywords = keywords
      ..pageSize = pageSize
      ..pageNumber = pageNumber;
  }
}

SearchVideoState initState(Map<String, dynamic> args) {
  var state = SearchVideoState();
  if (args != null) {
    state.keywords = args['keywords'] ?? '';
  }
  return state;
}
