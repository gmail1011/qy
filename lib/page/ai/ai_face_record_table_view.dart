import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ai_record_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/ai/ai_new_image_view.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../assets/lang.dart';
import '../../common/local_store/cached_video_store.dart';
import '../../global_store/store.dart';
import '../../model/film_tv_video/film_tv_video_detail_entity.dart';
import '../alert/vip_rank_alert.dart';
import 'AIVideoPage.dart';

class AiFaceRecordTableView extends StatefulWidget {
  final int status;

  const AiFaceRecordTableView({
    Key key,
    this.status,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AiFaceRecordTableViewState();
  }
}

class _AiFaceRecordTableViewState extends State<AiFaceRecordTableView> {
  int currentIndex = 1;
  int currentPage = 1;
  RefreshController _controller;
  List<AiRecordModel> modelList;

  double get itemWidth {
    if (widget.status == 1) {
      return (screen.screenWidth - 12 * 2) / 3;
    }
    return (screen.screenWidth - 12 * 2) / 4;
  }

  @override
  void initState() {
    super.initState();
    _controller = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData({int page = 1, int size = 10}) async {
    try {
      AiRecordEntity response = await netManager.client
          .getAiFaceRecordList(page, size, widget.status);
      currentPage = page;
      modelList ??= [];
      if (page == 1) {
        modelList.clear();
      }
      modelList.addAll(response.list ?? []);
      if (response.list.length < size) {
        _controller.loadNoData();
      } else {
        _controller.loadComplete();
      }
    } catch (e) {
      modelList ??= [];
      _controller.loadComplete();
    }
    _controller.refreshCompleted();
    setState(() {});
  }

  void _showNewPictureEvent(AiRecordModel model) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AiNewImageView(
          imageUrls: model.newPic,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          if (modelList?.isNotEmpty == true)
            Container(
              height: 44,
              child: Row(
                children: [
                  // _buildMenuTitle("生成ID"),
                  // _buildMenuTitle("原图"),
                  // if (widget.status == 2) _buildMenuTitle("生成图"),
                  //if (widget.status == 3) _buildMenuTitle("失败原因"),
                  // _buildMenuTitle("生成时间"),
                ],
              ),
            ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (modelList == null) {
      return LoadingWidget();
    } else if (modelList?.isEmpty == true) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          modelList = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return pullYsRefresh(
        refreshController: _controller,
        onRefresh: _loadData,
        onLoading: () => _loadData(page: currentPage + 1),
        child: ListView.builder(
          itemCount: modelList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: _buildItemCell(widget.status, modelList[index]),
            );
          },
        ),
      );
    }
  }

  Widget _buildMenuTitle(String title, {Color textColor}) {
    return Container(
      width: itemWidth,
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: textColor ?? Color(0xfff1f1f1)),
      ),
    );
  }

  Widget _buildMenuImage(String imagePaths) {
    return Container(
      height: 51,
      width: 51,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: Container(
              height: 51,
              width: 51,
              //padding: EdgeInsets.only(left: 12),
              child: CustomNetworkImage(
                imageUrl: imagePaths ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCell(int index, AiRecordModel model) {
    return GestureDetector(
      onTap: () async {
        if (widget.status == 1) {
          Gets.Get.to(AiVideoPage(model.url, "AI换脸"), opaque: true);
        } else if (widget.status == -1) {
          showDelDialog(true, model);
        }
      },
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.1),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            GestureDetector(
                onTap: () async {
                  if (widget.status == 1) {
                    VideoModel videoModel = await netManager.client
                        .getVideoDetail(model.vidId, null);
                    Gets.Get.to(
                        AiVideoPage(videoModel.sourceURL, videoModel.title),
                        opaque: true);
                  }
                },
                child: _buildMenuImage(model.picture.first)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "ID：",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Text(
                        model.id,
                        style:
                            TextStyle(fontSize: 12, color: Color(0x80ffffff)),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 9),
                  Text(
                    DateTimeUtil.utcTurnYear(model.updatedAt, char: "."),
                    style: TextStyle(fontSize: 12, color: Color(0x80ffffff)),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            if (widget.status == 0)
              Container(
                width: 52,
                alignment: Alignment.center,
                child: Text(
                  "生成中",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xff898989)),
                ),
              ),
            if (widget.status == 1)
              GestureDetector(
                onTap: () {
                  _cacheVideo(context, model);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Image.asset("assets/images/hls_ai_icon_download.png",
                      width: 31, height: 32),
                ),
              ),
            if (widget.status != 0)
              GestureDetector(
                  onTap: () {
                    showDelDialog(false, model);
                  },
                  child: Image.asset(
                    "assets/images/hls_ai_icon_delete.png",
                    width: 20,
                    height: 20,
                  )),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  void showDelDialog(bool isShowRemark, AiRecordModel model) {
    showDialog(
      context: FlutterBase.appContext,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            width: Dimens.pt266,
            height: Dimens.pt122,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: 20,
                  child: Text(
                    isShowRemark ? "失败原因" : "是否删除该订单?",
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
                if (model.status == -1 && isShowRemark)
                  Positioned(
                    top: 52,
                    child: Text(
                      "失败原因：${model.remark}",
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                if (!isShowRemark)
                  Positioned(
                    left: 58,
                    bottom: 15,
                    child: GestureDetector(
                        onTap: () {
                          safePopPage();
                        },
                        child: Text(
                          "取消",
                          style:
                              TextStyle(color: Color(0xff666666), fontSize: 18),
                        )),
                  ),
                if (!isShowRemark)
                  Positioned(
                    right: 58,
                    bottom: 15,
                    child: GestureDetector(
                        onTap: () async {
                          LoadingWidget loadingWidget = LoadingWidget(
                            title: "加载中...",
                          );
                          // loadingWidget.show(context);
                          // dynamic response = await netManager.client
                          //     .deleteAiFaceBill(model.id);
                          setState(() {
                            modelList.remove(model);
                          });
                          showToast(msg: '删除成功');
                          // loadingWidget.cancel();
                          safePopPage();
                          // _loadData();
                        },
                        child: Text(
                          "确定",
                          style:
                              TextStyle(color: Color(0xFFFD7F10), fontSize: 18),
                        )),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///缓存视频
  void _cacheVideo(BuildContext context, AiRecordModel model) async {
    if (!GlobalStore.isVIP()) {
      VipRankAlert.show(
        context,
        type: VipAlertType.cache,
      );
      return;
    }

    // FilmTvVideoDetailEntity data = await netManager.client.getVideoDetail(vidId, null);
    Map<String, dynamic> uInfoMap = {};
    GlobalStore.getMe().toJson().forEach((key, value) {
      uInfoMap.addAll(Map.of({key.toString(): value}));
    });

    var videoModel = VideoModel.fromJson({
      "id": model.vidId,
      "likeCount": 0,
      "playCount": 0,
      "sourceURL": model.url,
      "status": 1,
      "title": "AI换脸_${model.id}",
      "originCoins": 0,
      "coins": model.coin,
      "createdAt": model.createdAt,
      "cover": model.picture.first,
      "location": null,
      "publisher": uInfoMap,
    });

    if (videoModel == null) {
      return;
    }

    bool isCached = CachedVideoStore().inCachedList(videoModel?.sourceURL);
    if (isCached) {
      showToast(msg: Lang.ALREADY_CACHED_TIP);
      return;
    }

    // ///检查今日是否已缓存10次视频
    // bool isCachedLimit =
    //     await CachedVideoStore().checkVideoCachedCountInToday();
    // if (isCachedLimit) {
    //   showToast(msg: "今日已缓存10次视频～");
    //   return;
    // }

    CachedVideoStore().setCachedVideo(videoModel, cacheType: CACHED_TYPE_SHORT);
    showToast(msg: "已加入缓存");
  }
}
