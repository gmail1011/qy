import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageState implements Cloneable<MessageState> {
  int pageNumber = 1;
  int pageSize = 12;
  List<AdsInfoBean> adsList = [];
  RefreshController refreshController = RefreshController();

  MessageListData messageListData;

  @override
  MessageState clone() {
    return MessageState()
      ..pageNumber = pageNumber
      ..refreshController = refreshController
      ..messageListData = messageListData
      ..pageSize = pageSize
      ..adsList = adsList;
  }
}

MessageState initState(Map<String, dynamic> args) {
  return MessageState();
}
