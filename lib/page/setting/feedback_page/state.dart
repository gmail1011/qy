import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/feedback_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedbackState with EagleHelper implements Cloneable<FeedbackState> {
  TextEditingController editingController = TextEditingController();
  List<FeedbackItem> feedbacks;
  int pageNumber = 1;
  int pageSize = 10;
  RefreshController refreshController = RefreshController();
  @override
  FeedbackState clone() {
    return FeedbackState()
      ..editingController = editingController
      ..feedbacks = feedbacks
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..refreshController = refreshController;
  }
}

FeedbackState initState(Map<String, dynamic> args) {
  return FeedbackState();
}
