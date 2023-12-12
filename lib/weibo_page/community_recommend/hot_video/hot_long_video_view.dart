import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';

import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HotLongVideoView extends StatefulWidget {
  final String type; // SP 短视频， movie 长视频
  final String id;
  const HotLongVideoView({Key key, this.type, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HotLongVideoViewState();
  }
}

class _HotLongVideoViewState extends State<HotLongVideoView> {
  CommonPostRes commonPostResHotVideo;

  RefreshController refreshController = RefreshController();

  int pageNum = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onLoadData(page: 1);
    });
  }

  void onLoadData({int page = 1, int size = 50}) async {
    try {
      // /api/app/vid/community/hot/list
      String reqDate = await _getReqDate();
      CommonPostRes responseData = await netManager.client
          .communityHotlist(page, size, widget.type, reqDate);
      pageNum = page;
      if (page == 1) {
        commonPostResHotVideo = responseData;
      } else {
        if (responseData.list != null && responseData.list.length > 0) {
          commonPostResHotVideo.list.addAll(responseData.list ?? []);
        }
      }
      if (responseData.hasNext == true && responseData.list?.length == size ) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
      refreshController.refreshCompleted();
      setState(() {});
    } catch (e) {
      commonPostResHotVideo ??= CommonPostRes();
      if (commonPostResHotVideo.hasNext == true) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
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
      reqDate = (netManager.getFixedCurTime().toString());
    }
    return reqDate;
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = (screen.screenWidth - 14*3)/3;
    double itemHeight = itemWidth *107/191 + 20;
    if (commonPostResHotVideo == null) {
      return LoadingWidget();
    } else if (commonPostResHotVideo.list?.isNotEmpty != true) {
      return CErrorWidget("暂无数据");
    } else {
      return Container(
        margin: EdgeInsets.only(left: 14, right: 14),
        child: pullYsRefresh(
          refreshController: refreshController,
          onRefresh: onLoadData,
          onLoading: () {
            onLoadData(page: pageNum + 1);
          },
          child: GridView.builder(
            itemCount: commonPostResHotVideo.list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //横向数量
              crossAxisSpacing: 14, //间距
              mainAxisSpacing: 10, //行距
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Map<String, dynamic> maps = Map();
                  maps["videoId"] = commonPostResHotVideo.list[index].id;
                  Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps),
                      opaque: false);
                },
                child: VideoCellWidget(
                  videoModel: commonPostResHotVideo.list[index],
                  textLine: 1,
                  isShowVip: false,
                ),
              );
            },
          ),
        ),
      );
    }
  }
}
