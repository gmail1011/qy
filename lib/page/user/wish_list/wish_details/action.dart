import 'package:fish_redux/fish_redux.dart';

enum WishDetailsAction {
  updateUI,
  getCommentList,
  adoption,
  sendWishComment,
  sendWishReply,
}

class WishDetailsActionCreator {
  static Action getCommentList() {
    return const Action(WishDetailsAction.getCommentList);
  }

  static Action updateUI() {
    return const Action(WishDetailsAction.updateUI);
  }

  static Action adoption(String commentId) {
    return Action(WishDetailsAction.adoption, payload: commentId);
  }

  static Action sendWishComment(String content, int parentIndex) {
    return Action(WishDetailsAction.sendWishComment, payload: {
      "content": content,
      "parentIndex": parentIndex,
    });
  }

  static Action sendWishReply(String content, int parentIndex, int childIndex) {
    return Action(WishDetailsAction.sendWishReply, payload: {
      "content": content,
      "parentIndex": parentIndex,
      "childIndex": childIndex,
    });
  }
}
