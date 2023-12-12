import 'package:fish_redux/fish_redux.dart';

class AVCommentaryState implements Cloneable<AVCommentaryState> {

  @override
  AVCommentaryState clone() {
    return AVCommentaryState();
  }
}

AVCommentaryState initState(Map<String, dynamic> args) {
  return AVCommentaryState();
}
