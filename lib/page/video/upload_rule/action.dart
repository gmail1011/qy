import 'package:fish_redux/fish_redux.dart';

enum UploadRuleAction { backAction,loadUploadRuleAction,initSuccessAction }

class UploadRuleActionCreator {
  static Action onBack() {
    return const Action(UploadRuleAction.backAction);
  }
  static Action initSuccessAction() {
    return const Action(UploadRuleAction.initSuccessAction);
  }

}
