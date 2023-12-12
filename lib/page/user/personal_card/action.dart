import 'package:fish_redux/fish_redux.dart';

enum PersonalCardAction { onLoadData, onSaveImage}

class PersonalCardActionCreator {

  static Action onLoadData() {
    return const Action(PersonalCardAction.onLoadData);
  }

  static Action onSaveImage() {
    return Action(PersonalCardAction.onSaveImage);
  }
}
