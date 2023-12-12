import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/user/mini_work_unit_detail.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_cell.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkUnitDetailPage extends StatefulWidget {
  final WorkUnitModel model;
  final UserInfoModel userInfo;

  const WorkUnitDetailPage({Key key, this.model, this.userInfo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkUnitDetailPageState();
  }
}

class _WorkUnitDetailPageState extends State<WorkUnitDetailPage> {
  RefreshController refreshController = RefreshController();
  MineWorkUnitDetail workUnitModel;

  bool get isMe {
    if (widget.userInfo == null) return true;
    return GlobalStore.isMe(widget.userInfo?.uid);
  }

  WorkUnitModel get detailModel => widget.model;
  int currentPage = 1;
  bool isEditStatus = false;
  List<int> selectIndexArr = [];
  bool isChange = false; // 数据变动了
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadUnitData();
    });
  }

  void _loadUnitData({int page = 1, int size = 10}) async {
    try {
      String reqDate = await netManager.getReqDate();
      MineWorkUnitDetail responseData = await netManager.client
          .getWorkUnitVideoList(page, size, reqDate, detailModel.id,
              widget.userInfo?.uid ?? GlobalStore.getMe().uid,0);
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

    setState(() {});
  }

  void _loadMoreData() {
    _loadUnitData(page: currentPage + 1);
  }

  void _moveOutUnitEvent() async {
    if (selectIndexArr.isEmpty) {
      showToast(msg: "请选择视频");
      return;
    }
    List<String> vIds = [];
    List<VideoModel> videos = [];
    for (int index in selectIndexArr) {
      vIds.add(workUnitModel.list[index].id);
      videos.add(workUnitModel.list[index]);
    }
    try {
      WBLoadingDialog.show(context);
      await netManager.client.postWorkUnitVideoDelete(widget.model.id, vIds);
      showToast(msg: "移除成功");
      for (var model in videos) {
        workUnitModel.list.remove(model);
      }
      isChange = true;
      selectIndexArr.clear();
      isEditStatus = false;
      widget.model.totalCount = widget.model.totalCount - videos.length;
      setState(() {});
    } catch (e) {
      showToast(msg: "移除失败");
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
      Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        safePopPage(isChange);
        return false;
      },
      child: FullBg(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => safePopPage(isChange),
              ),
              title: Text("合集详情",
                  style: TextStyle(fontSize: AppFontSize.fontSize18)),
              actions: [
                Row(
                  children: [
                    if (isMe)
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          isEditStatus = !isEditStatus;
                          selectIndexArr.clear();
                          setState(() {});
                        },
                        child: Container(
                          width: 36,
                          height: 50,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/edit_unit.png",
                            width: 18,
                          ),
                        ),
                      ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () async {
                        showShareVideoDialog(
                          context,
                              () {},
                          videoModel: VideoModel()
                            ..cover = widget.model.coverImg,
                          titleDesc: widget.model.collectionName,
                          contentDesc: "@${widget.userInfo?.name ?? GlobalStore.getMe().name}",
                          isLongVideo: true,
                          isFvVideo: false,
                        );
                      },
                      child: Container(
                        width: 36,
                        height: 50,
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/share_white.png",
                            width: 14),
                      ),
                    ),

                  ],
                ),
              ],
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      WorkUnitDetailHeaderView(
                          imageWidth: 152,
                          imageHeight: 85,
                          model: workUnitModel?.collection ?? widget.model),
                      SizedBox(height: 18),
                      Container(
                        height: 1,
                        color: Color(0xff333333),
                      ),
                      Expanded(child: _buildTableView()),
                    ],
                  ),
                ),
                if (isEditStatus)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildMoveOutUnitButton(),
                  ),
              ],
            )),
      ),
    );
  }

  Widget _buildTableView() {
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
                  if (isEditStatus) {
                    if (selectIndexArr.contains(index)) {
                      selectIndexArr.remove(index);
                    } else {
                      selectIndexArr.add(index);
                    }
                    setState(() {});
                  } else {
                    _skipToDetailEvent(model);
                  }
                },
                child: Row(
                  children: [
                    if (isEditStatus)
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
                        child: Image.asset(
                          selectIndexArr.contains(index)
                              ? "assets/images/unit_selected.png"
                              : "assets/images/unit_unselected.png",
                          width: 16,
                          height: 16,
                        ),
                      ),
                    Expanded(
                      child: WorkUnitCell(
                        imageWidth: 85,
                        imageHeight: 85,
                        imageUrl: model.coverThumb ?? model.cover,
                        title: model.title,
                        descText:
                            "播放量：${model.playCountDesc ?? "0"}      点赞数：${model.likeCount ?? "0"}",
                      ),
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

  Widget _buildMoveOutUnitButton() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 32),
          child: InkWell(
            onTap: _moveOutUnitEvent,
            child: Container(
              height: 44,
              width: 212,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffdd903f),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                "移出合集",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
