import 'package:expandable_text/expandable_text.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/anwang_trade/widget/MyVIdeoCollectListDialogView.dart';
import 'package:flutter_app/page/city/city_video/page.dart';
import 'package:flutter_app/page/user/common/picture_word/action.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/community_recommend/topic_detail/topic_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:like_button/like_button.dart';

import '../module_type.dart';
import 'state.dart';

///图文公用UI
Widget buildView(
    PictureWordState state, Dispatch dispatch, ViewService viewService) {
  return BaseRequestView(
    retryOnTap: () => dispatch(PictureWordActionCreator.refreshVideo()),
    controller: state.requestController,
    child:
    Stack(
      children: [
        pullYsRefresh(
          refreshController: state.refreshController,
          onRefresh: () => dispatch(PictureWordActionCreator.refreshVideo()),
          onLoading: () => dispatch(PictureWordActionCreator.picListLoadMore()),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(top: 8),
                sliver: SliverList(
                  delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                    if (state.pictureVideoModelList == null) {
                      return Container();
                    }
                    return _buildPictureModelStack(state, dispatch, context, index);
                  }, childCount: state.pictureVideoModelList?.length ?? 0),
                ),
              ),
            ],
          ),
        ),
        ((state.moduleType==ModuleType.PICTRUE_WORD_MY_FAVORITE) && (state.isPicWordEditModel??false))?Positioned(child: Row(
          children: [
            SizedBox(width: 16,),
            Expanded(child: GestureDetector(
              onTap: (){
                List<String> vIds = [];
                for(var model in state.pictureVideoModelList){
                  if(model.selected??false){
                    vIds.add(model.id);
                  }
                }
                dispatch(PictureWordActionCreator.collectBatch(vIds));
              },
              child: Container(
                height: 44,
                alignment: Alignment.center,
                child: Text("删除",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(254, 127, 15, 1),
                          Color.fromRGBO(234, 139, 37, 1),
                        ]
                    )
                ),
              ),
            ),),
            SizedBox(width: 16,),
            Expanded(child: GestureDetector(
              onTap: (){
                showDialog(
                    context: viewService.context,
                    barrierDismissible: false,
                    barrierColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return MyVideoCollectListDialogView((cId) async {
                        List<String> vIds = [];
                        for(var model in state.pictureVideoModelList){
                          if(model.selected??false){
                            vIds.add(model.id);
                          }
                        }
                        if(vIds.length==0){
                          showToast(msg: "没有选择图文");
                          return;
                        }
                        await netManager.client.postWorkUnitVideoAdd(cId, vIds);
                        showToast(msg: "添加成功");
                      });
                    });
              },
              child: Container(
                height: 44,
                alignment: Alignment.center,
                child: Text("添加列表",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(254, 127, 15, 1),
                          Color.fromRGBO(234, 139, 37, 1),
                        ]
                    )
                ),
              ),
            ),),
            SizedBox(width: 16,),
          ],),left: 0,right: 0,bottom: 10,):SizedBox(),
      ],
    )

  );
}

///创建图文列表UI
Stack _buildPictureModelStack(PictureWordState state, Dispatch dispatch,
    BuildContext context, int index) {
  VideoModel pictureModel = state.pictureVideoModelList[index];
  return Stack(
    alignment: Alignment.center,
    children: [
      GestureDetector(
        onTap: () {
          if (state.isPicWordEditModel) {
            return;
          }
          Gets.Get.to(
              CommunityDetailPage().buildPage({"videoId": pictureModel?.id}),
              opaque: false);
        },
        child: Container(
          color: AppColors.weiboJianPrimaryBackground,
          margin: EdgeInsets.only(bottom: 9.w),
          padding:
              EdgeInsets.only(left: 16.w, top: 11.w, right: 16.w, bottom: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfoUI(dispatch, pictureModel, index),
              SizedBox(height: 12.w),

              _buildExpandableText(pictureModel),
              SizedBox(height: 4.w),

              _buildTagsWrapUI(pictureModel),

              SizedBox(height: 8.w),

              _buildPictureGridUI(pictureModel),
              SizedBox(height: 8.w),

              ///创建操作功能按钮
              _buildOperateFuncButtonUI(pictureModel, dispatch, context),
            ],
          ),
        ),
      ),

      ///删除图文

      Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child:   Visibility(
          visible: state.isPicWordEditModel ?? false,
          child: (state.moduleType==ModuleType.PICTRUE_WORD_MY_FAVORITE)?Container(
            alignment: Alignment.topRight,
            color: Colors.black.withAlpha(200),
            child: GestureDetector(
                onTap: () {
                  state.pictureVideoModelList[index].selected = !(state.pictureVideoModelList[index].selected??false);
                  dispatch(PictureWordActionCreator.updateUI());
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5,right: 5),
                  child: state.pictureVideoModelList[index].selected??false?Image.asset("assets/images/unit_selected.png",width: 20,height: 20,):Image.asset("assets/images/unit_unselected.png",width: 20,height: 20,),
                )
            ),
          ):Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withAlpha(200),
              child: GestureDetector(
                onTap: () => dispatch(
                    PictureWordActionCreator.deleteCollect(pictureModel?.id)),
                child: Image(
                  image: AssetImage(AssetsImages.ICON_MINE_DEL),
                  width: 42.w,
                  height: 42.w,
                ),
              ),
            ),
          ),
        ),

      ),
    ],
  );
}

///创建tag UI
Wrap _buildTagsWrapUI(VideoModel pictureModel) {
  return Wrap(
    spacing: 5.w,
    runSpacing: 3.w,
    alignment: WrapAlignment.start,
    children: pictureModel.tags.map((e) {
      return GestureDetector(
        onTap: () {
          Gets.Get.to(TopicDetailPage().buildPage({"tagsBean": e}),
              opaque: false);
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Text(
            "#${e.name}",
            style: TextStyle(
                color: Color.fromRGBO(126, 160, 190, 1), fontSize: 16.nsp),
          ),
        ),
      );
    }).toList(),
  );
}

///创建图文网络列表
Widget _buildPictureGridUI(pictureModel) {
  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            _getCrossAxisCount(pictureModel?.seriesCover?.length ?? 0),
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio:
            _getChildAspectRatio(pictureModel?.seriesCover?.length ?? 0)),
    itemCount: ((pictureModel?.seriesCover?.length ?? 0) > 6
        ? 6
        : (pictureModel?.seriesCover?.length ?? 0)),
    itemBuilder: (BuildContext context, int index) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: GestureDetector(
          onTap: () {
            showPictureSwipe(context, pictureModel?.seriesCover, index,
                imageTyp: ImageTyp.NET);
          },
          child: Stack(
            children: [
              CustomNetworkImage(
                fit: BoxFit.cover,
                height:
                    _getPictureItemSize(pictureModel?.seriesCover?.length ?? 0),
                width:
                    _getPictureItemSize(pictureModel?.seriesCover?.length ?? 0),
                imageUrl: pictureModel?.seriesCover[index],
              ),
              Visibility(
                visible:
                    index == 5 && (pictureModel?.seriesCover?.length ?? 0) > 6
                        ? true
                        : false,
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      showPictureSwipe(
                          context, pictureModel?.seriesCover, index,
                          imageTyp: ImageTyp.NET, videoModel: pictureModel);
                    },
                    child: Container(
                      width: 128.w,
                      height: 128.w,
                      alignment: Alignment.center,
                      color: Colors.black.withOpacity(0.6),
                      child: Text(
                        "+" +
                            ((pictureModel?.seriesCover?.length ?? 0) - 6)
                                .toString(),
                        style: TextStyle(fontSize: 20.w, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

///创建用户信息UI
Widget _buildUserInfoUI(Dispatch dispatch, VideoModel pictureModel, int index) {
  bool isNomalVip = (pictureModel?.publisher?.isVip ?? false) &&
      (pictureModel?.publisher?.vipLevel ?? 0) > 0;
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
          headHeight: 52.w,
          headWidth: 52.w,
          level: (pictureModel?.publisher?.superUser ?? false)  ? 1 : 0,
        ),
      ),

      SizedBox(width: 8.w),
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
            child: Row(
              children: [
                Text(
                  (pictureModel?.publisher?.name ?? "").isNotEmpty
                      ? ((pictureModel?.publisher?.name?.length ?? 0) > 9
                          ? pictureModel?.publisher?.name?.substring(0, 9)
                          : pictureModel?.publisher?.name)
                      : "",
                  softWrap: true,
                  maxLines: 1,
                  style: TextStyle(
                      color: isNomalVip
                          ? Color.fromRGBO(246, 197, 89, 1)
                          : Colors.white,
                      fontSize: 18.nsp),
                ),
                SizedBox(width: 4.w),
                buildHonorLevelUI(
                    hasKingIcon: isNomalVip,
                    honorLevelList: pictureModel?.publisher?.awardsExpire),
              ],
            ),
          ),
          SizedBox(height: 6.w),
          Row(
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  // if ((pictureModel?.location?.city ?? "").isEmpty) {
                  //   return;
                  // }
                  // Map<String, String> parameter = {
                  //   "city": pictureModel?.location?.city ?? "",
                  //   "id": pictureModel?.location?.id ?? "",
                  // };
                  // Gets.Get.to(CityVideoPage().buildPage(parameter),
                  //     opaque: false);
                },
                child: Row(
                  children: [
                    // Image.asset(
                    //   "assets/weibo/dingwei.png",
                    //   width: 16.w,
                    //   height: 16.w,
                    // ),
                    // SizedBox(width: 8.w),
                    Text(
                      pictureModel?.publisher?.upTag ?? "",
                      style: TextStyle(
                          color: Color.fromRGBO(124, 135, 159, 1),
                          fontSize: 13.w),
                    ),
                    SizedBox(width: 16.w),
                  ],
                ),
              ),


              Text(
                formatTime(pictureModel?.createdAt),
                style: TextStyle(
                    color: Color.fromRGBO(124, 135, 159, 1), fontSize: 13.w),
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
          onTap: () {
            if ((pictureModel?.publisher?.uid ?? 0) == 0) {
              return;
            }
            dispatch(PictureWordActionCreator.followUser(
                pictureModel?.publisher?.uid));
          },
          child: Image.asset(
            "assets/weibo/guanzhu.png",
            width: 68.w,
            height: 26.w,
          ),
        ),
      ),
    ],
  );
}

///创建消息显示文本
Widget _buildExpandableText(VideoModel pictureModel) {
  return ExpandableText(
    pictureModel?.title ?? "",
    key: Key("${pictureModel?.id}"),
    textAlign: TextAlign.left,
    expandText: '全文',
    collapseText: '收起',
    maxLines: 3,
    style: TextStyle(color: Colors.white, fontSize: 16.nsp),
    linkColor: Color(0xFFD17E21),
  );
}

///创建操作功能按钮
Widget _buildOperateFuncButtonUI(
    VideoModel pictureModel, Dispatch dispatch, BuildContext context) {
  return Container(
    height: 34.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            "浏览次数:${getShowCountStr(pictureModel?.playCount ?? 0)}",
            style:
                TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14.w),
          ),
        ),
        _buildShareItemUI(pictureModel, dispatch, context),
        _buildCommentItemUI(pictureModel, dispatch, context),

        // _buildLikeButtonUI(pictureModel, dispatch),
      ],
    ),
  );
}

///分享按钮
GestureDetector _buildCommentItemUI(
    VideoModel pictureModel, Dispatch dispatch, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (pictureModel?.status != 1) {
        //0 未审核 1通过 2审核失败 3视为免费 默认为0
        showToast(msg: Lang.GLOBAL_TIP_TXT2, gravity: ToastGravity.CENTER);
        return;
      }
      showCommentDialog(
        context: context,
        id: pictureModel?.id,
        index: 1,
        province: pictureModel?.location?.province ?? "",
        city: pictureModel?.location?.city ?? "",
        visitNum: "${pictureModel?.location?.visit ?? 0}",
        height: screen.screenHeight * 0.65,
        callback: (Map<String, dynamic> map) {},
      );
    },
    child: _buildSubMenuItemUI("assets/weibo/comment_image.png",
        "${(pictureModel?.commentCount ?? 0) > 0 ? getShowFansCountStr(pictureModel?.commentCount ?? 0) : "评论"}"),
  );
}

///执行分享UI
GestureDetector _buildShareItemUI(
    VideoModel pictureModel, Dispatch dispatch, BuildContext context) {
  return GestureDetector(
    onTap: () {
      showShareVideoDialog(context, () async {
        await Future.delayed(Duration(milliseconds: 500));
      },
          videoModel: pictureModel,
          isLongVideo: isHorizontalVideo(
              resolutionWidth(pictureModel.resolution),
              resolutionHeight(pictureModel.resolution)));
    },
    child: Container(
      color: Colors.transparent,
      key: pictureModel?.key,
      child: _buildSubMenuItemUI("assets/weibo/images/ic_make_money.png", "赚钱"),
    ),
  );
}

///创建操作功能菜单按钮
Widget _buildSubMenuItemUI(String imagePath, String countStr) {
  return Container(
    margin: EdgeInsets.only(right: 29.w),
    color: Colors.transparent,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 20.w,
          height: 20.w,
        ),
        SizedBox(width: 6.w),
        Text(
          countStr,
          style:
              TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14.w),
        ),
      ],
    ),
  );
}

///创建点赞按钮UI
Widget _buildLikeButtonUI(VideoModel pictureModel, Dispatch dispatch) {
  return LikeButton(
    size: 18,
    crossAxisAlignment: CrossAxisAlignment.center,
    likeCountPadding: EdgeInsets.only(left: 6.w),
    isLiked: pictureModel?.vidStatus?.hasCollected ?? false,
    circleColor: CircleColor(
        start: Color.fromRGBO(245, 75, 100, 1),
        end: Color.fromRGBO(245, 75, 100, 1)),
    bubblesColor: BubblesColor(
      dotPrimaryColor: Color.fromRGBO(245, 75, 100, 1),
      dotSecondaryColor: Color.fromRGBO(245, 75, 100, 1),
    ),
    likeBuilder: (bool isLiked) {
      return Image.asset(
        isLiked
            ? "assets/weibo/video_liked.png"
            : "assets/weibo/video_like_default.png",
        width: 20,
        height: 20,
      );
    },
    likeCount: pictureModel?.forwardCount ?? 0,
    likeCountAnimationType: LikeCountAnimationType.none,
    countBuilder: (int count, bool isLiked, String text) {
      var color = isLiked ? Color.fromRGBO(245, 75, 100, 1) : Colors.white;
      Widget result;
      if (count == 0) {
        result = Text(
          "收藏",
          style: TextStyle(color: color, fontSize: 14.w),
        );
      } else
        result = Text(
          getShowFansCountStr(int.parse(text)),
          style: TextStyle(color: color, fontSize: 14.w),
        );
      return result;
    },
    onTap: (isLiked) async {
      bool isCollect = !pictureModel.vidStatus.hasCollected;
      dispatch(PictureWordActionCreator.operateCollect(
          pictureModel?.id, isCollect ?? false));
      if (!isCollect) {
        pictureModel.forwardCount -= 1;
      } else {
        pictureModel.forwardCount += 1;
      }

      dispatch(PictureWordActionCreator.updateUI());
      pictureModel.vidStatus.hasCollected = isCollect;
      dispatch(PictureWordActionCreator.updateUI());

      // bool hasCollected = !(pictureModel?.vidStatus?.hasCollected ?? false);
      // if (!hasCollected) {
      //   pictureModel.forwardCount -= 1;
      // } else {
      //   pictureModel.forwardCount += 1;
      // }
      // pictureModel?.vidStatus?.hasCollected = !hasCollected;
      // dispatch(PictureWordActionCreator.updateUI());

      return !isLiked;
    },
  );
}

///计算展示横排个数
int _getCrossAxisCount(int seriesCoverLenth) {
  if (seriesCoverLenth < 3 || seriesCoverLenth == 4) {
    return 2;
  }
  return 3;
}

///计算展示比例
double _getChildAspectRatio(int seriesCoverLenth) {
  if (seriesCoverLenth < 3 || seriesCoverLenth == 4) {
    return 196 / 196;
  }
  return 128 / 128;
}

///获取图片girdView 高度
double _getPictureItemSize(int seriesCoverLenth) {
  if (seriesCoverLenth < 3 || seriesCoverLenth == 4) {
    return 196.w;
  }
  return 128.w;
}
