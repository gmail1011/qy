import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/message/fans_model.dart';
import 'package:flutter_app/model/message/fans_obj.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';
import 'package:flutter_app/weibo_page/message/add/add_bean_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'add_user_entity.dart';

class AddState implements Cloneable<AddState> {
  TextEditingController textEditingController = new TextEditingController();

  RefreshController refreshController = new RefreshController();

  int pageSize = 16;
  int pageNumber = 1;

  AddUserData fansObj;

  bool isSearchUser = false;

  SearchBeanData searchBeanData;

  RefreshController refreshUserController = RefreshController();

  int userPageNum= 1;

  @override
  AddState clone() {
    return AddState()
      ..textEditingController = textEditingController
      ..refreshController = refreshController
      ..pageSize = pageSize
      ..fansObj = fansObj
      ..isSearchUser = isSearchUser
      ..searchBeanData = searchBeanData
      ..refreshUserController = refreshUserController
      ..userPageNum = userPageNum
      ..pageNumber = pageNumber;
  }
}

AddState initState(Map<String, dynamic> args) {
  return AddState();
}
