import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/location_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/location_bean.dart';
import 'package:flutter_app/common/manager/event_manager.dart';
import 'package:flutter_app/model/new_video_model_entity.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/page/common_post_detail/SelectedTagsBean.dart';
import 'package:flutter_app/page/home/post/post_item_component/action.dart';
import 'package:flutter_app/page/home/post/post_item_component/post_item_widget.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/page/web/h5plugin/action.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';

import '../../action.dart';
import 'SelectedTagsDetailBean.dart';
import 'action.dart';
import 'state.dart';

Effect<CommonPostTagsState> buildEffect() {
  return combineEffects(<Object, Effect<CommonPostTagsState>>{
    Lifecycle.initState: _initState,
    CommonPostAction.onLoadMore: _onLoadMore,
    //CommonPostAction.setLoadMoreData: _onLoadMore,
    CommonPostAction.onInit: _onInitStateData,
    PostItemAction.tellFatherJumpPage: _onJumpToVideoPlayList,
    CommonPostAction.onRefreshFollowStatus: _onRefreshFollowStatus,
    CommonPostAction.onListenerRefreshData: _onListenerRefreshData,
    CommonPostAction.tagClick: _onTagPage,
    //CommonPostAction.selectDataDetail: _onSelectData,
    CommonPostAction.selectBean: _onSelectData,
  });
}

void _onListenerRefreshData(Action action, Context<CommonPostTagsState> ctx) {
  var index = action.payload;
  if (index.toString() == ctx.state.type) {
    ctx.dispatch(CommonPostActionCreator.onInit());
  }
}

///进入标签页
_onTagPage(Action action, Context<CommonPostTagsState> ctx) {
  var item = action.payload as ListBeanSp;
  Map<String, dynamic> maps = Map();
  maps['tagId'] = item.tagId;
  JRouter().go(PAGE_TAG, arguments: maps);
}

void _onRefreshFollowStatus(Action action, Context<CommonPostTagsState> ctx) {
 /* Map<String, dynamic> map = action.payload;
  int uid = map['uid'];
  bool isUpdate = false;
  for (var value in ctx.state.dayItems) {
    if ((ctx.state.type == "3" ? value.newVideoModel[0].publisher.uid : value.videoModel.publisher.uid) == uid &&
        (ctx.state.type == "3" ? value.newVideoModel[0].publisher.hasFollowed : value.videoModel.publisher.hasFollowed) != map['isFollow']) {
      PostItemState newState = value.clone();
      isUpdate = true;
      newState.isShowPopoverUnFollowBtn = map['isFollow'];
      if(ctx.state.type == "3"){
        newState.newVideoModel[0].publisher.hasFollowed = map['isFollow'];
      }else{
        newState.videoModel.publisher.hasFollowed = map['isFollow'];
      }
      ctx.state.dayItems[ctx.state.dayItems.indexOf(value)] = newState;
    }
  }
  if (isUpdate) {
    ctx.dispatch(CommonPostActionCreator.refreshFollowStatus(action.payload));
  }*/
}

void _initState(Action action, Context<CommonPostTagsState> ctx) async{

  //var list = await getAdsByType(AdsType.msgType);
  //ctx.dispatch(CommonPostActionCreator.getAdsSuccess(list ?? []));

  Future.delayed(Duration(milliseconds: 200), () async {
    _onLoadData(action, ctx);
    //_onSelectData(action, ctx);
    //var list = await getAdsByType(AdsType.msgType);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });



  //_onInitStateData(action, ctx);
}


///初始化数据
Future _onLoadData(Action action, Context<CommonPostTagsState> ctx) async {
  try {
    List<TagsDetailDataSections> specialModels = await netManager.client.getTagsDetails(Config.homeDataTags[ctx.state.index].id, ctx.state.pageSize,ctx.state.pageNumber);

    if(ctx.state.pageNumber == 1){
      ctx.dispatch(CommonPostActionCreator.initListSuccess(specialModels));
      //ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    }else{

      if(specialModels.length == 0){

        ctx.dispatch(CommonPostActionCreator.initListSuccess(ctx.state.tagsDetails));

        //ctx.state.refreshController.loadNoData();

      }else{
        ctx.state.tagsDetails.addAll(specialModels);
        ctx.dispatch(CommonPostActionCreator.initListSuccess(ctx.state.tagsDetails));
        //ctx.state.refreshController.loadComplete();
      }

    }


   // if ((specialModels.length ?? 0) == 0) {
      //ctx.state.baseRequestController.requestDataEmpty();
    //} else {
        ctx.state.baseRequestController.requestSuccess();
   // }
  } catch (e) {
    ctx.state.refreshController.refreshFailed();
    ctx.state.baseRequestController.requestFail();
    l.e("getGroup", e);
  }
}

// 获取服务器时间
Future<String> _getReqDate() async {
  String reqDate;
  try {
    reqDate = (await netManager.client.getReqDate()).sysDate;
  } catch (e) {
    l.e("tag", "_onRefresh()...error:$e");
  }
  if (TextUtil.isEmpty(reqDate)) {
    reqDate = (await netManager.getFixedCurTime().toString());
  }
  return reqDate;
}

void _onInitStateData(Action action, Context<CommonPostTagsState> ctx) async {
  /*String reqDate = await _getReqDate();
  ctx.state.reqDate = reqDate;
  int pageSize = ctx.state.pageSize;
  String type = ctx.state.type;
  String subType = ctx.state.subType;
  String city;
  String version = "";
  if (ctx.state.type == '2') {
    //同城
    LocationBean location = await LocationModel().getLocation();
    city = location?.city ?? "";
  }
  if (ctx.state.type == "3") {
    version = "1.0.0";
  }
  try {
    var commonPostRes = await netManager.client
        .getPostList(1, pageSize, type, subType, reqDate, city, version);

    //发送加载完成事件
    GlobalVariable.eventBus.fire(PostLoadOriginEvent(2));
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    if (!commonPostRes.hasNext) {
      ctx.state.refreshController.loadNoData();
    }
    if ((commonPostRes.list.length ?? 0) == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }
    if (ctx.state.type == "3") {
      ctx.dispatch(CommonPostActionCreator.initListSuccess(
          handlePostDataNew(commonPostRes.list, ctx)));
    } else {
      ctx.dispatch(CommonPostActionCreator.initListSuccess(
          handlePostData(commonPostRes.list, ctx)));
    }
  } catch (e) {
    l.d('getPostList', e.toString());
    //发送加载完成事件
    GlobalVariable.eventBus.fire(PostLoadOriginEvent(2));
    ctx.state.baseRequestController.requestFail();
    ctx.state.refreshController.refreshFailed();
  }*/


  _onLoadData(action, ctx);
}

void _onLoadMore(Action action, Context<CommonPostTagsState> ctx) async {

  _onLoadData(action, ctx);

  /*int pageNumber = ctx.state.pageNumber + 1;
  int pageSize = ctx.state.pageSize;
  String type = ctx.state.type;
  String subType = ctx.state.subType;
  String reqDate = ctx.state.reqDate ?? await _getReqDate();
  String city;
  String version = "";
  if (ctx.state.type == '2') {
    //同城
    LocationBean location = await LocationModel().getLocation();
    city = location?.city ?? "";
  }
  if (ctx.state.type == "3") {
    version = "1.0.0";
  }
  try {
    var commonPostRes = await netManager.client
        .getPostList(pageNumber, pageSize, type, subType, reqDate, city,version);

    if (ctx.state.type == "3") {
      ctx.dispatch(CommonPostActionCreator.loadMoreSuccess(
          handlePostDataNew(commonPostRes.list, ctx)));
    } else {
      ctx.dispatch(CommonPostActionCreator.loadMoreSuccess(
          handlePostData(commonPostRes.list, ctx)));
    }
    if (commonPostRes.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    l.d('getPostList', e.toString());
    ctx.state.refreshController.loadFailed();
  }*/

  /*try {
    var number = ctx.state.pageNumber + 1;
    var specialModel = await netManager.client.getGroup(number, ctx.state.pageSize);
    ctx.dispatch(CommonPostActionCreator.setLoadMoreData(specialModel.list));
    if (specialModel.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    ctx.state.refreshController.loadFailed();
  }*/
}

///数据处理方法
List<PostItemState> handlePostData(
    List<VideoModel> list, Context<CommonPostTagsState> ctx) {
  List<PostItemState> items = [];
  for (int i = 0; i < list?.length ?? 0; i++) {
    VideoModel videoModel = list[i];
    PostItemState itemState = PostItemState(
        videoModel: videoModel, postFrom: PostFrom.POST, type: ctx.state.type);
    //判断当前发布者id 是否是自己
    if (GlobalStore.isMe(videoModel.publisher.uid)) {
      itemState.isShowFollowBtn = false;
    }
    itemState.isShowFullButton = videoModel.title.length > itemState.maxLength;

    items.add(itemState);
  }
  return items;
}

///数据处理方法 newVideoModel
List<PostItemState> handlePostDataNew(list, Context<CommonPostTagsState> ctx) {
  List<PostItemState> items = [];
  for (int i = 0; i < list?.length ?? 0; i++) {
    List<VideoModel> newVideoModel = list[i];
    PostItemState itemState = PostItemState(
        newVideoModel: newVideoModel,
        postFrom: PostFrom.POST,
        type: ctx.state.type);
    //判断当前发布者id 是否是自己
    if (GlobalStore.isMe(newVideoModel[0].publisher.uid)) {
      itemState.isShowFollowBtn = false;
    }
    itemState.isShowFullButton =
        newVideoModel[0].title.length > itemState.maxLength;

    items.add(itemState);
  }
  return items;
}

void _onJumpToVideoPlayList(Action action, Context<CommonPostTagsState> ctx) async {
  l.i("post", "_onJumpToVideoPlayList()...POST");
  /*PostItemState itemState = action.payload;
  var index =
      ctx.state.dayItems.indexWhere((it) => it.uniqueId == itemState.uniqueId);
  String tagName = "";
  if (ctx.state.type == "0") {
    tagName = "最新";
  } else if (ctx.state.type == "1") {
    tagName = "推荐"; //最热
  } else if (ctx.state.type == "2") {
    tagName = "同城";
  } else if (ctx.state.type == "3") {
    tagName = "付费";
  }
  eagleClick(ctx.state.selfId(),
      sourceId: ctx.state.eagleId(ctx.context), label: "$tagName$index");
  Map<String, dynamic> param = Map();
  param["pageSize"] = ctx.state.pageSize;
  param["playType"] = VideoPlayConfig.VIDEO_POST;
  param["apiAddress"] = Address.COMMUNITY_LIST_TOPIC;
  param["pageNumber"] = ctx.state.pageNumber;
  param["requestparames"] = {
    "type": ctx.state.type,
    "subtype": ctx.state.subType
  };
  param["currentPosition"] = index;
  if(ctx.state.type == "3"){
    //param['videoList'] = ctx.state.dayItems.map((it) => it.newVideoModel[Config.liaoBaYuanChuangTempIndex]).toList();
   // param['videoList'] = ctx.state.dayItems.map((it) => Config.newVideoModel[Config.liaoBaYuanChuangTempIndex]).toList();
    param['videoList'] = Config.newVideoModel;
    param["currentPosition"] = Config.liaoBaYuanChuangTempIndex;
  } else {
    param['videoList'] = ctx.state.dayItems.map((it) => it.videoModel).toList();
  }
  JRouter().go(SUB_PLAY_LIST, arguments: param);*/
}


void _onSelectData(Action action, Context<CommonPostTagsState> ctx) async {

  SelectedTagsDetailBean selectedTagsBean;

  if(action.payload != null){
     selectedTagsBean = action.payload;
  }else{

    selectedTagsBean = new SelectedTagsDetailBean();
    selectedTagsBean.pageNumber = 1;
    selectedTagsBean.type = 0;
    selectedTagsBean.model = 1;
    selectedTagsBean.isSelected = true;
    selectedTagsBean.paymentType = 0;

    Config.tagsLiaoBaData.tags.forEach((element) {
      if(element.tagName.contains(Config.homeDataTags[ctx.state.index].subModuleName)){
        selectedTagsBean.tag = element.id;
      }
    });

    if(Config.homeDataTags[ctx.state.index].subModuleName.contains("日韩")){
      selectedTagsBean.tag = "5f00cf5f84b09831ae63826a";
    }

  }


  SelectedTagsData selectedTagsData = await netManager.client.getTagsListDetail(
      selectedTagsBean.type, selectedTagsBean.model, selectedTagsBean.tag, selectedTagsBean.paymentType, selectedTagsBean.pageNumber, ctx.state.pageSize);


  ctx.dispatch(CommonPostActionCreator.onSetLoading(false));


  if(selectedTagsBean.pageNumber == 1){
    ctx.dispatch(CommonPostActionCreator.onSelectedDataDetail(selectedTagsData));
    if(selectedTagsData.hasNext){
      ctx.state.refreshController.loadComplete();
    }else{
      ctx.state.refreshController.loadNoData();
    }
  }else{

    if(selectedTagsData.xList == null){
      ctx.state.refreshController.loadNoData();
    }else{
      ctx.state.selectedTagsData.xList.addAll(selectedTagsData.xList);
      ctx.dispatch(CommonPostActionCreator.onSelectedDataDetail(ctx.state.selectedTagsData));
      if(selectedTagsData.hasNext){
        ctx.state.refreshController.loadComplete();
      }else{
        ctx.state.refreshController.loadNoData();
      }
    }


  }



  /*if( selectedTagsData.xList == null ||  selectedTagsData.xList.length == 0){
    if(selectedTagsBean.isSelected && selectedTagsBean.pageNumber == 1){
      ctx.dispatch(CommonPostActionCreator.onSelectedDataDetail(selectedTagsData));
      ctx.state.refreshController.loadNoData();
    }else{
      ctx.state.refreshController.loadNoData();
    }
  }else{

    if(selectedTagsBean.isSelected && selectedTagsBean.pageNumber == 1){
      ctx.dispatch(CommonPostActionCreator.onSelectedDataDetail(selectedTagsData));
    }else{
      ctx.state.selectedTagsData.xList.addAll(selectedTagsData.xList);
      ctx.dispatch(CommonPostActionCreator.onSelectedDataDetail(ctx.state.selectedTagsData));
      ctx.state.refreshController.loadComplete();
    }

  }*/

}
