import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/message/message_model.dart';

enum SystemMessageAction { backAction, onLoadMessageAction, loadMessageAction,onOpenService }

class SystemMessageActionCreator {
  static Action onBack() {
    return const Action(SystemMessageAction.backAction);
  }

  static Action loadMessage() {
    return Action(SystemMessageAction.loadMessageAction);
  }

  static Action onOpenService() {
    return Action(SystemMessageAction.onOpenService);
  }

  static Action onLoadMessage(List<MessageModel> messageTypeModel, bool hasNext) {
    return Action(SystemMessageAction.onLoadMessageAction, payload: {'data': messageTypeModel, 'hasNext': hasNext});
  }
}
