import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mini_work_unit_detail.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/publish/works_manager/works/work_item_view.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkSpreadSharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorkSpreadSharePageState();
  }
}

class _WorkSpreadSharePageState extends State<WorkSpreadSharePage> {
  RefreshController refreshController = RefreshController();
  MineWorkUnitDetail workUnitModel;
  int currentPage = 1;
  bool isEditStatus = false;
  List<int> selectIndexArr = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadUnitData();
    });
  }

  void _loadUnitData({int page = 1, int size = 10}) async {
    try {
      MineWorkUnitDetail responseData = await netManager.client
          .getWorkUnitVideoPop(page, size, GlobalStore.getMe().uid, null);
      currentPage = page;
      if (page == 1) {
        workUnitModel = responseData;
      } else {
        workUnitModel.list?.addAll(responseData.list ?? []);
      }
      if ((responseData.list?.length ?? 0) < size) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadNoData();
      workUnitModel ??= MineWorkUnitDetail();
      debugLog(e);
    }
    refreshController.refreshCompleted();
    if(mounted) {
      setState(() {});
    }
  }

  void _loadMoreData() {
    _loadUnitData(page: currentPage + 1);
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
      var model = VideoModel.fromJson(videoModel.toJson());
      map['videoList'] = [model];
      JRouter().go(SUB_PLAY_LIST, arguments: map);
    } else if ("MOVIE" == videoModel.newsType) {
      Map<String, dynamic> maps = Map();
      maps["videoId"] = videoModel.id;

      maps["videoModel"] = videoModel;

      Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (workUnitModel == null) {
      return LoadingWidget();
    } else if (workUnitModel.list?.isNotEmpty != true) {
      return CErrorWidget("暂无数据");
    } else {
      return SmartRefresher(
        onRefresh: _loadUnitData,
        onLoading: _loadMoreData,
        enablePullDown: true,
        enablePullUp: true,
        controller: refreshController,
        child: ListView.builder(
          itemCount: workUnitModel.list?.length ?? 0,
          padding: EdgeInsets.only(top: 16),
          itemBuilder: (context, index) {
            var model = workUnitModel.list[index];
            return Container(
              padding: EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  _skipToDetailEvent(model);
                },
                child: Row(
                  children: [
                    if (isEditStatus)
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Image.asset(
                          selectIndexArr.contains(index)
                              ? "assets/images/unit_selected.png"
                              : "assets/images/unit_unselected.png",
                          width: 16,
                          height: 16,
                        ),
                      ),
                    Expanded(
                      child: WorkItemView(worksType: 0, videoModel: model),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
