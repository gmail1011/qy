import 'package:fish_redux/fish_redux.dart';

enum WishPublishAction {
  publish,
  updateUI,
  setAmountValue,
  selectImage,
  deleteImage,
}

class WishPublishActionCreator {
  static Action publistQuestion() {
    return const Action(WishPublishAction.publish);
  }

  static Action updateUI() {
    return const Action(WishPublishAction.updateUI);
  }

  static Action selectImage() {
    return const Action(WishPublishAction.selectImage);
  }

  static Action deleteImage(int index) {
    return Action(WishPublishAction.deleteImage, payload: index);
  }

  static Action setAmountValue(String amountValue) {
    return Action(WishPublishAction.setAmountValue, payload: amountValue);
  }
}
