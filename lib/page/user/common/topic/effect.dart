import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_paged_list.dart';
import 'package:flutter_app/page/setting/my_favorite/action.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<TopicState> buildEffect() {
  return combineEffects(<Object, Effect<TopicState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    TopicAction.refresh: _initState,
    TopicAction.loadMore: _onLoadMoreData,
    MyFavoriteAction.changeEditState: _changeEditState,
    MyFavoriteAction.clearEditState: _clearEditState,
    TopicAction.delCollectTag: _delCollectTag,
    TopicAction.collectBatch: collectBatch,
    TopicAction.clickCollectTag: _clickCollectTag,
  });
}

void _initState(Action action, Context<TopicState> ctx) async {
  ctx.state.pageNumer = 1;
  _loadTagData(ctx);
}

///请求话题列表
void _loadTagData(Context<TopicState> ctx) async {
  try {
    Map<String, dynamic> mapList = {};
    mapList['type'] = 'tag';
    mapList['pageNumber'] = ctx.state.pageNumer;
    mapList['pageSize'] = ctx.state.pageSize;
    mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
    BaseResponse res =
        await HttpManager().get(Address.MY_FAVORITE, params: mapList);
    if (res.code == 200) {
      PagedList list = PagedList.fromJson(res.data);
      ctx.state.hasNext = res.data["hasNext"] ?? false;

      List<TagDetailModel> modelList = TagDetailModel.toList(list.list);
      if (ctx.state.pageNumer == 1) {
        ctx.state.tagModelList?.clear();
      }

      if ((modelList ?? []).isNotEmpty) {
        ctx.state.tagModelList.addAll(modelList);
        ctx.state.requestController?.requestSuccess();

        if (ctx.state.pageNumer == 1) {
          ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
        } else {
          ctx.state.refreshController?.loadComplete();
        }
      } else {
        if (ctx.state.tagModelList?.isEmpty ?? false) {
          ctx.state.requestController.requestDataEmpty();
        } else {
          ctx.state.refreshController.loadNoData();
        }
      }
    } else {
      if (ctx.state.tagModelList?.isEmpty ?? false) {
        ctx.state.requestController?.requestFail();
      } else {
        ctx.state.refreshController?.loadFailed();
      }
    }
  } catch (e) {
    l.d("_picListReq-error", "$e");
    if (ctx.state.tagModelList?.isEmpty ?? false) {
      ctx.state.requestController.requestFail();
    } else {
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(TopicActionCreator.updateUI());
}

///加载更多话题数据
void _onLoadMoreData(Action action, Context<TopicState> ctx) async {
  if (ctx.state.pageNumer * ctx.state.pageSize <=
      ctx.state.tagModelList?.length) {
    ctx.state.pageNumer = ctx.state.pageNumer + 1;
    _loadTagData(ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

void _changeEditState(Action action, Context<TopicState> ctx) {
  int index = action.payload as int;
  print("话题编辑状态-$index");
  if (index == 3) {
    bool isTagEditState = ctx.state.isTagEditModel;
    ctx.state.isTagEditModel = !isTagEditState;
    ctx.dispatch(TopicActionCreator.updateUI());
  }
}

void _clearEditState(Action action, Context<TopicState> ctx) {
  int index = action.payload as int;
  print("话题编辑状态-$index");
  if (index != 3 && ctx.state.isTagEditModel ?? false) {
    ctx.state.isTagEditModel = false;
    ctx.dispatch(TopicActionCreator.updateUI());
  }
}

///删除话题
void _delCollectTag(Action action, Context<TopicState> ctx) async {
  try {
    WBLoadingDialog.show(ctx.context);
    String tagID = action.payload as String;
    await netManager.client.changeTagStatus(tagID, false, "tag");
    await Future.delayed(Duration(milliseconds: 200));
    _loadTagData(ctx);

    showToast(msg: "删除成功~");
    WBLoadingDialog.dismiss(ctx.context);
  } catch (e) {
    //showToast(msg: e.toString());
    l.d("_delCollectTag-error", "$e");
    WBLoadingDialog.dismiss(ctx.context);
  }
}

///批量删除操作
void collectBatch(Action action, Context<TopicState> ctx) async {
    try {
      WBLoadingDialog.show(ctx.context);
      List<String> videoIds = action.payload;
      var response = await netManager.client.collectBatch(videoIds, "tag",false);
      l.d("_collectVideo-response:", "$response");
      await Future.delayed(Duration(milliseconds: 500));
      _loadTagData(ctx);
      showToast(msg: "删除成功~");
      WBLoadingDialog.dismiss(ctx.context);

    } catch (e) {
      showToast(msg: "删除视频失败:$e");
      WBLoadingDialog.dismiss(ctx.context);
    }
}

///收藏-取消收藏话题
void _clickCollectTag(Action action, Context<TopicState> ctx) async {
  //objID
  try {
    Map params = action.payload as Map;
    String tagID = params["tagID"];
    bool collected = params["collected"] ?? false;
    await netManager.client.changeTagStatus(tagID, !collected, "tag");
    ctx.state.tagModelList?.forEach((element) {
      if(tagID == element.id) {
        element.hasCollected = !element.hasCollected;
      }
    });
    ctx.dispatch(TopicActionCreator.updateUI());
  } catch (e) {
    l.d("收藏-取消收藏话题", "$e");
  }
}

void _dispose(Action action, Context<TopicState> ctx) async {
  WBLoadingDialog.dismiss(ctx.context);
  ctx.state.tagModelList?.clear();
  ctx.state.tagModelList = null;
  ctx.state.requestController = null;

  ctx.state.refreshController?.dispose();
}
