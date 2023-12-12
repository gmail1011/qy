import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/message/comment_reply_model.dart';

enum CommentAction {
  loadCommentReplyAction,
  onLoadCommentReplyAction,
}

class CommentActionCreator {
  static Action loadCommentReply() {
    return const Action(CommentAction.loadCommentReplyAction);
  }

  static Action onLoadCommentReply(List<CommentReplyModel> commentList, bool hasNext) {
    return Action(CommentAction.onLoadCommentReplyAction, payload: {'data': commentList, 'hasNext': hasNext});
  }
}
