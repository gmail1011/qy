import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WishPublishState> buildReducer() {
  return asReducer(
    <Object, Reducer<WishPublishState>>{
      WishPublishAction.updateUI: _updateUI,
      WishPublishAction.setAmountValue: _setAmountValue,
      WishPublishAction.deleteImage: _deleteImage,
    },
  );
}

WishPublishState _updateUI(WishPublishState state, Action action) {
  final WishPublishState newState = state.clone();
  return newState;
}

WishPublishState _deleteImage(WishPublishState state, Action action) {
  final WishPublishState newState = state.clone();
  int index = action.payload as int;
  if (index < (newState.localImagePathList?.length ?? 0)) {
    newState.localImagePathList?.removeAt(index);
  }
  return newState;
}

WishPublishState _setAmountValue(WishPublishState state, Action action) {
  final WishPublishState newState = state.clone();
  newState.setAmountValue = action.payload;
  return newState;
}
