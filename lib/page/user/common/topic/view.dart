import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/anwang_trade/widget/MyVIdeoCollectListDialogView.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/community_recommend/topic_detail/topic_detail_page.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

///话题公用UI
Widget buildView(TopicState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: BaseRequestView(
      retryOnTap: () => dispatch(TopicActionCreator.refresh()),
      controller: state.requestController,
      child:
       Stack(
         children: [
           pullYsRefresh(
             refreshController: state.refreshController,
             onRefresh: () => dispatch(TopicActionCreator.refresh()),
             onLoading: () => dispatch(TopicActionCreator.loadMore()),
             child: ListView.builder(
                 padding: EdgeInsets.only(top: 8),
                 itemExtent: Dimens.pt92,
                 itemBuilder: (BuildContext context, int index) {
                   if (state.tagModelList == null) {
                     return Container();
                   }
                   TagDetailModel tagDetailModel = state.tagModelList[index];
                   return _buildTagItem(
                       state, dispatch, tagDetailModel, viewService);
                 },
                 itemCount: state.tagModelList?.length ?? 0),
           ),
           state.isTagEditModel??false?Positioned(child: Row(
             children: [
               SizedBox(width: 16,),
               Expanded(child: GestureDetector(
                 onTap: (){
                   List<String> vIds = [];
                   for(var model in state.tagModelList){
                     if(model.isSelected??false){
                       vIds.add(model.id);
                     }
                   }
                   dispatch(TopicActionCreator.collectBatch(vIds));
                 },
                 child: Container(
                   height: 44,
                   alignment: Alignment.center,
                   child: Text("删除",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(22)),
                       gradient: LinearGradient(
                           colors: [
                             Color.fromRGBO(254, 127, 15, 1),
                             Color.fromRGBO(234, 139, 37, 1),
                           ]
                       )
                   ),
                 ),
               ),),
               SizedBox(width: 16,),
               // Expanded(child: GestureDetector(
               //   onTap: (){
               //     showDialog(
               //         context: viewService.context,
               //         barrierDismissible: false,
               //         barrierColor: Colors.transparent,
               //         builder: (BuildContext context) {
               //           return MyVideoCollectListDialogView((cId) async {
               //             List<String> vIds = [];
               //             for(var model in state.tagModelList){
               //               if(model.isSelected??false){
               //                 vIds.add(model.id);
               //               }
               //             }
               //             await netManager.client.postWorkUnitVideoAdd(cId, vIds);
               //             showToast(msg: "添加成功");
               //           });
               //         });
               //   },
               //   child: Container(
               //     height: 44,
               //     alignment: Alignment.center,
               //     child: Text("添加列表",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
               //     decoration: BoxDecoration(
               //         borderRadius: BorderRadius.all(Radius.circular(22)),
               //         gradient: LinearGradient(
               //             colors: [
               //               Color.fromRGBO(254, 127, 15, 1),
               //               Color.fromRGBO(234, 139, 37, 1),
               //             ]
               //         )
               //     ),
               //   ),
               // ),),
               // SizedBox(width: 16,),
             ],),left: 0,right: 0,bottom: 10,):SizedBox(),
         ],
       )

    ),
  );
}

///创建标签列表
InkWell _buildTagItem(TopicState state, Dispatch dispatch,
        TagDetailModel tagDetailModel, ViewService viewService) =>
    InkWell(
      onTap: () {
        if (state.isTagEditModel) {
          return;
        }

        Map<String, dynamic> map = tagDetailModel.toJson();
        TagsBean e = TagsBean.fromMap(map);
        Gets.Get.to(TopicDetailPage().buildPage({"tagsBean": e}),
            opaque: false);
      },
      child:
      Stack(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: Dimens.pt16,
              right: Dimens.pt16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  child: CustomNetworkImage(
                    imageUrl: tagDetailModel?.coverImg ?? '',
                    width: Dimens.pt64,
                    height: Dimens.pt64,
                    type: ImgType.avatar,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: Dimens.pt10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: Dimens.pt18),
                          child: Text(
                            "#${tagDetailModel?.name ?? ""}",
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt17),
                          ),
                        ),
                        Text(
                          tagDetailModel?.playCount == null
                              ? ''
                              : '话题总播放 ${_formatNumberValue("${tagDetailModel?.playCount ?? 0}")}',
                          style: TextStyle(
                              color: Color(0xff7c879f), fontSize: Dimens.pt12),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                // state.isTagEditModel ?? false
                //     ? _createFavoriteDelButton(dispatch, tagDetailModel?.id)
                //     :
                _createFavoriteButton(
                    dispatch, tagDetailModel?.id, tagDetailModel?.hasCollected),
              ],
            ),
          ),
          Visibility(
            visible: state.isTagEditModel ?? false,
            child: Container(
              alignment: Alignment.topRight,
              color: Colors.black.withAlpha(200),
              child: GestureDetector(
                  onTap: () {
                    tagDetailModel.isSelected = !(tagDetailModel.isSelected??false);
                    dispatch(TopicActionCreator.updateUI());
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5),
                    child: tagDetailModel.isSelected??false?Image.asset("assets/images/unit_selected.png",width: 20,height: 20,):Image.asset("assets/images/unit_unselected.png",width: 20,height: 20,),
                  )
              ),
            ),
          ),
        ],
      )

    );

///设置金额显示
String _formatNumberValue(String value) {
  if (double.parse(value) > 10000) {
    return (double.parse(value) / 10000).toStringAsFixed(1) + "W次";
  } else if (double.parse(value) > 1000) {
    return (double.parse(value) / 10000).toStringAsFixed(1) + "K次";
  } else {
    return value + "次";
  }
}

///已收藏按钮
Widget _createFavoriteButton(
    Dispatch dispatch, String tagID, bool hasCollected) {
  return GestureDetector(
    onTap: () =>
        dispatch(TopicActionCreator.clickCollectTag(tagID, hasCollected)),
    child: Container(
      width: Dimens.pt70,
      height: Dimens.pt30,
      decoration: BoxDecoration(
        color: AppColors.userFavoriteTextColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: hasCollected
                ? AssetImage(AssetsImages.ICON_MINE_FAVORITE)
                : AssetImage(AssetsImages.ICON_VIDEO_FUNC03),
            width: Dimens.pt16,
            height: Dimens.pt16,
          ),
          SizedBox(width: 1),
          Text(hasCollected ? "已收藏" : "收藏",
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt11)),
        ],
      ),
    ),
  );
}

///展示删除按钮
Widget _createFavoriteDelButton(Dispatch dispatch, String tagID) {
  return GestureDetector(
    onTap: () => dispatch(TopicActionCreator.delCollectTag(tagID)),
    child: svgAssets(
      AssetsSvg.ICON_MY_FAVORITE_DEL,
      width: Dimens.pt18,
      height: Dimens.pt20,
    ),
  );
}

