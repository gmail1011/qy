import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';

import 'topic_detail_action.dart';
import 'topic_detail_state.dart';

Effect<TopicDetailState> buildEffect() {
  return combineEffects(<Object, Effect<TopicDetailState>>{
    TopicDetailAction.action: _onAction,
    Lifecycle.initState: _onInitData,
    TopicDetailAction.onLoadMore: _onLoadMore,
    TopicDetailAction.onVideoLoadmore: _onVideoLoadMore,
    TopicDetailAction.onMovieLoadmore: _onMovieLoadMore,
  });
}

void _onAction(Action action, Context<TopicDetailState> ctx) async {
  String tagID = ctx.state.tagsBean.id;
  try {
    TagDetailModel tagDetailModel = await netManager.client.getTagDetail(tagID);
    ctx.dispatch(
        TopicDetailActionCreator.setCollect(tagDetailModel.hasCollected));

    ctx.dispatch(
        TopicDetailActionCreator.onGetPlayCount(tagDetailModel.playCount));
  } catch (e) {
    //l.d('getTagDetail', e.toString());
    //ctx.dispatch(TagActionCreator.onError(Lang.SERVER_ERROR));
  }
}

void _onInitData(Action action, Context<TopicDetailState> ctx) async {
  _onAction(action, ctx);
  _onVideoLoadMore(action, ctx);

  ctx.state.tabController.addListener(() {
    if (ctx.state.tabController.index == 1) {
      Future.delayed(Duration(milliseconds: 30), () {
        //_onVideoLoadMore(action, ctx);

      });
    }else if(ctx.state.tabController.index == 2){
      Future.delayed(Duration(milliseconds: 30), () {
        _onMovieLoadMore(action, ctx);
      });
    }
  });
  _onLoadMore(action, ctx);
  EventTrackingManager().addTagsDatas(ctx.state.tagsBean.name);
  AnalyticsEvent.clickToTag(ctx.state.tagsBean.name, ctx.state.tagsBean.id);
}

void _onLoadMore(Action action, Context<TopicDetailState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.pageNumber;
  }

  try {
    try {
      TagBean tagBean = await netManager.client.requestTagListData(
        pageNumber,
        14,
        ctx.state.tagsBean.id,
        sortType: "COVER",
      );
      //ctx.state.isCollected = tagBean.;

      tagBean.list.removeWhere((element) => element.newsType == "SP");

      if (pageNumber > 1) {
        ctx.state.tagBean.list.addAll(tagBean.list);
        ctx.dispatch(TopicDetailActionCreator.onGetData(ctx.state.tagBean));
        ctx.state.refreshController.refreshCompleted();
      } else {
        ctx.dispatch(TopicDetailActionCreator.onGetData(tagBean));
      }

      if (tagBean.hasNext) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }
  ctx.state.refreshController.refreshCompleted();
}

void _onVideoLoadMore(Action action, Context<TopicDetailState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.pageVideoNumber;
  }

  try {
    try {
      TagBean tagBean = await netManager.client
          .requestTopicDetail(pageNumber, 14, ctx.state.tagsBean.id, "SP");

      if (pageNumber > 1) {
        ctx.state.tagVideoBean.list.addAll(tagBean.list);
        ctx.dispatch(
            TopicDetailActionCreator.onGetVideoData(ctx.state.tagVideoBean));
        ctx.state.refreshVideoController.refreshCompleted();
      } else {
        ctx.dispatch(TopicDetailActionCreator.onGetVideoData(tagBean));
      }

      if (tagBean.hasNext) {
        ctx.state.refreshVideoController.loadComplete();
      } else {
        ctx.state.refreshVideoController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshVideoController.loadFailed();
  }
}


void _onMovieLoadMore(Action action, Context<TopicDetailState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.pageMovieNumber;
  }

  try {
    try {
      TagBean tagBean = await netManager.client
          .requestTopicDetail(pageNumber, 14, ctx.state.tagsBean.id, "MOVIE");

      if (pageNumber > 1) {
        ctx.state.tagMovieBean.list.addAll(tagBean.list);
        ctx.dispatch(
            TopicDetailActionCreator.onGetMovieData(ctx.state.tagMovieBean));
        ctx.state.refreshMovieController.refreshCompleted();
      } else {
        ctx.dispatch(TopicDetailActionCreator.onGetMovieData(tagBean));
      }

      if (tagBean.hasNext) {
        ctx.state.refreshMovieController.loadComplete();
      } else {
        ctx.state.refreshMovieController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshMovieController.loadFailed();
  }
}
