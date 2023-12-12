import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_talk_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchTagState with EagleHelper implements Cloneable<SearchTagState> {
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();
  List<SearchTalkModel> searchTags = [];
  String keywords = '';
  int pageSize = 20;
  int pageNumber = 1;

  @override
  SearchTagState clone() {
    return SearchTagState()
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController
      ..searchTags = searchTags
      ..keywords = keywords
      ..pageSize = pageSize
      ..pageNumber = pageNumber;
  }
}

SearchTagState initState(Map<String, dynamic> args) {
  var state = SearchTagState();
  if (args != null) {
    state.keywords = args['keywords'] ?? '';
  }
  return state;
}
