import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/message/message_model.dart';
import 'package:flutter_app/model/message/message_type_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class MsgState with EagleHelper implements Cloneable<MsgState> {
  String customServiceUrl;

  ///客戶已休息
  bool isRest = false;

  MessageTypeModel messageTypeModel;

  List<MessageModel> messageModelList = [];

  AdsInfoBean adsBean;

  MsgState() {
    ///在线客服
    MessageModel messageModel = MessageModel();
    messageModel.sender = 'ONLINE';
    messageModel.icon = AssetsSvg.MESSAGE_IC_ONLINE_CUSTOMER_SERVICE;
    messageModel.newsCount = 0;
    messageModel.title = Lang.ONLINE_CUSTOM_SERVICE;
    messageModel.content = Lang.CUSTOM_SERVICE_SUBTITLE;
    messageModelList.add(messageModel);
  }

  @override
  MsgState clone() {
    return MsgState()
      ..customServiceUrl = customServiceUrl
      ..isRest = isRest
      ..adsBean = adsBean
      ..messageTypeModel = messageTypeModel
      ..messageModelList = messageModelList;
  }
}

MsgState initState(Map<String, dynamic> args) {
  return MsgState();
}
