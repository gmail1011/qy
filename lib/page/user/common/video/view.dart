import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/anwang_trade/widget/MyVIdeoCollectListDialogView.dart';
import 'package:flutter_app/page/anwang_trade/widget/input_single_btn_view.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';


import '../module_type.dart';
import 'action.dart';
import 'state.dart';

final _subItemHeight = ((screen.screenWidth - 32 - 14) / 2) / 1.78;

///长视频公用UI
Widget buildView(
    LongVideoState state, Dispatch dispatch, ViewService viewService) {

  var longVideoUI = Container(
    child: Padding(
      padding:  EdgeInsets.only(top: 8.0.w, left: 16.w, right: 16.w), //边缘间距（插图）
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //禁止滚动
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 14.0,
          childAspectRatio: 191 / 153,
        ),
        itemCount: state.videoModelList?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          if (state.videoModelList == null) {
            return Container();
          }
          VideoModel videoModel = state.videoModelList[index];
          return Container(
            child: GestureDetector(
              onTap: () {
                //是否是视频编辑模式，则点击无效
                if (state.isVideoEditModel) {
                  return;
                }
                Map<String, dynamic> maps = Map();
                maps["videoId"] = videoModel?.id;
                if (state.moduleType == ModuleType.LONG_VIDEO_OFFLINE_CACHE) {
                  maps["videoModel"] = videoModel;
                  maps["isCacheVideo"] = true;
                }
                JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
              },
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Container(
                              child: CustomNetworkImage(
                                height: _subItemHeight,
                                imageUrl: videoModel?.cover ?? '',
                                errorWidget: Icon(Icons.error),
                              ),
                            ),
                            Positioned(
                              top: -1,
                              left: -3,
                              child: Visibility(
                                visible: videoModel?.originCoins != null &&
                                    videoModel?.originCoins == 0,
                                child: Image(
                                  image: AssetImage(AssetsImages.IC_VIDEO_VIP),
                                  width: 50.w,
                                  height: 20.w,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -1,
                              left: -1,
                              child: Visibility(
                                visible: videoModel?.originCoins != null &&
                                    videoModel?.originCoins != 0
                                    ? true
                                    : false,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        //height: 20.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              bottomRight: Radius.circular(4)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(247, 131, 97, 1),
                                              Color.fromRGBO(245, 75, 100, 1),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 8.w,
                                          right: 8.w,
                                          top: 3.w,
                                          bottom: 3.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            ImageLoader.withP(
                                                ImageType.IMAGE_SVG,
                                                address: AssetsSvg
                                                    .ICON_VIDEO_GOLD,
                                                width: 12.w,
                                                height: 12.w)
                                                .load(),
                                            const SizedBox(width: 6),
                                            Text(
                                                videoModel?.originCoins
                                                    .toString(),
                                                style: TextStyle(
                                                  color:
                                                  AppColors.textColorWhite,
                                                  fontSize: 14.w,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              height: 25.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient:LinearGradient(
                                    begin :Alignment.topCenter,
                                    end:Alignment.bottomCenter,
                                    colors: [Colors.transparent,Colors.black.withOpacity(0.6)]
                                ),
                              ),
                              child: Padding(
                                padding:
                                EdgeInsets.only(left: 10.w, right: 10.w),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            AssetsImages.IC_LONG_VIDEO_EYE,
                                            width: 11.w,
                                            height: 11.w),
                                        SizedBox(width: 4.w),
                                        Text(
                                          (videoModel?.playCount ?? 0) > 10000
                                              ? ((videoModel?.playCount ?? 0) /
                                              10000)
                                              .toStringAsFixed(1) +
                                              "w"
                                              : (videoModel?.playCount ?? 0)
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      TimeHelper.getTimeText(
                                          (videoModel?.playTime ?? 0)
                                              .toDouble()),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.w),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.w),
                      Text(
                        "${videoModel?.title ?? ""}",
                        maxLines: 2,
                        style: TextStyle(color: Colors.white, fontSize: 16.w),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: state.isVideoEditModel ?? false,
                    child: (state.moduleType == ModuleType.LONG_VIDEO_MY_FAVORITE)?Container(
                      alignment: Alignment.topRight,
                      color: Colors.black.withAlpha(200),
                      child: GestureDetector(
                          onTap: () {
                            state.videoModelList[index].selected = !(state.videoModelList[index].selected??false);
                            dispatch(LongVideoActionCreator.updateUI());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5,right: 5),
                            child: state.videoModelList[index].selected??false?Image.asset("assets/images/unit_selected.png",width: 20,height: 20,):Image.asset("assets/images/unit_unselected.png",width: 20,height: 20,),
                          )
                      ),
                    ):Container(
                      height: _subItemHeight,
                      alignment: Alignment.center,
                      color: Colors.black.withAlpha(200),
                      child: GestureDetector(
                        onTap: () {
                          dispatch(LongVideoActionCreator.deleteVideo(
                              videoModel?.id));
                        },
                        child: Image(
                          image: AssetImage(AssetsImages.ICON_MINE_DEL),
                          width: 42.w,
                          height: 42.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );

  return BaseRequestView(
    retryOnTap: () => dispatch(LongVideoActionCreator.refreshVideo()),
    child:
        Stack(
          children: [
            pullYsRefresh(
              refreshController: state.refreshController,
              onRefresh: () => dispatch(LongVideoActionCreator.refreshVideo()),
              onLoading: () => dispatch(LongVideoActionCreator.loadMoreVideo()),
              child: longVideoUI,
            ),
            ((state.moduleType == ModuleType.LONG_VIDEO_MY_FAVORITE) && (state.isVideoEditModel??false))?Positioned(child: Row(
              children: [
                SizedBox(width: 16,),
                Expanded(child: GestureDetector(
                  onTap: (){
                    List<String> vIds = [];
                    for(var model in state.videoModelList){
                      if(model.selected??false){
                        vIds.add(model.id);
                      }
                    }
                    dispatch(LongVideoActionCreator.collectBatch(vIds));
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
                Expanded(child: GestureDetector(
                  onTap: (){
                    showDialog(
                        context: viewService.context,
                        barrierDismissible: false,
                        barrierColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return MyVideoCollectListDialogView((cId) async {
                            List<String> vIds = [];
                            for(var model in state.videoModelList){
                              if(model.selected??false){
                                vIds.add(model.id);
                              }
                            }
                            if(vIds.length==0){
                              showToast(msg: "没有选择视频");
                              return;
                            }
                            await netManager.client.postWorkUnitVideoAdd(cId, vIds);
                            showToast(msg: "添加成功");
                          });
                        });
                  },
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    child: Text("添加列表",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
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
              ],),left: 0,right: 0,bottom: 10,):SizedBox(),
          ],
        ),
    controller: state.requestController,
  );
}
