import 'package:chat_online_customers/chat_widget/chat_page/key_board_component/action.dart';

import '../List_component/action.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../action.dart';

// 获取id
Future<String> obtainValueByKey(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get(key);
}

dynamic selectAction(int action, dynamic data) {
  switch (action) {
    case 2013:
      return ChatActionCreator.onPlayerInfo(data);
    case 2002:
      return ChatActionCreator.onServicerInfoFields(data);
    case 2003:
      return ListActionCreator.onShowMsg(data);
    case 1010:
      return KeyBoardActionCreator.onDontTalk(data);
    case 2005:
      return ChatActionCreator.onChatUserInfo(data);
    case 2009:
      return KeyBoardActionCreator.onEnterStatus(data);
    case 2008:
      return ListActionCreator.onGetHistoryMsg(data);
    case 2012:
      return ChatActionCreator.onTyping();
    case 2010:
      return ListActionCreator.onWaitAction(data);
    case 2000:
      return ListActionCreator.onRefuseConnect(data);
    case 2006:
      return ListActionCreator.onMsgRead(data);
    case 2004:
      return ChatActionCreator.onGetVoiceData(data);
    case 2018:
      return ChatActionCreator.onAswer(data);
    default:
  }
  return null;
}
