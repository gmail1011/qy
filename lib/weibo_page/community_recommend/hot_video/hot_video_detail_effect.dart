import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_base/utils/log.dart';

import 'hot_video_detail_action.dart';
import 'hot_video_detail_state.dart';

Effect<HotVideoDetailState> buildEffect() {
  return combineEffects(<Object, Effect<HotVideoDetailState>>{
    HotVideoDetailAction.action: _onAction,
    Lifecycle.initState : _onGetHotVideo,
  });
}

void _onAction(Action action, Context<HotVideoDetailState> ctx) {
}

void _onGetHotVideo(Action action, Context<HotVideoDetailState> ctx) async {
  try {
    String reqDate = await _getReqDate();
    //CommonPostRes commonPostRes = await netManager.client.getCommunityRecommentListHotVideo(1, 10, ctx.state.id, reqDate,true);
    CommonPostRes commonPostRes = await netManager.client.getCommunityRecommentList(1, 10, ctx.state.id, reqDate);
    ctx.dispatch(HotVideoDetailActionCreator.onGetHotVideo(commonPostRes));
  } catch (e) {
    l.e("getGroup", e);
  }
}


// 获取服务器时间
Future<String> _getReqDate() async {
  String reqDate;
  try {
    reqDate = (await netManager.client.getReqDate()).sysDate;
  } catch (e) {
    l.e("tag", "_onRefresh()...error:$e");
  }
  if (TextUtil.isEmpty(reqDate)) {
    reqDate = (netManager.getFixedCurTime().toString());
  }
  return reqDate;
}
