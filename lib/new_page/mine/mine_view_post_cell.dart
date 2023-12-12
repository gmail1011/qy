import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:like_button/like_button.dart';

class MineViewPostCell extends StatefulWidget {
  final int index;
  final VideoModel pictureModel;

  MineViewPostCell(this.index, this.pictureModel);

  @override
  State<StatefulWidget> createState() {
    return _MineViewPostCellState();
  }
}

class _MineViewPostCellState extends State<MineViewPostCell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff161e2c),
      margin: EdgeInsets.only(bottom: 9),
      padding: EdgeInsets.only(left: 16, top: 11, right: 16, bottom: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {
                  Gets.Get.to(CommunityDetailPage().buildPage({"videoId": widget.pictureModel?.id}),
                      opaque: false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///用户信息
                    _buildUserInfoUI(widget.pictureModel, widget.index),
                    SizedBox(height: 6),

                    ///帖子标题
                    Row(
                      children: [
                        Visibility(
                          visible: getTag() != "",
                          child: Container(
                            width: 31,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                                gradient: LinearGradient(
                                    colors: [const Color(0xff84a4f9), const Color(0xff2b5dde)])),
                            child: Center(
                              child: Text(
                                getTag(),
                                style: const TextStyle(color: const Color(0xffffffff), fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          widget.pictureModel.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: const Color(0xffffffff), fontSize: 14.0),
                        )
                      ],
                    ),
                    SizedBox(height: 4),

                    widget.pictureModel.newsType == "SP"
                        ? Container(

                    )
                        : Stack(
                            children: [
                              GridView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1),
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                      child: CustomNetworkImage(
                                        imageUrl: widget.pictureModel.seriesCover[index],
                                        height: 121,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  }),
                              Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Visibility(
                                    visible: widget.pictureModel.seriesCover.length > 3,
                                    child: Container(
                                      width: 27,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(3)),
                                          color: const Color(0x80000000)),
                                      child: Center(
                                        child: Text(
                                          "+${widget.pictureModel.seriesCover.length - 3}",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              ///底部操作菜单
              Container(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/hjll_video_item_icon_view.png",
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            (widget.pictureModel?.commentCount ?? 0) == 0
                                ? ""
                                : getShowCountStr(widget.pictureModel.commentCount),
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(right: 10),
                      child: LikeButton(
                        size: 18,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        likeCountPadding: EdgeInsets.only(left: 6),
                        isLiked: widget.pictureModel.vidStatus.hasCollected,
                        likeCountAnimationType: LikeCountAnimationType.none,
                        circleColor: CircleColor(
                            start: Color.fromRGBO(245, 75, 100, 1), end: Color.fromRGBO(245, 75, 100, 1)),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: Color.fromRGBO(245, 75, 100, 1),
                          dotSecondaryColor: Color.fromRGBO(245, 75, 100, 1),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Image.asset(
                            isLiked ? "assets/weibo/video_liked.png" : "assets/weibo/video_like_default.png",
                            width: 20,
                            height: 20,
                          );
                        },
                        likeCount: widget.pictureModel.forwardCount ?? 0,
                        countBuilder: (int count, bool isLiked, String text) {
                          var color =
                              isLiked ? Color.fromRGBO(245, 75, 100, 1) : Colors.white.withOpacity(0.6);

                          Widget result;
                          if (count == 0) {
                            result = Text(
                              "点赞",
                              style: TextStyle(color: color, fontSize: 16),
                            );
                          } else
                            result = Text(
                              getShowFansCountStr(count),
                              //count.toString(),
                              style: TextStyle(color: color, fontSize: 16),
                            );
                          return result;
                        },
                        onTap: (isLiked) async {
                          String type = 'video'; //img
                          if (widget.pictureModel.newsType == "SP") {
                            type = 'video';
                          } else if (widget.pictureModel.newsType == "COVER") {
                            type = 'img';
                          }
                          String objID = widget.pictureModel.id;
                          bool isCollect = !widget.pictureModel.vidStatus.hasCollected;
                          try {
                            await netManager.client.changeTagStatus(objID, isCollect, type);
                            if (!widget.pictureModel.vidStatus.hasCollected) {}
                            if (!isCollect) {
                              widget.pictureModel.forwardCount -= 1;
                            } else {
                              widget.pictureModel.forwardCount += 1;
                            }
                            widget.pictureModel.vidStatus.hasCollected = isCollect;
                          } catch (e) {
                            l.d('changeTagStatus', e.toString());
                          }
                          return !isLiked;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Gets.Get.to(CommunityDetailPage().buildPage({"videoId": widget.pictureModel?.id}),
                            opaque: false);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/hjll_video_item_icon_comment.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              (widget.pictureModel?.commentCount ?? 0) == 0
                                  ? "评论"
                                  : getShowCountStr(widget.pictureModel.commentCount),
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Visibility(
                      visible: getTagBeanFirst() != null,
                      child: GestureDetector(
                        onTap: () {
                          Map<String, dynamic> map = {'tagId': getTagBeanFirst().id};
                          JRouter().go(PAGE_TAG, arguments: map);
                        },
                        child: Text(
                          "#${getTagBeanFirst().name}",
                          style: const TextStyle(color: const Color(0xff61d3be), fontSize: 12.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Visibility(
              visible: false,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withAlpha(200),
                  child: GestureDetector(
                    onTap: () {},
                    child: Image(
                      image: AssetImage(AssetsImages.ICON_MINE_DEL),
                      width: 42,
                      height: 42,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///创建用户信息UI
  Widget _buildUserInfoUI(VideoModel pictureModel, int index) {
    bool isNomalVip =
        (pictureModel?.publisher?.isVip ?? false) && (pictureModel?.publisher?.vipLevel ?? 0) > 0;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Map<String, dynamic> arguments = {
              'uid': pictureModel?.publisher?.uid ?? 0,
              'uniqueId': DateTime.now().toIso8601String(),
            };
            Gets.Get.to(() => BloggerPage(arguments), opaque: false);
          },
          child: HeaderWidget(
            headPath: pictureModel?.publisher?.portrait,
            headHeight: 40,
            headWidth: 40,
            level: (pictureModel?.publisher?.superUser ?? false)  ? 1 : 0,
          ),
        ),

        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Map<String, dynamic> arguments = {
                  'uid': pictureModel?.publisher?.uid ?? 0,
                  'uniqueId': DateTime.now().toIso8601String(),
                };
                Gets.Get.to(() => BloggerPage(arguments), opaque: false);
              },
              child: Text(
                (pictureModel?.publisher?.name ?? "").isNotEmpty
                    ? ((pictureModel?.publisher?.name?.length ?? 0) > 9
                        ? pictureModel?.publisher?.name?.substring(0, 9)
                        : pictureModel?.publisher?.name)
                    : "",
                softWrap: true,
                maxLines: 1,
                style: TextStyle(
                    color: isNomalVip ? Color.fromRGBO(246, 197, 89, 1) : Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Visibility(
                    visible: widget.pictureModel.publisher.vipLevel > 0,
                    child: Container(
                      width: 52,
                      height: 15,
                      margin: EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          gradient:
                              LinearGradient(colors: [const Color(0xffeed9b4), const Color(0xffae8a5f)])),
                      child: Center(
                        child: Text("当前${getPublishVip()}",
                            style: const TextStyle(color: const Color(0xff663800), fontSize: 10.0),
                            textAlign: TextAlign.center),
                      ),
                    )),
                Text(
                  formatTime(pictureModel?.createdAt),
                  style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        Spacer(),

        // 关注请求
        Visibility(
          visible: !(pictureModel?.publisher?.hasFollowed ?? false),
          child: GestureDetector(
            key: Key("${pictureModel?.publisher?.uid}${pictureModel?.id}"),
            onTap: () async {
              if ((pictureModel?.publisher?.uid ?? 0) == 0) {
                return;
              }
              bool followed = !pictureModel.publisher.hasFollowed;
              try {
                await netManager.client.getFollow(pictureModel?.publisher?.uid, followed);
                setState(() {
                  pictureModel.publisher.hasFollowed = followed;
                });
              } catch (e) {
                l.d("执行关注操作错误", "$e");
                showToast(msg: "关注失败");
              }
            },
            child: Container(
              width: 63,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                border: Border.all(color: const Color(0xff61d3be), width: 1),
              ),
              child: Center(
                child: Text(
                  "+ 关注",
                  style: const TextStyle(color: const Color(0xff61d3be), fontSize: 12.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getTag() {
    return widget.pictureModel.isTopping
        ? "置顶"
        : widget.pictureModel.isRecommend
            ? "力荐"
            : widget.pictureModel.isChoosen
                ? "精选"
                : "";
  }

  String getPublishVip() {
    return widget.pictureModel.publisher?.vipLevel == 1
        ? "月卡会员"
        : widget.pictureModel.publisher?.vipLevel == 2
            ? "季卡会员"
            : widget.pictureModel.publisher?.vipLevel == 3
                ? "年卡会员"
                : widget.pictureModel.publisher?.vipLevel == 4
                    ? "永久会员"
                    : "";
  }

  TagsBean getTagBeanFirst() {
    if (widget.pictureModel.tags == null || widget.pictureModel.tags.isEmpty) {
      return null;
    }
    return widget.pictureModel.tags?.first;
  }
}
