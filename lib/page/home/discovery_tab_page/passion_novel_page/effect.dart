import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/fiction_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/passion_novel_view_page/page.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<PassionNovelState> buildEffect() {
  return combineEffects(<Object, Effect<PassionNovelState>>{
    // PassionNovelAction.action: _onAction,
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
  });
}

/// 监听滚动位置作出相应调整
// var _prevProx;
// void listen(ScrollController scrollController){
//     double prox = scrollController.offset.toDouble();
//     if(prox < 16) {
//       // _timer = Timer(Duration(milliseconds: 100), ()=>);
//     }
//     /// 给上一个位置赋值
//     _prevProx = prox;
//   }
void _init(Action action, Context<PassionNovelState> ctx) {
  Future.delayed(Duration(milliseconds: 300), () {
    _getFictions(ctx);
  });
}

/// 获取小说类别
void _getFictions(Context<PassionNovelState> ctx) async {
  try {
    FictionModel fictionModel = await netManager.client.getFictionTypes();
    List<String> tabNames = fictionModel.fictionType.where((text) => !TextUtil.isEmpty(text)).toList();
    List<Widget> tabViewList = [];
    ctx.state.tabController =
        TabController(length: tabNames.length, vsync: ScrollableState());
    for (int i = 0; i < tabNames.length; i++) {
        tabViewList.add(
            PassionNovelViewPage().buildPage({'fictionType': tabNames[i]}));
    }
    ctx.dispatch(
        PassionNovelActionCreator.onAssignmentTab(tabNames, tabViewList));
  } catch (e) {
    l.e('getFictionTypes=>', e.toString());
  }
}

void _dispose(Action action, Context<PassionNovelState> ctx) {}
