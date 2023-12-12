import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/message/message_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class SystemMessageState with EagleHelper implements Cloneable<SystemMessageState> {
  final int pageSize = Config.PAGE_SIZE;
  int pageNumber = 1;

  String messageType = 'SYSTEM';

  String title = '';

  List<MessageModel> messageModelList;

  bool hasNext = false;

  @override
  SystemMessageState clone() {
    return SystemMessageState()
      ..pageNumber = pageNumber
      ..messageType = messageType
      ..hasNext = hasNext
      ..title = title
      ..messageModelList = messageModelList;
  }
}

SystemMessageState initState(Map<String, dynamic> args) {
  SystemMessageState state = SystemMessageState();
  if (args != null && args['type'] != null) {
    state.messageType = args['type'];
  }
  if (args != null && args['title'] != null) {
    state.title = args['title'];
  }
  return state;
}
