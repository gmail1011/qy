import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/page/home/post/page/common_post_detail/SelectedTagsBean.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/action.dart';
import 'package:flutter_base/utils/log.dart';

import 'SelectedBean.dart';
import 'common_post_detail_action.dart';
import 'common_post_detail_state.dart';

Effect<common_post_detailState> buildEffect() {
  return combineEffects(<Object, Effect<common_post_detailState>>{
    common_post_detailAction.action: _onAction,
    Lifecycle.initState: _onInitData,
    common_post_detailAction.selectedData: _onSelectedData,
  });
}

void _onAction(Action action, Context<common_post_detailState> ctx) {}

void _onInitData(Action action, Context<common_post_detailState> ctx) async {
  String tagID = ctx.state.id;
  try {
    LiaoBaTagsDetailData tagListModel =
        await netManager.client.requestSelectedTagListData(1, 20, tagID,"hot",0);

    ctx.dispatch(common_post_detailActionCreator.onInitData(tagListModel));

    if(tagListModel.hasNext){
      ctx.state.refreshController.loadComplete();
    }else{
      ctx.state.refreshController.loadNoData();
    }

  } catch (e) {
    l.d('requestTagListData', e.toString());
    if (ctx.context == null) return;
    //ctx.dispatch(common_post_detailActionCreator.onError(Lang.SERVER_ERROR));
  }
}

void _onSelectedData(
    Action action, Context<common_post_detailState> ctx) async {
  String tagID = ctx.state.id;
  try {
    SelectedBean selectedTagsBean = action.payload;
    LiaoBaTagsDetailData tagListModel = await netManager.client
        .requestSelectedTagListData(selectedTagsBean.pageNumber, ctx.state.pageSize,
            tagID, selectedTagsBean.sortType, selectedTagsBean.playTimeType);

    if(tagListModel.hasNext){
      if(selectedTagsBean.isSelected && selectedTagsBean.pageNumber == 1){
        ctx.dispatch(common_post_detailActionCreator.onInitData(tagListModel));
        ctx.state.scrollController.jumpTo(0);
      }else{
        ctx.state.liaoBaHistoryData.videos.addAll(tagListModel.videos);
        ctx.dispatch(common_post_detailActionCreator.onInitData(ctx.state.liaoBaHistoryData));
      }


      ctx.state.refreshController.loadComplete();
    }else{
      ctx.state.refreshController.loadNoData();
    }

  } catch (e) {
    l.d('requestTagListData', e.toString());
    if (ctx.context == null) return;
    //ctx.dispatch(common_post_detailActionCreator.onError(Lang.SERVER_ERROR));
  }
}
