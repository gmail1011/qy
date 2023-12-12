import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';
import 'package:flutter_app/page/home/post/page/common_post_detail/SelectedTagsBean.dart';

import 'common_post_detail_action.dart';
import 'common_post_detail_state.dart';

Effect<CommonPostDetailState> buildEffect() {
  return combineEffects(<Object, Effect<CommonPostDetailState>>{
    CommonPostDetailAction.action: _onAction,
    CommonPostDetailAction.loadmore: _onLoadMore,
    Lifecycle.initState: _initState,
  });
}

void _onAction(Action action, Context<CommonPostDetailState> ctx) {
  _onInitData(action, ctx);
}

void _initState(Action action, Context<CommonPostDetailState> ctx) async {
  _onInitData(action, ctx);
}

///初始化数据
Future _onInitData(Action action, Context<CommonPostDetailState> ctx) async {
  try {

    TagsLiaoBaData specialModel = await netManager.client.getTagsList();

    SelectedTagsData selectedTagsData = await netManager.client
        .getTagsListDetail(
            0, 1, "", 0, ctx.state.pageNumber, ctx.state.pageSize);

    TagsLiaoBaDataTags tags = new TagsLiaoBaDataTags();
    tags.id = "0";
    tags.tagName = "全部标签";
    specialModel.tags.insert(0, tags);
    ctx.dispatch(CommonPostDetailActionCreator.setLoading(false));
    ctx.dispatch(CommonPostDetailActionCreator.getTags(specialModel));
    ctx.dispatch(CommonPostDetailActionCreator.getDetails(selectedTagsData));
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    if ((specialModel.tags.length ?? 0) == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.baseRequestController.requestFail();
  }
}

void _onLoadMore(Action action, Context<CommonPostDetailState> ctx) async {
  SelectedTagsBean selectedTagsBean = action.payload;

  SelectedTagsData selectedTagsData = await netManager.client.getTagsListDetail(
      selectedTagsBean.type, selectedTagsBean.model, selectedTagsBean.tag, selectedTagsBean.paymentType, selectedTagsBean.pageNumber, ctx.state.pageSize);


  ctx.dispatch(CommonPostDetailActionCreator.setLoading(false));

  if( selectedTagsData.xList == null ||  selectedTagsData.xList.length == 0){
    if(selectedTagsBean.isSelected && selectedTagsBean.pageNumber == 1){
      ctx.dispatch(CommonPostDetailActionCreator.getDetails(selectedTagsData));
    }else{
      ctx.state.refreshController.loadNoData();
    }

   // ctx.state.baseRequestController.requestDataEmpty();
  }else{

    if(selectedTagsBean.isSelected && selectedTagsBean.pageNumber == 1){
      ctx.dispatch(CommonPostDetailActionCreator.getDetails(selectedTagsData));
    }else{
      ctx.state.selectedTagsData.xList.addAll(selectedTagsData.xList);
      ctx.dispatch(CommonPostDetailActionCreator.getDetails(ctx.state.selectedTagsData));
      ctx.state.refreshController.loadComplete();
    }

  }

}
