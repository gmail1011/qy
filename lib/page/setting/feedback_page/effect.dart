import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<FeedbackState> buildEffect() {
  return combineEffects(<Object, Effect<FeedbackState>>{
    FeedbackAction.submit: _onSubmit,
    FeedbackAction.loadMoreFeedbackList: _loadMoreFeedbackList,
    Lifecycle.initState: _init,
  });
}

void _loadMoreFeedbackList(Action action, Context<FeedbackState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model =
        await netManager.client.feedbackList(number, ctx.state.pageSize);

    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    if (model.feedbacks != null) {
      ctx.dispatch(FeedbackActionCreator.setMoreFeedbackList(model.feedbacks));
    }
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
}

void _init(Action action, Context<FeedbackState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
    try {
      var model = await netManager.client.feedbackList(1, ctx.state.pageSize);
      ctx.dispatch(FeedbackActionCreator.setFeedbackList(model.feedbacks));
    } catch (e) {}
  });
}

bool isSubmit = false;
void _onSubmit(Action action, Context<FeedbackState> ctx) async {
  if (isSubmit) {
    showToast(msg: "重复提交");
    return;
  }
  isSubmit = true;
  var text = ctx.state.editingController.text;
  if (TextUtil.isEmpty(text)) {
    showToast(msg: '提交内容不能为空！');
  } else {
    try {
      await netManager.client.feedback(text);
      showToast(msg: '提交成功');
      safePopPage();
    } catch (e) {
      showToast(msg: '提交失败');
    }
  }
  isSubmit = false;
}
