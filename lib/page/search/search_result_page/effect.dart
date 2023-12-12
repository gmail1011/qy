import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/page/search/search_page/action.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'search_tag_page/action.dart';
import 'search_user_page/action.dart';
import 'search_video_page/action.dart';
import 'state.dart';

Effect<SearchResultState> buildEffect() {
  return combineEffects(<Object, Effect<SearchResultState>>{
    SearchResultAction.onSubmitted: _onSubmitted,
    Lifecycle.initState: _init,
  });
}

void _onSubmitted(Action action, Context<SearchResultState> ctx) {
  var text = action.payload ?? '';
  if (text == ctx.state.keywords) {
    showToast(msg: "请勿重复搜索");
    return;
  }
  /*eagleClick(ctx.state.selfId(),
      sourceId: ctx.state.eagleId(ctx.context), label: text);*/
  ctx.broadcast(SearchVideoActionCreator.broadcastSearchAction(text));
  ctx.broadcast(SearchUserActionCreator.broadcastSearchAction(text));
  ctx.broadcast(SearchTagActionCreator.broadcastSearchAction(text));
  ctx.broadcast(SearchActionCreator.broadcastRefreshHistorys(text));
  ctx.dispatch(SearchResultActionCreator.setKeywords(text));
}

void _init(Action action, Context<SearchResultState> ctx) {
  ctx.state.editingController = TextEditingController.fromValue(
      TextEditingValue(
          text: ctx.state.keywords ?? '',
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream,
              offset: (ctx.state.keywords ?? '').length))));
  Future.delayed(Duration(milliseconds: 200), () {
   // eaglePage(ctx.state.selfId(),
       // sourceId: ctx.state.eagleId(ctx.context));
   // eagleClick(ctx.state.selfId(),
       // sourceId: ctx.state.eagleId(ctx.context),
       // label: ctx.state.keywords ?? "");
  });
}
