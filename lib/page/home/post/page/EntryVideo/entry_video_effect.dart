import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/entry_video_entity.dart';
import 'package:flutter_app/utils/date_time_util.dart';

import 'entry_video_action.dart';
import 'entry_video_state.dart';

Effect<EntryVideoState> buildEffect() {
  return combineEffects(<Object, Effect<EntryVideoState>>{
    EntryVideoAction.action: _onInitData,
    EntryVideoAction.onSelected: _onSelected,
    Lifecycle.initState: _onInitData,
    EntryVideoAction.action1: _onAction1,
    Lifecycle.dispose: _onDispose,

    EntryVideoAction.onDataLoadMore: _onDataLoadMore,
    EntryVideoAction.onDataLoadMore1: _onDataLoadMore1,
  });
}

void _onAction(Action action, Context<EntryVideoState> ctx) {}

void _onDispose(Action action, Context<EntryVideoState> ctx) {
  ctx.state.timerUtil.cancel();
}

void _onInitData(Action action, Context<EntryVideoState> ctx) async {
  dynamic entryVideo = await netManager.client
      .getEntryVideo(ctx.state.activityId,0, ctx.state.pageNumber, ctx.state.pageSize);

  dynamic entryVideo1 = await netManager.client
      .getEntryVideo(ctx.state.activityId,1, ctx.state.pageNumber1, ctx.state.pageSize1);

  EntryVideoData entryVideoData = EntryVideoData().fromJson(entryVideo);

  EntryVideoData entryVideoData1 = EntryVideoData().fromJson(entryVideo1);

  if(DateUtil.getDateMsByTimeStr(entryVideoData.activityEndTime) - DateUtil.getNowDateMs() > 100){
    ctx.state.timerUtil.setTotalTime(
        DateUtil.getDateMsByTimeStr(entryVideoData.activityEndTime) - DateUtil.getNowDateMs());

    ctx.state.timerUtil.startCountDown();
  }


  ctx.dispatch(EntryVideoActionCreator.onInitData(entryVideoData));

  ctx.dispatch(EntryVideoActionCreator.onInitData1(entryVideoData1));

  ctx.state.timerUtil.setOnTimerTickCallback((millisUntilFinished) {
    //print(DateUtil.formatDateMs(millisUntilFinished, format: "dd天HH时mm分ss秒"));
    ctx.dispatch(EntryVideoActionCreator.onCountDownTime(DateUtil.formatDateMs(millisUntilFinished, format: "dd天HH时mm分ss秒")));
  });

}

void _onAction1(Action action, Context<EntryVideoState> ctx) async {

  dynamic entryVideo1 = await netManager.client
      .getEntryVideo(ctx.state.activityId,1, ctx.state.pageNumber1, ctx.state.pageSize1);

  EntryVideoData entryVideoData1 = EntryVideoData().fromJson(entryVideo1);

  ctx.dispatch(EntryVideoActionCreator.onInitData1(entryVideoData1));

}


void _onSelected(Action action, Context<EntryVideoState> ctx) async {
  dynamic entryVideo = await netManager.client
      .getEntryVideo(action.payload,0, ctx.state.pageNumber, ctx.state.pageSize);

  dynamic entryVideo1 = await netManager.client
      .getEntryVideo(action.payload,1, ctx.state.pageNumber1, ctx.state.pageSize1);

  EntryVideoData entryVideoData = EntryVideoData().fromJson(entryVideo);

  EntryVideoData entryVideoData1 = EntryVideoData().fromJson(entryVideo1);

  bool isBeforeTodayTime = isBeforeToday(entryVideoData.activityEndTime);

  ctx.dispatch(EntryVideoActionCreator.isBeforeToday(isBeforeTodayTime));

  ctx.dispatch(EntryVideoActionCreator.onInitData(entryVideoData));

  ctx.dispatch(EntryVideoActionCreator.onInitData1(entryVideoData1));

}


void _onDataLoadMore(Action action, Context<EntryVideoState> ctx) async {
  dynamic entryVideo = await netManager.client
      .getEntryVideo(ctx.state.activityId,0, action.payload, ctx.state.pageSize);

  EntryVideoData entryVideoData = EntryVideoData().fromJson(entryVideo);

  if(entryVideoData.workList.length == 0){
    ctx.state.refreshController.loadNoData();
  }else{
    ctx.state.entryVideoData.workList.addAll(entryVideoData.workList);
    ctx.dispatch(EntryVideoActionCreator.onInitData(ctx.state.entryVideoData));
    ctx.state.refreshController.loadComplete();
  }

}


void _onDataLoadMore1(Action action, Context<EntryVideoState> ctx) async {
  dynamic entryVideo = await netManager.client
      .getEntryVideo(ctx.state.activityId,0, action.payload, ctx.state.pageSize1);

  EntryVideoData entryVideoData = EntryVideoData().fromJson(entryVideo);

  if(entryVideoData.workList.length == 0){
    ctx.state.refreshController1.loadNoData();
  }else{
    ctx.state.entryVideoData1.workList.addAll(entryVideoData.workList);
    ctx.dispatch(EntryVideoActionCreator.onInitData1(ctx.state.entryVideoData1));
    ctx.state.refreshController1.loadComplete();
  }

}


bool isBeforeToday(var startDate) {
  var endDate = new DateTime.now();
  return DateTime.parse(startDate).isBefore(endDate);
}


