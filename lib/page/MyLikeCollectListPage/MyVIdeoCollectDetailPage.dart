import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/user/mini_work_unit_detail.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_cell.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart' as Gets;


class MyVIdeoCollectDetailPage extends StatefulWidget {

  bool isEdit = false;
  String cId;
  MineWorkUnitDetail responseData;
  bool loading = true;
  MyVIdeoCollectDetailPage(this.cId);

  @override
  State<MyVIdeoCollectDetailPage> createState() => _MyVIdeoCollectDetailPageState();
}

class _MyVIdeoCollectDetailPageState extends State<MyVIdeoCollectDetailPage> {

  @override
  void initState() {
    super.initState();
    widget.loading = true;
    _loadData();
  }

  _loadData() async {
    String reqDate = await netManager.getReqDate();
    widget.responseData = await netManager.client.getWorkUnitVideoList(1, 100, reqDate, widget.cId, GlobalStore.getMe().uid,1);
    widget.loading = false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return widget.loading?Container(
      child: LoadingWidget(title: "加载中..."),
    ):FullBg(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          titleSpacing: .0,
          title: Text(
            "我的喜欢",
            style: TextStyle(
                fontSize: AppFontSize.fontSize18,
                color: Colors.white,
                height: 1.4),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => safePopPage(),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                widget.isEdit=!widget.isEdit;
                setState(() {
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: svgAssets(AssetsSvg.ICON_MINE_EDIT, width: 16, height: 16),
              ),
            ),
          ],
        ),
        body:
        Stack(
          children: [
            Container(
                width: screen.screenWidth,
                height: screen.screenHeight-140,
                color: Colors.transparent,
                alignment: Alignment.center,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(21, 21, 21, 1),
                              Color.fromRGBO(21, 21, 21, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                      ),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: (widget.responseData==null||widget.responseData.list==null)?0:widget.responseData.list.length,
                            itemBuilder: (context, index) {
                              VideoModel videoModel =  widget.responseData.list[index];
                              return Container(
                                child: _buildItemCell(videoModel),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
            widget.isEdit??false?Positioned(child: Row(
              children: [
                SizedBox(width: 16,),
                Expanded(child: GestureDetector(
                  onTap: () async {
                    List<String> vIds = [];
                    List<VideoModel> videos = [];
                    widget.responseData.list.forEach((element) {
                      if(element.selected??false){
                        vIds.add(element.id);
                        videos.add(element);
                      }
                    });
                    try {
                      WBLoadingDialog.show(context);
                      await netManager.client.postWorkUnitVideoDelete(widget.cId, vIds);
                      showToast(msg: "移除成功");
                      WBLoadingDialog.dismiss(context);
                      for (var model in videos) {
                        widget.responseData.list.remove(model);
                      }
                      setState(() {});
                    } catch (e) {
                      showToast(msg: "移除失败");
                    }
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
              ],
            ),left: 0,right: 0,bottom: 10,):SizedBox()
          ],
        ),
      ),
    );
  }
  _buildItemCell(VideoModel videoModel){
    return GestureDetector(
      child:  Container(
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(34, 34, 34, 0.5),
        margin: EdgeInsets.only(top: 10),
        child:Stack(
          children: [
            Row(
              children: [
                SizedBox(width: 16,),
                CustomNetworkImage(
                  imageUrl: videoModel.cover??"",
                  fit: BoxFit.cover,
                  height: 85,
                  width: 85,
                ),
                SizedBox(width: 6,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(child:Text("${videoModel.title}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),maxLines: 1,  overflow: TextOverflow.ellipsis),)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Text("播放量:${numCoverStr(videoModel.playCount ?? 0)}",style: TextStyle(color: Color(0xffaba9a9),fontSize: 13),),
                        SizedBox(width: 12,),
                        Expanded(child: Text("点赞数:${numCoverStr(videoModel.likeCount ?? 0)}",style: TextStyle(color: Color(0xffaba9a9),fontSize: 13),)),
                      ],
                    )

                  ],
                ),)
              ],
            ),
            widget.isEdit??false?Positioned(right: 10,bottom: 10, child: videoModel.selected??false?Image.asset("assets/images/unit_selected.png",width: 20,height: 20,):Image.asset("assets/images/unit_unselected.png",width: 20,height: 20)):SizedBox()
          ],
        )
      ),
      onTap: (){
        if(!(widget.isEdit??false)){
          _skipToDetailEvent(videoModel);
          return;
        }
        videoModel.selected = videoModel.selected??false?false:true;
        setState(() {

        });
      },
    );
  }
  void _skipToDetailEvent(VideoModel videoModel) {
    ///进入图文详情
    if ("COVER" == videoModel.newsType) {
      Gets.Get.to(
              () => CommunityDetailPage().buildPage({"videoId": videoModel?.id}),
          opaque: false);
    } else if ("SP" == videoModel.newsType) {
      ///进入短视频
      Map<String, dynamic> map = Map();
      map['playType'] = VideoPlayConfig.VIDEO_TYPE_COLLECT;
      map['currentPosition'] = 0;
      map['pageNumber'] = 1;
      map['uid'] = GlobalStore.getMe()?.uid;
      map['pageSize'] = 1;
      map['type'] = 'video';
      map['videoList'] = [videoModel];
      JRouter().go(SUB_PLAY_LIST, arguments: map);
    } else if ("MOVIE" == videoModel.newsType) {
      Map<String, dynamic> maps = Map();
      maps["videoId"] = videoModel.id;
      Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
    }
  }
}


