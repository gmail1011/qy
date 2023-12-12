import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_data_list_page/action.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/passion_novel_view_page/action.dart';
import 'package:flutter_base/utils/toast_util.dart';
import '../action.dart';
import 'action.dart';
import 'state.dart';

Effect<NovelSearchResultState> buildEffect() {
  return combineEffects(<Object, Effect<NovelSearchResultState>>{
    NovelSearchResultAction.onSubmitted: _onSubmitted,
  });
}

void _onSubmitted(Action action, Context<NovelSearchResultState> ctx) {
  var text = action.payload ?? '';
  if (text == ctx.state.keywords) {
    showToast(msg: "请勿重复搜索");
    return;
  }
  ctx.broadcast(PassionNovelViewActionCreator.onChangeKeyWord(text));
  ctx.broadcast(AudiobookDataListActionCreator.broadcastSearchAction(text));
  ctx.dispatch(NovelSearchResultActionCreator.setKeywords(text));

  ///更新搜索页面历史记录
  ctx.broadcast(NovelSearchActionCreator.broadcastRefreshHistorys(text));
}
