import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/ai/AIVideoPage.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

class MineViewVideoCell extends StatefulWidget {
  final int index;
  final bool isCache;
  final VideoModel videoModel;
  final Function(VideoModel) delCall;

  MineViewVideoCell(this.index, this.videoModel, {this.isCache = false, this.delCall});

  @override
  State<StatefulWidget> createState() {
    return _MineViewVideoCellState();
  }
}

class _MineViewVideoCellState extends State<MineViewVideoCell> {
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    bus.on(EventBusUtils.changeEditStatus, (arg) {
      setState(() {
        isEdit = arg;
      });
    });
  }

  void _deleteVideo(String videoId) {
    if (widget.isCache)
      _deleteCacheVideo(videoId);
    else
      _deleteCollectVideo(videoId);
  }

  ///删除(取消)收藏视频
  void _deleteCollectVideo(String videoId) async {
    try {
      await netManager.client.changeTagStatus(videoId, false, "video");
      bus.emit(EventBusUtils.delVideoCollect, widget.index);
      await Future.delayed(Duration(milliseconds: 500));
      showToast(msg: "删除成功~");
    } catch (e) {
      l.e("_deleteCollectVideo", "删除失败:$e");
    }
  }

  ///删除缓存视频
  void _deleteCacheVideo(String videoId) async {
    try {
      //删除短视频离线缓存
      await CachedVideoStore().deleteBatch([videoId]);

      await Future.delayed(Duration(milliseconds: 500));
      bus.emit(EventBusUtils.delVideoCache);
      showToast(msg: "删除成功～");
    } catch (e) {
      l.d("删除失败", "$e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.videoModel.id == "-1") {
          //AI视频换脸
          pushToPage(AiVideoPage(widget.videoModel.sourceURL, "AI视频换脸"), opaque: true);
        } else {
          Map<String, dynamic> maps = Map();
          maps["videoId"] = widget.videoModel.id;
          Gets.Get.to(FilmTvVideoDetailPage().buildPage(maps), opaque: false);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              fit: StackFit.expand,
              children: [
                ///视频封面
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  child: CustomNetworkImage(
                    imageUrl: widget.videoModel.cover,
                    fit: BoxFit.cover,
                    type: ImgType.cover,
                    height: 113,
                  ),
                ),

                Visibility(
                  visible: isEdit,
                  child: Positioned.fill(
                    child: InkWell(
                      onTap: () => _deleteVideo(widget.videoModel.id),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Image.asset("assets/images/delete_icon.png", width: 30, height: 30),
                        ),
                      ),
                    ),
                  ),
                ),

                ///播放次数
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 18,
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.4),
                    child: Padding(
                      padding: EdgeInsets.only(left: 6, right: 6, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${getShowFansCountStr(widget.videoModel.playCount)}播放",
                                style: TextStyle(
                                  color: Color.fromRGBO(227, 227, 227, 1),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          widget.videoModel.playTime == null
                              ? SizedBox()
                              : Text(
                                  TimeHelper.getTimeText(widget.videoModel.playTime.toDouble()),
                                  style: TextStyle(color: Color.fromRGBO(227, 227, 227, 1), fontSize: 10),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          ///视频标题
          Text(
            widget.videoModel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
