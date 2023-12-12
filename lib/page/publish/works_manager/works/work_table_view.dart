import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/publish/works_manager/works/work_item_view.dart';
import 'package:flutter_app/page/publish/works_manager/works/work_unit_select_table.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkTableView extends StatefulWidget {
  final int status;
  final bool isEditStatus;

  const WorkTableView({
    Key key,
    this.status,
    this.isEditStatus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkTableViewState();
  }
}

class _WorkTableViewState extends State<WorkTableView> {
  RefreshController refreshController = RefreshController();
  List<VideoModel> videoList;
  int currentPage = 1;
  List<int> selectedIndexArr = [];
  bool isShowUnitList = false; // 显示合集列表

  List<VideoModel> get selectedVideos {
    List<VideoModel> videos = [];
    for (int index in selectedIndexArr) {
      videos.add(videoList[index]);
    }
    return videos;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }


  @override
  void didUpdateWidget(covariant WorkTableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isEditStatus == false){
      selectedIndexArr.clear();
    }
  }

  ///设置请求作品状态
  String _getStatus(int worksType) {
    String _status = "";
    if (worksType == 0) {
      // 通过
      _status = "1";
    } else if (worksType == 1) {
      //审核中
      _status = "0";
    } else if (worksType == 2) {
      // 已拒绝
      _status = "2";
    }
    return _status;
  }

  void _loadData({int page = 1, int size = 10}) async {
    try {
      MineVideo works = await netManager.client
          .getMyWorks(size, page, _getStatus(widget.status ?? 0));
      currentPage = page;
      videoList ??= [];
      if (page == 1) {
        videoList.clear();
      }
      videoList?.addAll(works?.list ?? []);
      if ((works?.list?.length ?? 0) < size) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadComplete();
      videoList ??= [];
    }
    refreshController.refreshCompleted();
    setState(() {});
  }

  ///删除视频
  void _delVideo() async {
    if (selectedIndexArr.isEmpty) {
      showToast(msg: "请选择视频");
      return;
    }
    for(int index in selectedIndexArr){
      if(videoList[index].status != 2){
        showToast(msg: "只能删除未通过的作品");
        return;
      }
    }
    List<String> idList = [];
    List<VideoModel> videos = [];
    for (int index in selectedIndexArr) {
      idList.add(videoList[index].id);
      videos.add(videoList[index]);
    }
    try {
      WBLoadingDialog.show(context);
      await netManager.client.postDelWork(idList);
      GlobalStore.updateUserInfo(null);
      showToast(msg: "删除成功");
      selectedIndexArr.clear();
      for (var model in videos) {
        videoList.remove(model);
      }
      setState(() {});
    } catch (e) {
      showToast(msg: e.toString());
    }
    WBLoadingDialog.dismiss(context);
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

      maps["videoModel"] = videoModel;

      Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoList == null) {
      return LoadingWidget();
    } else if (videoList.isEmpty) {
      return CErrorWidget("暂无数据");
    } else {
      return SmartRefresher(
        controller: refreshController,
        onRefresh: _loadData,
        enablePullUp: videoList?.isNotEmpty == true,
        enablePullDown: true,
        onLoading: () {
          _loadData(page: currentPage + 1);
        },
        child: (widget.isEditStatus == true)  ? Column(
          children: [
            Expanded(
              child: _buildListView(),
            ),
            _buildEditMenu(),
          ],
        ) : _buildListView(),
      );
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 16),
      itemCount: videoList?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        var model = videoList[index];
        return InkWell(
          onTap: () {
            if (widget.isEditStatus) {
              if (selectedIndexArr.contains(index)) {
                selectedIndexArr.remove(index);
              } else {
                if(model.newsType == "COVER"){
                  showToast(msg: "合集不能添加图文");
                }
                selectedIndexArr.add(index);
              }
              setState(() {});
            } else {
              _skipToDetailEvent(model);
            }
          },
          child: Container(
            height: 86,
            margin: EdgeInsets.only(bottom: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              child: Row(
                children: [
                  if (widget.isEditStatus)
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Image.asset(
                        selectedIndexArr.contains(index)
                            ? "assets/images/unit_selected.png"
                            : "assets/images/unit_unselected.png",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  SizedBox(
                    width: screen.screenWidth,
                    child: WorkItemView(
                      statusType: widget.status,
                      worksType: 1,
                      videoModel: model,
                      isEditStatus: widget.isEditStatus, //model,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEditMenu() {
    return Container(
      height: 80,
      color: Color(0xff272727),
      padding: EdgeInsets.only(top: 12, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _delVideo,
              child: Center(
                child: Text(
                  "删除",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffe28939),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            color: Color(0xff4b4b4b),
          ),
          Expanded(
            child: InkWell(
              onTap: () async{
                if(selectedIndexArr.isEmpty){
                  showToast(msg: "请选择视频");
                  return;
                }
                for (int index in selectedIndexArr) {
                  if(videoList[index].status != 1){
                    showToast(msg: "只能选择已审核的视频");
                    return;
                  }
                }
                for (int index in selectedIndexArr) {
                  if(videoList[index].newsType == "COVER"){
                    showToast(msg: "合集不能添加图文");
                    return;
                  }
                }
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                  return WorkUnitSelectTable(
                    videoList: selectedVideos,
                    cancelCallback: () {
                      Navigator.pop(context);
                    },
                  );
                });
              },
              child: Center(
                child: Text(
                  "添加合集",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffdbdbdb),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
