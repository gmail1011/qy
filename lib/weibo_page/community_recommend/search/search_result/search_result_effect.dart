import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/search/search_user_obj.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_video_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_result_action.dart';
import 'search_result_state.dart';

Effect<SearchResultState> buildEffect() {
  return combineEffects(<Object, Effect<SearchResultState>>{
    SearchResultAction.action: _onAction,
    Lifecycle.initState: _onInitData,
    SearchResultAction.setKeyWord: _onAction,
    SearchResultAction.onMovieLoadMore: _onMovieLoadMore,
    SearchResultAction.onVideoLoadMore: _onVideoLoadMore,
    SearchResultAction.onWordLoadMore: _onWordLoadMore,
    SearchResultAction.onUserLoadMore: _onUserLoadMore,
    SearchResultAction.onTopicLoadMore: _onTopicLoadMore,
  });
}

void _onAction(Action action, Context<SearchResultState> ctx) {
  EventTrackingManager().addTagsDatas(ctx.state.textEditingController.text);
  if (ctx.state.tabController.index == 0) {
    Future.delayed(Duration(milliseconds: 100), () {
      _onVideo(action, ctx);
    });
  } else if (ctx.state.tabController.index == 1) {
    Future.delayed(Duration(milliseconds: 100), () {
      _onWord(action, ctx);
    });
  } else if (ctx.state.tabController.index == 2) {
    _onMovie(action, ctx);
  } else if (ctx.state.tabController.index == 3) {
    Future.delayed(Duration(milliseconds: 100), () {
      _onUser(action, ctx);
    });
  } else if (ctx.state.tabController.index == 4) {
    Future.delayed(Duration(milliseconds: 100), () {
      _onTopic(action, ctx);
    });
  }
}

void _onInitData(Action action, Context<SearchResultState> ctx) async {
  ctx.state.prefs = await SharedPreferences.getInstance();

  ctx.state.searchLists = ctx.state.prefs.getStringList(ctx.state.history);
  EventTrackingManager().addTagsDatas(ctx.state.textEditingController.text);
  _onVideoLoadMore(action, ctx);

  ctx.state.tabController.addListener(() {
    if (ctx.state.tabController.index == 1) {
      Future.delayed(Duration(milliseconds: 100), () {
        _onWordLoadMore(action, ctx);
      });
    } else if (ctx.state.tabController.index == 2) {
      Future.delayed(Duration(milliseconds: 100), () {

        _onMovieLoadMore(action, ctx);
      });
    } else if (ctx.state.tabController.index == 3) {
      Future.delayed(Duration(milliseconds: 100), () {
        _onUserLoadMore(action, ctx);
      });
    } else if (ctx.state.tabController.index == 4) {
      Future.delayed(Duration(milliseconds: 100), () {
        _onTopicLoadMore(action, ctx);
      });
    }
  });
}

void _onMovieLoadMore(Action action, Context<SearchResultState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.moviePageNum;
  }

  try {
    dynamic searchMovieDataBean = await netManager.client.getSearchVideo(
        ctx.state.moviePageNum,
        ctx.state.moviePageSize,
        ctx.state.textEditingController.text,
        "MOVIE");

    SearchVideoData searchMovieData =
        SearchVideoData().fromJson(searchMovieDataBean);

    setHistory(ctx);

    if (pageNumber > 1) {
      ctx.state.searchMovieData.xList.addAll(searchMovieData.xList);
      ctx.dispatch(
          SearchResultActionCreator.getMovieData(ctx.state.searchMovieData));
      ctx.state.refreshMovieController.refreshCompleted();
    } else {
      ctx.dispatch(SearchResultActionCreator.getMovieData(searchMovieData));
    }

    if (searchMovieData.hasNext) {
      ctx.state.refreshMovieController.loadComplete();
    } else {
      ctx.state.refreshMovieController.loadNoData();
    }
  } catch (e) {
    ctx.state.refreshMovieController.loadFailed();
  }
}

void _onMovie(Action action, Context<SearchResultState> ctx) async {
  int pageNumber;
  pageNumber = ctx.state.moviePageNum;

  try {
    try {
      dynamic searchMovieDataBean = await netManager.client.getSearchVideo(
          1, action.payload, ctx.state.textEditingController.text, "MOVIE");
      SearchVideoData searchMovieData =
          SearchVideoData().fromJson(searchMovieDataBean);

      setHistory(ctx);

      ctx.dispatch(SearchResultActionCreator.getMovieData(searchMovieData));

      ctx.state.refreshMovieController.scrollController.jumpTo(0);
      if (searchMovieData.hasNext) {
        ctx.state.refreshMovieController.loadComplete();
      } else {
        ctx.state.refreshMovieController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshMovieController.loadFailed();
  }
}

void setHistory(Context<SearchResultState> ctx) {
  try {
    if (ctx.state.searchLists == null) {
      ctx.state.searchLists = [];
    }
    ctx.state.searchLists.add(ctx.state.textEditingController.value.text);
    ctx.state.prefs.setStringList(ctx.state.history, ctx.state.searchLists);
  } catch (e) {
    print(e);
  }
}

void _onVideoLoadMore(Action action, Context<SearchResultState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.moviePageNum;
  }

  try {
    try {
      dynamic searchMovieDataBean = await netManager.client.getSearchVideo(
          ctx.state.videoPageNum,
          ctx.state.videoPageSize,
          ctx.state.textEditingController.text,
          "SP");
      SearchVideoData searchMovieData =
          SearchVideoData().fromJson(searchMovieDataBean);

      setHistory(ctx);

      if (pageNumber > 1) {
        ctx.state.searchVideoData.xList.addAll(searchMovieData.xList);
        ctx.dispatch(
            SearchResultActionCreator.getVideoData(ctx.state.searchVideoData));
        ctx.state.refreshVideoController.refreshCompleted();
      } else {
        ctx.dispatch(SearchResultActionCreator.getVideoData(searchMovieData));
      }

      if (searchMovieData.hasNext) {
        ctx.state.refreshVideoController.loadComplete();
      } else {
        ctx.state.refreshVideoController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshVideoController.loadFailed();
  }
}

void _onVideo(Action action, Context<SearchResultState> ctx) async {
  try {
    dynamic searchMovieDataBean = await netManager.client.getSearchVideo(
        1, ctx.state.videoPageSize, ctx.state.textEditingController.text, "SP");
    SearchVideoData searchMovieData =
        SearchVideoData().fromJson(searchMovieDataBean);

    setHistory(ctx);

    ctx.dispatch(SearchResultActionCreator.getVideoData(searchMovieData));
    ctx.state.refreshVideoController.scrollController.jumpTo(0);
    if (searchMovieData.hasNext) {
      ctx.state.refreshVideoController.loadComplete();
    } else {
      ctx.state.refreshVideoController.loadNoData();
    }
  } catch (e) {
    ctx.state.refreshVideoController.loadFailed();
  }
}

void _onWordLoadMore(Action action, Context<SearchResultState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.wordPageNum;
  }

  try {
    try {
      List<String> keywords = [ctx.state.keyword];

      dynamic searchMovieDataBean = await netManager.client.getSearchVideo(
          ctx.state.wordPageNum,
          ctx.state.wordPageSize,
          ctx.state.textEditingController.text,
          "COVER");
      SearchVideoData searchMovieData =
          SearchVideoData().fromJson(searchMovieDataBean);

      setHistory(ctx);

      if (pageNumber > 1) {
        ctx.state.searchWordData.xList.addAll(searchMovieData.xList);
        ctx.dispatch(
            SearchResultActionCreator.getWordData(ctx.state.searchWordData));
        ctx.state.refreshWordController.refreshCompleted();
      } else {
        ctx.dispatch(SearchResultActionCreator.getWordData(searchMovieData));
      }

      if (searchMovieData.hasNext) {
        ctx.state.refreshWordController.loadComplete();
      } else {
        ctx.state.refreshWordController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshWordController.loadFailed();
  }
}

void _onWord(Action action, Context<SearchResultState> ctx) async {
  try {
    try {
      List<String> keywords = [ctx.state.textEditingController.text];

      dynamic searchMovieDataBean = await netManager.client
          .getSearchVideo(1, ctx.state.wordPageSize, action.payload, "COVER");
      SearchVideoData searchMovieData =
          SearchVideoData().fromJson(searchMovieDataBean);

      setHistory(ctx);

      ctx.dispatch(SearchResultActionCreator.getWordData(searchMovieData));
      ctx.state.refreshWordController.scrollController.jumpTo(0);
      if (searchMovieData.hasNext) {
        ctx.state.refreshWordController.loadComplete();
      } else {
        ctx.state.refreshWordController.loadNoData();
      }
    } catch (e) {}
  } catch (e) {
    ctx.state.refreshWordController.loadFailed();
  }
}

void _onUserLoadMore(Action action, Context<SearchResultState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.userPageNum;
  }

  try {
    List<String> keywords = [ctx.state.textEditingController.text];

    dynamic user = await netManager.client
        .getSearchDataNew(pageNumber, ctx.state.userPageSize, keywords, "user");

    SearchBeanData searchBeanData = SearchBeanData().fromJson(user);

    setHistory(ctx);

    if (pageNumber > 1) {
      ctx.state.searchBeanData.xList.addAll(searchBeanData.xList);
      ctx.dispatch(
          SearchResultActionCreator.getUserData(ctx.state.searchBeanData));
      ctx.state.refreshUserController.loadComplete();
    } else {
      ctx.dispatch(SearchResultActionCreator.getUserData(searchBeanData));
      ctx.state.refreshUserController.loadComplete();
    }

    if (searchBeanData.hasNext) {
      ctx.state.refreshUserController.loadComplete();
    } else {
      ctx.state.refreshUserController.loadNoData();
    }
  } catch (e) {}
}

void _onUser(Action action, Context<SearchResultState> ctx) async {
  try {
    List<String> keywords = [ctx.state.textEditingController.text];

    dynamic user = await netManager.client
        .getSearchDataNew(1, ctx.state.userPageSize, keywords, "user");

    SearchBeanData searchBeanData = SearchBeanData().fromJson(user);

    setHistory(ctx);

    ctx.dispatch(SearchResultActionCreator.getUserData(searchBeanData));
    ctx.state.refreshUserController.loadComplete();
    ctx.state.refreshUserController.scrollController.jumpTo(0);
    if (searchBeanData.hasNext) {
      ctx.state.refreshUserController.loadComplete();
    } else {
      ctx.state.refreshUserController.loadNoData();
    }
  } catch (e) {}
}

void _onTopicLoadMore(Action action, Context<SearchResultState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.topicPageNum;
  }

  try {
    List<String> keywords = [ctx.state.textEditingController.text];

    dynamic user = await netManager.client
        .getSearchDataNew(pageNumber, ctx.state.topicPageSize, keywords, "tag");

    SearchTopicData searchBeanData = SearchTopicData().fromJson(user);

    setHistory(ctx);

    if (pageNumber > 1) {
      ctx.state.searchBeanDataTopic.xList.addAll(searchBeanData.xList);
      ctx.dispatch(SearchResultActionCreator.getTopicData(
          ctx.state.searchBeanDataTopic));
      ctx.state.refreshTopicController.loadComplete();
    } else {
      ctx.dispatch(SearchResultActionCreator.getTopicData(searchBeanData));
      ctx.state.refreshTopicController.loadComplete();
    }

    if (searchBeanData.hasNext) {
      ctx.state.refreshTopicController.loadComplete();
    } else {
      ctx.state.refreshTopicController.loadNoData();
    }
  } catch (e) {}
}

void _onTopic(Action action, Context<SearchResultState> ctx) async {
  try {
    List<String> keywords = [ctx.state.textEditingController.text];

    dynamic user = await netManager.client
        .getSearchDataNew(1, ctx.state.topicPageSize, keywords, "tag");

    SearchTopicData searchBeanData = SearchTopicData().fromJson(user);

    setHistory(ctx);

    ctx.dispatch(SearchResultActionCreator.getTopicData(searchBeanData));
    ctx.state.refreshTopicController.loadComplete();
    ctx.state.refreshTopicController.scrollController.jumpTo(0);
    if (searchBeanData.hasNext) {
      ctx.state.refreshTopicController.loadComplete();
    } else {
      ctx.state.refreshTopicController.loadNoData();
    }
  } catch (e) {}
}
