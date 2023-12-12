import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/search_default_entity.dart';
import 'package:flutter_app/model/search_default_hot_blogger_entity.dart';
import 'package:flutter_app/model/tag/hot_tag_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<SearchState> buildEffect() {
  return combineEffects(<Object, Effect<SearchState>>{
    Lifecycle.initState: _init,
    SearchAction.onSubmitted: _onSubmitted,
    SearchAction.delete: _delete,
    SearchAction.deleteAll: _deleteAll,
    SearchAction.broadcastRefreshHistorys: _broadcastRefreshHistorys,
  });
}

void _broadcastRefreshHistorys(Action action, Context<SearchState> ctx) {
  var text = action.payload;
  if (TextUtil.isEmpty(text)) {
    return;
  }
  var state = ctx.state;
  //如果超出最大個數
  if (state.searchHistorys.length >= ctx.state.maxSearchHistoryNum) {
    state.searchHistorys.removeLast();
  }
  //如果包含該條記錄
  if (state.searchHistorys.contains(text)) {
    state.searchHistorys.remove(text);
  }
  state.searchHistorys.insert(0, text);
  _save(ctx, state.searchHistorys);
}

void _deleteAll(Action action, Context<SearchState> ctx) {
  var state = ctx.state.clone();
  state.searchHistorys.clear();
  _save(ctx, ctx.state.searchHistorys);
}

void _delete(Action action, Context<SearchState> ctx) {
  var index = (action.payload as int) ?? 0;

  ctx.state.searchHistorys.removeAt(index);
  _save(ctx, ctx.state.searchHistorys);
}

void _save(Context<SearchState> ctx, List<String> list) {
  lightKV.setStringList("searchHistoryKey", list);
  ctx.dispatch(SearchActionCreator.onRefreshHistorys(list));
}

void _onSubmitted(Action action, Context<SearchState> ctx) {
  var text = (action.payload as String) ?? '';
  if (TextUtil.isEmpty(text)) {
    showToast(msg: "请输入搜索内容");
    return;
  }
  var state = ctx.state;
  //如果超出最大個數
  if (state.searchHistorys.length >= ctx.state.maxSearchHistoryNum) {
    state.searchHistorys.removeLast();
  }
  //如果包含該條記錄
  if (state.searchHistorys.contains(text)) {
    state.searchHistorys.remove(text);
  }
  state.searchHistorys.insert(0, text);
  _save(ctx, state.searchHistorys);
  Map<String, dynamic> map = {"keywords": text ?? ''};
  JRouter().go(PAGE_SEARCH_RESULT, arguments: map);
}

Future<List<String>> _getSearchHistorys() async {
  return (await lightKV.getStringList("searchHistoryKey")) ?? <String>[];
}

void _init(Action action, Context<SearchState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    _getHistorys(action, ctx);
    // _getTag(action, ctx);
    _getHotTag(action, ctx);
    // dynamic model = await netManager.client.getSearchDefault();

    dynamic hotBlogger = await netManager.client.getSearchDefaultBlogger();

    // SearchDefaultData searchDefaultData = SearchDefaultData().fromJson(model);

    // ctx.dispatch(SearchActionCreator.onGetHotSearchList(searchDefaultData));

    SearchDefaultHotBloggerData searchDefaultHotBloggerData = SearchDefaultHotBloggerData().fromJson(hotBlogger);

    ctx.dispatch(SearchActionCreator.onGetHotSearchBlogger(searchDefaultHotBloggerData));

    List<AdsInfoBean> adsList = await getAdvByType(11);
    ctx.dispatch(SearchActionCreator.getAdList(adsList));
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _getHistorys(Action action, Context<SearchState> ctx) async {
  var list = await _getSearchHistorys();
  ctx.dispatch(SearchActionCreator.onRefreshHistorys(list));
}

void _getTag(Action action, Context<SearchState> ctx) async {
  try {
    var model = await netManager.client.getTags(1);
    var tagList = <TagDetailModel>[];
    tagList.addAll(model.hot);
    tagList.addAll(model.newest);
    tagList.addAll(model.playCount);
    ctx.dispatch(SearchActionCreator.onRefreshTag(tagList));
    ctx.state.baseRequestController.requestSuccess();
  } catch (e) {
    ctx.state.baseRequestController.requestSuccess();
    l.e("search_label_page", ":$e");
  }
}


Future _getHotTag(Action action, Context<SearchState> ctx) async {
  try {
    var model = await netManager.client.getHotTags();
    ctx.state.hotList.addAll(model.list);
    ctx.dispatch(SearchActionCreator.updateUI());
    ctx.state.baseRequestController.requestSuccess();
  } catch (e) {
    ctx.state.hotList= [];
  }
}
