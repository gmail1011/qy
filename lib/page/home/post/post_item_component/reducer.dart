import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_model.dart';
import 'action.dart';
import 'state.dart';

Reducer<PostItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<PostItemState>>{
      PostItemAction.followSuccess: _followSuccess,
      PostItemAction.fullTextTap: _fullTextTap,
      PostItemAction.changeCollectSuccess: _changeCollectSuccess,
      PostItemAction.onBuyVideoSuccess: _videoPaySuccess,
      PostItemAction.commentSuccess: _commentSuccess,
    },
  );
}

PostItemState _commentSuccess(PostItemState state, Action action) {
  if (state.uniqueId == action.payload) {
    PostItemState newState = state.clone();
    newState.videoModel.commentCount += 1;
    return newState;
  }
  return state;
}

PostItemState _followSuccess(PostItemState state, Action action) {
  if (action.payload != state.uniqueId) {
    return state;
  }
  final PostItemState itemState = state.clone();
  return itemState;
}

PostItemState _changeCollectSuccess(PostItemState state, Action action) {
  final PostItemState itemState = action.payload;
  if (state.uniqueId == itemState.uniqueId) {
    PostItemState newState = state.clone();
    if ((newState.type == "3" ? newState.newVideoModel[0].vidStatus : newState.videoModel.vidStatus ) == null) {
      if(newState.type == "3"){
        newState.newVideoModel[0].vidStatus = VidStatusBean()..hasCollected = false;
      }else{
        newState.videoModel.vidStatus = VidStatusBean()..hasCollected = false;
      }

    }

    if(newState.type == "3"){
      newState.newVideoModel[0].vidStatus.hasCollected =
      !(newState.newVideoModel[0].vidStatus.hasCollected);
    }else{
      newState.videoModel.vidStatus.hasCollected =
      !(newState.videoModel.vidStatus.hasCollected);
    }


    return newState;
  }
  return state;
}

PostItemState _fullTextTap(PostItemState state, Action action) {
  final PostItemState itemState = action.payload;
  if (state.uniqueId == itemState.uniqueId) {
    PostItemState newState = state.clone();
    newState.isDidFullButton = !newState.isDidFullButton;
    return newState;
  }
  return state;
}

PostItemState _videoPaySuccess(PostItemState state, Action action) {
  final String uniqueId = action.payload;
  if (state.uniqueId == uniqueId) {
    PostItemState newState = state.clone();
    newState.videoModel.vidStatus.hasPaid = true;
    return newState;
  }
  return state;
}
