import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';

import '../../packets.dart';
import 'localStorage.dart';

dynamic obtainData(int key, List<int> data) {
  switch (key) {
    case 2001:
      return PlayerInfoFields.fromBuffer(data);
    case 2002:
      ServicerInfoFields servicerInfoFields =
          ServicerInfoFields.fromBuffer(data);
      LocalStorage.setValueByKey('sessionId', servicerInfoFields.sessionId);
      LocalStorage.setValueByKey('servicerId', servicerInfoFields.id);
      Instance.currentSessionId = servicerInfoFields.sessionId;
      return servicerInfoFields;
    case 1003:
    case 2003:
      return ChatFields.fromBuffer(data);
    case 2005:
      return ChatUserList.fromBuffer(data);
    case 1006:
      return UpdateReadType.fromBuffer(data);
    case 2006:
      return UpdateReadType.fromBuffer(data);
    case 1008:
      return HistoryMessage.fromBuffer(data);
    case 2008:
      return MessageList.fromBuffer(data);
    case 2010:
      return QueueInfo.fromBuffer(data);
    case 2011:
      return BannedUser.fromBuffer(data);
    case 1012:
    case 2012:
    case 1009:
    case 2009:
      return EnterStatus.fromBuffer(data);
    case 1010:
      return FreezePlayer.fromBuffer(data);
    case 1011:
      return EvaluateScore.fromBuffer(data);
    case 2000:
      return RejectPlayer.fromBuffer(data);
    case 2013:
      PlayerInfo playerInfo = PlayerInfo.fromBuffer(data);
      LocalStorage.setValueByKey('id', playerInfo.id);
      LocalStorage.setValueByKey('platId', playerInfo.platId);
      LocalStorage.setValueByKey('username', playerInfo.username);
      return playerInfo;
    case 1018:
    case 2018:
      return AckReplyPacket.fromBuffer(data);
    case 4001:
      return PlayerDisconnect.fromBuffer(data);
    case 4005:
      return PlayerChangRole.fromBuffer(data);
    case 4002:
      return WaiterDisconnect.fromBuffer(data);
    case 5001:
      return ReLogin.fromBuffer(data);
    case 4003:
      return AppraiseTimeOut.fromBuffer(data);
    case 3010:
      return ReleaseBanned.fromBuffer(data);
    case 2004:
      print('===2004===${ChatAudio.fromBuffer(data)}');
      return ChatAudio.fromBuffer(data);
    default:
  }
}

// // 本地存储Id
// _incrementId(String id) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   await prefs.setString('id', id);
// }
