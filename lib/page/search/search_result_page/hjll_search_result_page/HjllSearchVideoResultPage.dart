import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/route_manager.dart' as Gets;



class HjlSearchVideoResultPage extends StatefulWidget {


  String keywords;

  List<LiaoBaTagsDetailDataVideos>  videoList = [];

  HjlSearchVideoResultPage({
    Key key,
    this.keywords
    });


  @override
  State<HjlSearchVideoResultPage> createState() => _HjlSearchVideoResultPageState();
}

class _HjlSearchVideoResultPageState extends State<HjlSearchVideoResultPage> {
  RefreshController refreshController = RefreshController();
  int pageSize = 10;
  int pageNumber = 1;
  int moduleSort = 3;
  List<VideoModel> videoList = [];
  BaseRequestController baseRequestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _loadaListData() async{
    if(pageNumber==1){
      videoList.clear();
    }
    try {
      var model = await netManager.client
          .getVideoData(pageNumber, pageSize,  [widget.keywords], 'SP');
      if ((model.list.length ?? 0) == 0 && pageNumber==1) {
        baseRequestController.requestDataEmpty();
      } else {
        baseRequestController.requestSuccess();
      }
      if(model.list!=null){
        videoList.addAll(model.list);
      }
      if (!model.hasNext) {
        refreshController.loadNoData();
      }else{
        if(pageNumber==1){
          refreshController.refreshCompleted();
        }else{
          refreshController.loadComplete();
        }
      }

    } catch (e) {
     baseRequestController.requestFail();
      refreshController.refreshFailed();
    }
  }

  _initData() async{
    pageNumber = 1;
    await _loadaListData();
    setState(() {

    });
  }
  _refreshData() async{
    pageNumber = 1;
    await _loadaListData();
    setState(() {

    });
  }
  _loadMoreData() async{
    pageNumber += 1;
    await _loadaListData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
   return FullBg(
       child: BaseRequestView(
         retryOnTap: () => _refreshData(),
         controller: baseRequestController,
         child: (videoList!=null && videoList.length>0)?pullYsRefresh(
           refreshController: refreshController,
           enablePullDown: true,
           child:GridView.builder(
             padding: EdgeInsets.only(left: 10,right: 10),
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               mainAxisSpacing: 10.0,
               crossAxisSpacing: 7.0,
               childAspectRatio: 201 / 182,
             ),
             itemBuilder: (context, index) {
               return GestureDetector(
                 onTap: (){
                   Map<String, dynamic> maps = Map();
                   maps["videoId"] = videoList[index]?.id;

                   maps["videoModel"] = null;

                   //maps["videoModel"] = videoList[index];

                  // maps["isNeedInitVideoInfo"] = true;

                   Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                       opaque: false);
                 },
                 child: Container(
                   child: SizedBox(
                     width: (screen.screenWidth - 10*2-7)/2,
                     height: ((screen.screenWidth - 10*2-7)/2)*(182/201),
                     child: VideoCellWidget(
                       videoModel: videoList[index],
                       textLine: 2,
                       imageWidth: (screen.screenWidth - 10*2-7)/2,
                       imageHeight: ((screen.screenWidth - 10*2-7)/2)*(113/201),
                     ),
                   ),
                 ),
               );
             },
             itemCount: videoList==null?0:(videoList?.length ?? 0),
           ),
           onLoading: () {
             _loadMoreData();
           },
           onRefresh: () {
             _refreshData();
           },
         ):EmptyWidget("mine", 3),
       )

   );

  }
}
