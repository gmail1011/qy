import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum YuePaoVerificationAction {
  onSubmit,
  onSelectPic,
  onUpdatePic,
}

class YuePaoVerificationActionCreator {
  static Action onSubmit() {
    return const Action(YuePaoVerificationAction.onSubmit);
  }
  static Action onSelectPic() {
    return const Action(YuePaoVerificationAction.onSelectPic);
  }

  static Action onUpdatePic(List<String> list) {
    return Action(YuePaoVerificationAction.onUpdatePic, payload: list);
  }
}
