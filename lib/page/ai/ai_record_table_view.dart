import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ai_record_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/ai/ai_new_image_view.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/utils/utils.dart';

import '../../widget/dialog/dialog_entry.dart';
import 'AIVideoPage.dart';

class AiRecordTableView extends StatefulWidget {
  final int status;
  final int pageType;
  const AiRecordTableView({
    Key key,
    this.status,
    this.pageType,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AiRecordTableViewState();
  }
}

class _AiRecordTableViewState extends State<AiRecordTableView> {
  int currentIndex = 1;
  int currentPage = 1;
  RefreshController _controller;
  List<AiRecordModel> modelList;
  GlobalKey _globalKey = GlobalKey();

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
      AiRecordEntity response;
      if(widget.pageType==0){
        response = await netManager.client.getAiRecordList(page, size, widget.status);
      }else if(widget.pageType==1){ //视频换脸，类型有改动 0 未完成; 1 已完成; -1 已退款

        var videoType =  widget.status-1;
        if(videoType==2){
          videoType = -1;
        }
        response = await netManager.client.getAiFaceRecordList(page, size, videoType);
      }else{
        response = await netManager.client.getAiFacePictureRecordList(page, size, widget.status);
      }
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
    if(mounted) {
      setState(() {});
    }
  }

  void _saveEvent() async {
    Future.delayed(Duration(milliseconds: 20), () async {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      bool suc = await savePngDataToAblumn(byteData.buffer.asUint8List());
      if (suc) {
        //showToast(msg: Lang.SAVE_PHOTO_ALBUM);
      }
    });
  }

  void _showNewPictureEvent(List<String> images) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AiNewImageView(
          imageUrls: images,
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
              height: 10,
              child: Row(
                children: [
                  // _buildMenuTitle("生成ID"),
                  // _buildMenuTitle("原图"),
                  //if (widget.status == 2) _buildMenuTitle("生成图"),
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

  Widget _buildMenuImage(String imagePaths, {bool hasLoad}) {
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
      onTap: () {
        if(widget.pageType==0 || widget.pageType==2){
          if (widget.status == 2) {
            if ((model.newPic?.isNotEmpty == true)) {
              List<String> images = [];
              model.newPic.forEach((element) {
                images.add(element.toString());
              });
              _showNewPictureEvent(images);
            }
          } else if (widget.status == 3) {
            showDelDialog(true, model);
          }
        }else{
          if (widget.status == 2) {
            pushToPage(AiVideoPage(model.url, "AI换脸"), opaque: true);
          } else if (widget.status == 3) {
            showDelDialog(true, model);
          }
        }

      },
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: Color(0xff242424),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            if (widget.status == 2)
               widget.pageType==0?_buildMenuImage(model?.newPic?.first ?? ""): widget.pageType==1?_buildMenuImage(model?.picture?.first ?? ""):_buildMenuImage(model?.newPic?.first ?? "")
            else
              (widget.pageType == 0 || widget.pageType == 2)?_buildMenuImage(
                  (model?.originPics == null || model?.originPics?.length == 0 ? model.originPic : model?.originPics?.first) ?? ""):_buildMenuImage(model?.picture?.first ?? ""),
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
            if (widget.status == 1)
              Container(
                width: 52,
                alignment: Alignment.center,
                child: Text(
                  "",//"生成中",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xff898989)),
                ),
              ),
            if (widget.status != 1)
              (widget.pageType == 0 || widget.pageType == 2)? GestureDetector(
                  onTap: () {
                    showDelDialog(false, model);
                  },
                  child: Image.asset(
                    "assets/images/hls_ai_icon_delete.png",
                    width: 20,
                    height: 20,
                  )):Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        bool isCached = CachedVideoStore().inCachedList(model?.url);
                        if (isCached) {
                          showToast(msg: Lang.ALREADY_CACHED_TIP);
                          return;
                        }
                        VideoModel viewModel = VideoModel();
                        viewModel.sourceURL = model?.url;
                        viewModel.title = "AI换脸视频";
                        viewModel.coverThumb = model?.picture?.first;
                        viewModel.cover = model?.picture?.first;
                        viewModel.commentCount = 0;
                        viewModel.id = "-1"; //特殊视频ID ，在视频下载列表做区分
                        CachedVideoStore().setCachedVideo(viewModel, cacheType: CACHED_TYPE_FILM);
                        showToast(msg: "已加入缓存");
                      },
                      child: Image.asset(
                        "assets/images/hls_ai_icon_download.png",
                        width: 20,
                        height: 20,
                      )),
                  SizedBox(width: 2,),
                  GestureDetector(
                      onTap: () {
                        showDelDialog(false, model);
                      },
                      child: Image.asset(
                        "assets/images/hls_ai_icon_delete.png",
                        width: 20,
                        height: 20,
                      )),
                ],
              ),
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
                if (model.status == 3 && isShowRemark)
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
                          loadingWidget.show(context);
                          if(widget.pageType==0){
                            dynamic response = await netManager.client.deleteAiBill(model.id);
                          }else if( widget.pageType==1){
                            dynamic response = await netManager.client.deleteAiFaceBill(model.id);
                          }else{
                            dynamic response = await netManager.client.deleteAiImageFaceBill(model.id);
                          }
                          setState(() {
                            modelList.remove(model);
                          });
                          showToast(msg: '删除成功');
                          loadingWidget.cancel();
                          safePopPage();
                        },
                        child: Text(
                          "确定",
                          style:
                              TextStyle(color: AppColors.primaryTextColor, fontSize: 18),
                        )),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
