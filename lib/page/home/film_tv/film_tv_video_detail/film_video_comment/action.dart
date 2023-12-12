import 'package:fish_redux/fish_redux.dart';

enum FilmVideoCommentAction {
  updateUI,
  refreshCommentList,
  loadMoreCommentList,
  getRelayList,
  sendComment,
  sendReply,
  stopVideoPlay,
  notifyReStartPlayVideo,
}

class FilmVideoCommentActionCreator {
  static Action refreshCommentList() {
    return const Action(FilmVideoCommentAction.refreshCommentList);
  }

  static Action loadMoreCommentList() {
    return const Action(FilmVideoCommentAction.loadMoreCommentList);
  }

  static Action updateUI() {
    return const Action(FilmVideoCommentAction.updateUI);
  }

  static Action getRelayList(int index) {
    return Action(FilmVideoCommentAction.getRelayList, payload: index);
  }

  static Action sendComment(String content, int parentIndex) {
    return Action(FilmVideoCommentAction.sendComment, payload: {
      "content": content,
      "parentIndex": parentIndex,
    });
  }

  static Action sendReply(String content, int parentIndex, int childIndex) {
    return Action(FilmVideoCommentAction.sendReply, payload: {
      "content": content,
      "parentIndex": parentIndex,
      "childIndex": childIndex,
    });
  }

  static Action stopVideoPlay(String videoId) {
    return Action(FilmVideoCommentAction.stopVideoPlay, payload: videoId);
  }

  static Action notifyReStartPlayVideo(String videoId) {
    return Action(FilmVideoCommentAction.notifyReStartPlayVideo,
        payload: videoId);
  }
}
