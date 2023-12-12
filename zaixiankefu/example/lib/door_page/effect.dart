


import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_model/userModel.dart';
import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';
import 'view.dart';

Effect<DoorState> buildEffect() {
  return combineEffects(<Object, Effect<DoorState>>{
    DoorAction.action: _onAction,
    Lifecycle.initState : _init,
  });
}

void _onAction(Action action, Context<DoorState> ctx) {
}
void _init(Action action, Context<DoorState> ctx) {
    String url = 'https://ssbb.eddxe.com/customer/im?protoType=1&pType=201&appId=7028499103&sign=301f901da3316162abb1995789e2e9f9c66178ee1599ce5bf539302810eb7394f495d022d040bcc0ba08b15333a1faed';//'ws://183.61.126.215:9090/customer/im?sign=346de818698fed14e44cc49a9a2d19a7243a809a261bb81485f99ac354e1f8ddc0800fb1fb821997af1a4ba290e7f6beb07d3e55a5b15e9db2ac6bd1cb1447635c727be5e58c4e36e9834980c18f10cb&appId=9189155602&protoType=1&pType=201';
  // KefuUserModel model = KefuUserModel(
  //   connectUrl: url,
  //   username: 'username',
  //   baseUrl: 'http://183.61.126.215:8080',
  //   faqHeadImgPath: '',
  //   getMsg: getMsg
  // );
  // MsgUtils.con(url,DateTime.now().millisecondsSinceEpoch,model);
  KefuUserModel model = KefuUserModel(
    username: '',
     baseUrl: 'https://ssbb.eddxe.com',
      connectUrl: url, 
      faqHeadImgPath: null,
      checkConnectApi: '/api/play/unread',
      userId: '666666'
      );
  SocketManager().model = model;
  SocketManager().getMsg = getMsg;
  MsgUtils.judgeIsConnect(model);
}