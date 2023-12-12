import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';

import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HotShortVideoView extends StatefulWidget {
  final String type; // SP 短视频， movie 长视频
  final String id;
  const HotShortVideoView({Key key, this.type, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HotShortVideoViewState();
  }
}

class _HotShortVideoViewState extends State<HotShortVideoView> {
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

  void onLoadData({int page = 1 , int size = 50}) async {
    try {
      // /api/app/vid/community/hot/list
      String reqDate = await _getReqDate();
      CommonPostRes reponseData = await netManager.client
          .communityHotlist(page, size, widget.type, reqDate);
      pageNum = page;
      if (page == 1) {
        commonPostResHotVideo = reponseData;
      } else {
        commonPostResHotVideo.list?.addAll(reponseData.list ?? []);
      }
      if (reponseData.hasNext == true && reponseData.list?.length == size ) {
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
    double itemWidth = (screen.screenWidth - 10*2 - 14*2)/3;
    double itemHeight = itemWidth *190/152 + 20;
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
              crossAxisCount: 3, //横向数量
              crossAxisSpacing: 10, //间距
              mainAxisSpacing: 10, //行距
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                    List<VideoModel> lists = [];
                    commonPostResHotVideo.list.forEach((element) {
                      lists.add(element);
                    });
                    Map<String, dynamic> maps = Map();
                    maps['pageNumber'] = 1;
                    maps['pageSize'] = 3;
                    maps['currentPosition'] = index;
                    maps['videoList'] = lists;
                    maps['tagID'] =
                        commonPostResHotVideo.list[index].tags.length == 0
                            ? null
                            : commonPostResHotVideo.list[index].tags[0].id;
                    maps['playType'] = VideoPlayConfig.VIDEO_POST;

                    maps['isNewListRequest'] = true;
                    maps['isNewListRequestId'] = widget.id;

                    Config.isNewListRequest = true;

                    Config.isNewListRequestId = widget.id;
                    Gets.Get.to(SubPlayListPage().buildPage(maps),
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
