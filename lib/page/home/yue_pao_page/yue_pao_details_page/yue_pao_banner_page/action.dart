import 'package:fish_redux/fish_redux.dart';

enum YuePaoBannerAction { action }

class YuePaoBannerActionCreator {
  static Action onAction() {
    return const Action(YuePaoBannerAction.action);
  }
}
