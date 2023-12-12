import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum AVCommentaryAction { action }

class AVCommentaryActionCreator {
  static Action onAction() {
    return const Action(AVCommentaryAction.action);
  }
}
