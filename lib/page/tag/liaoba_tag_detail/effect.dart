import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';

import '../../../common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

///Effect 常用于定义 网络数据请求，或是界面点击事件等非数据操作
Effect<TagState> buildEffect() {
  return combineEffects(<Object, Effect<TagState>>{
   // Lifecycle.initState: _refreshData,
    Lifecycle.dispose: _dispose,
    TagAction.onRefresh: _refreshData,
    TagAction.onLoadMore: _loadMoreData,
  });
}

_refreshData(Action action, Context<TagState> ctx) async {
  ctx.state.pageNumber = 1;
  _loadVideoData(action, ctx);
}

_loadMoreData(Action action, Context<TagState> ctx) async {
  if (ctx.state.pageNumber * ctx.state.pageSize <=
      ctx.state.videoModelList.length) {
    ctx.state.pageNumber = ctx.state.pageNumber + 1;
    _loadVideoData(action, ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

_loadVideoData(Action action, Context<TagState> ctx) async {
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  String tagID = ctx.state.tagId;

  try {
    LiaoBaTagsDetailData tagListModel = await netManager.client
        .requestSelectedTagListData(pageNumber, pageSize, tagID, "new", 1);

    if ((tagListModel.videos ?? []).isNotEmpty) {
      if (pageNumber == 1) {
        ctx.state.videoModelList.clear();
      }
      List<LiaoBaTagsDetailDataVideos> lists = [];
      tagListModel.videos.forEach((element) {
        LiaoBaTagsDetailDataVideos video = element;
        // LiaoBaTagsDetailDataVideos video = VideoModel.fromJson(element.toJson());
        lists.add(video);
      });
      ctx.state.videoModelList?.addAll(lists);
      ctx.state.baseRequestController?.requestSuccess();

      if (pageNumber == 1) {
        ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
      } else {
        ctx.state.refreshController?.loadComplete();
      }
    } else {
      if (ctx.state.videoModelList?.isEmpty ?? false) {
        ctx.state.baseRequestController.requestDataEmpty();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    }
  } catch (e) {
    if (ctx.state.videoModelList?.isEmpty ?? false) {
      ctx.state.baseRequestController.requestFail();
    } else {
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(TagActionCreator.updateUI());
}

_dispose(Action action, Context<TagState> ctx) async {
  ctx.state.videoModelList?.clear();
  ctx.state.videoModelList = null;
  ctx.state.baseRequestController = null;

  ctx.state.refreshController?.dispose();
  ctx.state.scrollController?.dispose();
}
