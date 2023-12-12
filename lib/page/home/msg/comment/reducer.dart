import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<CommentState> buildReducer() {
  return asReducer(
    <Object, Reducer<CommentState>>{
      CommentAction.onLoadCommentReplyAction: _onLoadFans,
    },
  );
}

CommentState _onLoadFans(CommentState state, Action action) {
  final CommentState newState = state.clone();
  if(newState.commentReplyList == null) {
    newState.commentReplyList = [];
  }
  newState.commentReplyList.addAll(action.payload['data']);
  newState.hasNext = action.payload['hasNext'];
  newState.videoModelList.clear();
  newState.videoModelList.addAll(newState.commentReplyList.map((item) => item.video));
  return newState;
}
