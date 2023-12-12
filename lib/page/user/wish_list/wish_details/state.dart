import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class WishDetailsState implements Cloneable<WishDetailsState> {
  EasyRefreshController refreshController = EasyRefreshController();
  TextEditingController contentController = TextEditingController();

  //评论列表
  List<CommentModel> commentList = [];
  String textInputTip;
  int pageIndex = 0;
  int pageSize = 10;

  bool commentHasNext = true;
  WishListDataList wishListItem;
  String adoptionCmtId;
  bool isDataReq = true;
  bool isErrorNet = false;
  bool hideAdoptionButton = true; //隐藏采纳按钮
  bool isMyWish = false; //是否我的心愿工单
  String wishId;

  @override
  WishDetailsState clone() {
    return WishDetailsState()
      ..isDataReq = isDataReq
      ..isErrorNet = isErrorNet
      ..refreshController = refreshController
      ..contentController = contentController
      ..commentList = commentList
      ..textInputTip = textInputTip
      ..pageIndex = pageIndex
      ..pageSize = pageSize
      ..commentHasNext = commentHasNext
      ..wishListItem = wishListItem
      ..adoptionCmtId = adoptionCmtId
      ..hideAdoptionButton = hideAdoptionButton
      ..isMyWish = isMyWish
      ..wishId = wishId;
  }
}

WishDetailsState initState(Map<String, dynamic> args) {
  return WishDetailsState()
    ..wishId = args["wishId"]
    ..isMyWish = args["isMyWish"] ?? false;
}
