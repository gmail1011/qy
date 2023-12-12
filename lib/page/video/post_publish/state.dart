import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class PostPublishState with EagleHelper implements Cloneable<PostPublishState> {

  TextEditingController contentController, tagController;

  @override
  PostPublishState clone() {
    return PostPublishState()
      ..contentController = contentController
      ..tagController = tagController;
  }
}

PostPublishState initState(Map<String, dynamic> args) {
  PostPublishState newState = PostPublishState();
  newState.contentController = TextEditingController();
  newState.tagController = TextEditingController();
  return PostPublishState();
}
