import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/search/search_user_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchUserState with EagleHelper implements Cloneable<SearchUserState> {
  BaseRequestController baseRequestController = BaseRequestController();
  RefreshController refreshController = RefreshController();
  List<SearchUserModel> searchUsers = [];
  String keywords = '';
  int pageSize = 10;
  int pageNumber = 1;

  @override
  SearchUserState clone() {
    return SearchUserState()
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController
      ..searchUsers = searchUsers
      ..keywords = keywords
      ..pageSize = pageSize
      ..pageNumber = pageNumber;
  }
}

SearchUserState initState(Map<String, dynamic> args) {
  var state = SearchUserState();
  if (args != null) {
    state.keywords = args['keywords'] ?? '';
  }
  return state;
}
