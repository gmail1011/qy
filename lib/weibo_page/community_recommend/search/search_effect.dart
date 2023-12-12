import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/tag/tag_list_model.dart';
import 'package:flutter_app/page/user/official_community/action.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/hot_recommend_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_action.dart';
import 'search_state.dart';

Effect<SearchState> buildEffect() {
  return combineEffects(<Object, Effect<SearchState>>{
    SearchAction.action: _onAction,
    Lifecycle.initState: _onInitData,
    Lifecycle.dispose: _dispose,
    SearchAction.getHotRecommend: _onHotRecommend,
    SearchAction.onLoadMore: _onLoadMore,
    SearchAction.clearHistory: clear,
  });
}

void _onAction(Action action, Context<SearchState> ctx) {
  int changeCount = action.payload;
  ctx.dispatch(SearchActionCreator.getSubList(ctx.state.xList));
}

void clear(Action action, Context<SearchState> ctx) {
  //int changeCount = action.payload;
  //ctx.dispatch(SearchActionCreator.getSubList(ctx.state.xList));
  ctx.state.prefs.clear();
  ctx.state.searchLists.clear();
  ctx.dispatch(SearchActionCreator.reFresh());
}

void _onInitData(Action action, Context<SearchState> ctx) async {
  ctx.state.prefs = await SharedPreferences.getInstance();
  //ctx.state.searchLists = ctx.state.prefs.getStringList("history");
  List<String> lists =
      ctx.state.prefs.getStringList("history")?.toSet()?.toList();
  ctx.state.searchLists = lists;
  _onHotRecommend(action, ctx);
  _onLoadMore(action, ctx);
}

void _onHotRecommend(Action action, Context<SearchState> ctx) async {
  try {
    TagListModel model = await netManager.client.getTags(1, 40);
    List<TagDetailModel> tagList = <TagDetailModel>[];

    ///只设置了hot
    tagList.addAll(model.hot);
    tagList.addAll(model.newest);
    tagList.addAll(model.playCount);

    List<List<TagDetailModel>> tagListTemp = [];

    for (int i = 0; i < tagList.length; i++) {
      if (i % 6 == 0) {
        if (i + 6 > tagList.length) {
          tagListTemp.add(tagList.sublist(i, tagList.length - 1));
        } else {
          tagListTemp.add(tagList.sublist(i, i + 6));
        }
      }
    }

    ctx.dispatch(SearchActionCreator.getTags(tagListTemp));
  } catch (e) {
    LogUtil.e("d");
  }
}

void _onLoadMore(Action action, Context<SearchState> ctx) async {
  try {
    dynamic commonPostRes =
        await netManager.client.guessLike(1, ctx.state.pageSize);
    GuessLikeData guessLikeData = GuessLikeData().fromJson(commonPostRes);
    guessLikeData.xList.forEach((element1) {
      element1.awards?.forEach((element2) {
        Config.userAwards?.forEach((element3) {
          if (element2 == element3.number) {
            element1.awardsImage?.add(element3.imgUrl);
          }
        });
      });
    });

    ctx.dispatch(SearchActionCreator.guessLike(guessLikeData));
    ctx.state.refreshController?.loadComplete();
    ctx.dispatch(SearchActionCreator.updateGuessLikeList(0));

    // if (pageNumber > 1) {
    //   ctx.state.guessLikeData.xList.addAll(guessLikeData.xList);
    //   ctx.dispatch(SearchActionCreator.guessLike(ctx.state.guessLikeData));
    //   ctx.state.refreshController.refreshCompleted();
    // } else {
    //   ctx.dispatch(SearchActionCreator.guessLike(guessLikeData));
    // }

    // if (guessLikeData.hasNext) {
    //   ctx.state.refreshController.loadComplete();
    // } else {
    //   ctx.state.refreshController.loadNoData();
    // }

  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
}

void _dispose(Action action, Context<SearchState> ctx) {
  ctx.state.refreshController?.dispose();
  ctx.state.textEditingController?.dispose();
}
