import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_video_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultState implements Cloneable<SearchResultState> {
  String keyword;
  TextEditingController textEditingController;
  TabController tabController =
      new TabController(length: 5, vsync: ScrollableState());

  int moviePageNum = 1;
  int moviePageSize = 12;

  SearchVideoData searchMovieData;
  RefreshController refreshMovieController = RefreshController();





  int videoPageNum = 1;
  int videoPageSize = 12;

  SearchVideoData searchVideoData;
  RefreshController refreshVideoController = RefreshController();






  int wordPageNum = 1;
  int wordPageSize = 12;

  SearchVideoData searchWordData;
  RefreshController refreshWordController = RefreshController();



  int userPageNum = 1;
  int userPageSize = 12;

  SearchBeanData searchBeanData;
  RefreshController refreshUserController = RefreshController();




  int topicPageNum = 1;
  int topicPageSize = 12;

  SearchTopicData searchBeanDataTopic;
  RefreshController refreshTopicController = RefreshController();

  bool isSearchUser;

  String history = "history";

  SharedPreferences prefs;

  List<String> searchLists = new List();


  @override
  SearchResultState clone() {
    return SearchResultState()
      ..moviePageNum = moviePageNum
      ..moviePageSize = moviePageSize
      ..searchMovieData = searchMovieData
      ..refreshMovieController = refreshMovieController

      ..videoPageNum = videoPageNum
      ..videoPageSize = videoPageSize
      ..searchVideoData = searchVideoData
      ..refreshVideoController = refreshVideoController


      ..wordPageNum = wordPageNum
      ..wordPageSize = wordPageSize
      ..searchWordData = searchWordData
      ..refreshWordController = refreshWordController



      ..userPageNum = userPageNum
      ..userPageSize = userPageSize
      ..searchBeanData = searchBeanData
      ..refreshUserController = refreshUserController



      ..topicPageNum = topicPageNum
      ..topicPageSize = topicPageSize
      ..searchBeanDataTopic = searchBeanDataTopic
      ..refreshTopicController = refreshTopicController

      ..keyword = keyword
      ..textEditingController = textEditingController
      ..isSearchUser = isSearchUser
      ..prefs = prefs
      ..searchLists = searchLists
      ..tabController = tabController;
  }
}

SearchResultState initState(Map<String, dynamic> args) {
  return SearchResultState()..keyword = args["keyword"]..textEditingController = new TextEditingController(text: args["keyword"]);
}
