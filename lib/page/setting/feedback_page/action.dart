import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/feedback_model.dart';

enum FeedbackAction {
  action,
  submit,
  setFeedbackList,
  setMoreFeedbackList,
  loadMoreFeedbackList,
}

class FeedbackActionCreator {
  static Action onSubmit() {
    return const Action(FeedbackAction.submit);
  }

  static Action setFeedbackList(List<FeedbackItem> feedbacks) {
    return Action(FeedbackAction.setFeedbackList, payload: feedbacks);
  }

  static Action setMoreFeedbackList(List<FeedbackItem> feedbacks) {
    return Action(FeedbackAction.setMoreFeedbackList, payload: feedbacks);
  }

  static Action loadMoreFeedbackList() {
    return Action(FeedbackAction.loadMoreFeedbackList);
  }
}
