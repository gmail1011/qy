import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'guess_like_entity.dart';
import 'hot_recommend_entity.dart';

class SearchState implements Cloneable<SearchState> {
  TextEditingController textEditingController = new TextEditingController();
  HotRecommendData hotRecommendData;
  GuessLikeData guessLikeData;

  int pageNumber = 1;
  int pageSize = 30;

  RefreshController refreshController = RefreshController();

  List<List<HotRecommendDataList>> xList = [];

  int changeCount = 0;

  SharedPreferences prefs;

  List<String> searchLists = new List();

  List<List<TagDetailModel>> tagList = [];

  ///猜你喜欢展示列表
  List<GuessLikeDataList> guessLikeShowList = [];
  int startGuessLikeIndex = 0;

  @override
  SearchState clone() {
    return SearchState()
      ..textEditingController = textEditingController
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..guessLikeData = guessLikeData
      ..refreshController = refreshController
      ..xList = xList
      ..changeCount = changeCount
      ..prefs = prefs
      ..searchLists = searchLists
      ..tagList = tagList
      ..hotRecommendData = hotRecommendData
      ..guessLikeShowList = guessLikeShowList
      ..startGuessLikeIndex = startGuessLikeIndex;
  }
}

SearchState initState(Map<String, dynamic> args) {
  return SearchState();
}
