import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'action.dart';
import 'com/public_widget.dart';
import 'state.dart';

Effect<DiscoveryTabState> buildEffect() {
  return combineEffects(<Object, Effect<DiscoveryTabState>>{
    DiscoveryTabAction.onSearchBtm: _onSearchBtm,
    DiscoveryTabAction.onRecordingBtm: _onRecordingBtm,
    Lifecycle.initState: _initState,
  });
}

/// 跳转搜索页面
void _onSearchBtm(Action action, Context<DiscoveryTabState> ctx) {
  int tabIndex = ctx.state.tabController.index;
  switch (tabIndex) {
    // 视频专区搜索页面
    case 0:
      JRouter().go(PAGE_SPECIAL);
      break;
    // 激情小说搜索页面
    case 3:
      JRouter().go(PAGE_NOVEL_SEARCH,
          arguments: {"type": NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL});

      break;
    // 有声小说搜索页面
    case 4:
      JRouter().go(PAGE_NOVEL_SEARCH,
          arguments: {"type": NOVEL_SEARCH_PAGE_TYPE.PAGE_AUDIOBOOK});
      break;
    default:
  }
}

/// 跳转记录页面
void _onRecordingBtm(Action action, Context<DiscoveryTabState> ctx) {
  int tabIndex = ctx.state.tabController.index;
  switch (tabIndex) {

    case 0:

      break;

    case 1:

      JRouter().go(NAKE_CHAT_RECORDING_PAGE);

      break;

    case 2:

      JRouter().go(AV_COMMENTARY_RECORDING_PAGE);


      break;
    case 3:
      JRouter().go(PASSION_RECORDING_PAGE);
      break;
    case 4:
      JRouter().go(PAGE_AUDIOBOOK_RECORD);
      break;
    default:
  }
}



void _initState(Action action, Context<DiscoveryTabState> ctx) {
  if(Config.isAnnounceAvCommentary){
    ctx.state.tabController.animateTo(1);
  }

  ctx.state.tabController.addListener(() {
    int index = ctx.state.tabController.index;
    ctx.dispatch(DiscoveryTabActionCreator.onGetIndex(index));
  });
}
