

import 'package:chat_online_customers/chat_widget/chat_model/chat_faq_model.dart';

class Instance {
  //记录登陆状态
  static bool isConnect = false;

  //客服头像
  static String customerAvatar;
  //客服名字
  static String customerUsername = '客服妹子';
  //记录当前历史消息里面的sessionId
  static String currentSessionId;
  //是否是匿名用户
  static bool isAnonymous = false;

  //记录faq问题分类
  static ChatFaqModel faqModel;

  //是否回调当前收到消息通知 默认不回调
  static bool isCallBack = false;

  //消息条数
  static int count = 0;

  //是否是异常断开连接 当前回话是否存在
  static bool isShut = false;

  // static Timer timer;
  //主动断开webSocket
  // static void closeWebScoket() {
  //   if (Instance.isConnect == true) {
  //     timer = Timer.periodic(Duration(seconds: 30), (t) {
  //       print('========已断开===========');
  //       //3分钟后自动断开webSocket
  //       MsgUtils.closeSocket();
  //       t.cancel();
  //       t = null;
  //     });
  //   }
  // }
}
