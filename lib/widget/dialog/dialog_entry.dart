import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/country_code_entity.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/comment/comment_list_page.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/day_mark_entity.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/page/wallet/pay_for/page.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_game_page/page.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_game_page/state.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/banner_recommend_widget.dart';
import 'package:flutter_app/widget/custom_purchase_videodialog.dart';
import 'package:flutter_app/widget/dialog/custom_yy_dialog.dart';
import 'package:flutter_app/widget/dialog/select_upload_widget.dart';
import 'package:flutter_app/widget/dialog/set_price_and_time_dialog.dart';
import 'package:flutter_app/widget/reward_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/task_manager/dialog_task_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'newdialog/coinVideo_dailog_hjll.dart';
import 'share_video_dialog.dart';

///展示评论
Future showCommentDialog({
  @required BuildContext context,
  @required String id,
  @required int index,
  double height,
  Color backgroundColor,
  double radius,
  String province,
  String city,
  String visitNum,
  CommentResult callback,
}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? Color(0xFF000000),
      //Color(0xffffffff)
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius ?? Dimens.pt10),
        topRight: Radius.circular(radius ?? Dimens.pt10),
      )),
      builder: (BuildContext context) {
        return Container(
          color: Color(0xff1f1f1f), //AppColors.weiboBackgroundColor,
          alignment: Alignment.topLeft,
          height: height ?? screen.screenHeight * 0.8,
          child: CommentListPage(id, commentResult: callback, footerComment: true, needReplay: true),
        );
      });
}

enum ImageTyp { FILE, ASSETS, NET }

///弹出图片查看组件(当前只支持网络图片)
showPictureSwipe(
  BuildContext context,
  List<String> picList,
  int index, {
  ImageTyp imageTyp,
  VideoModel videoModel,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "你好",
    barrierDismissible: true,
    transitionDuration: Duration(milliseconds: 200),
    // 构建 Dialog 的视图
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Container(
      color: Colors.black,
      /*child: GestureDetector(
              onVerticalDragEnd: (DragEndDetails details) {
                double ads = details?.primaryVelocity?.abs() ?? 0;
                l.e("ads", "$ads");
                if (ads > 500) {
                  // safePopPage();
                }
              },*/
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Center(
              child: BannerRecommendWidget(
                picList,
                selectIndex: index,
                tabDismiss: false,
                videoModel: videoModel,
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                ),
              ),
            ),
          ),
        ],
      ),
      // )
    ),
    useRootNavigator: false,
  );
}

///显示支付弹窗
Future showPayListDialog(BuildContext context, PayForArgs args) {
  var wd = PayForPage().buildPage(args);
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt17),
        topRight: Radius.circular(Dimens.pt17),
      )),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: screen.screenHeight * 0.65,
          child: wd,
        );
      });
}

///显示支付弹窗
Future showGamePayListDialog(BuildContext context, PayGameForArgs args) {
  var wd = PayForGamePage().buildPage(args);
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt17),
        topRight: Radius.circular(Dimens.pt17),
      )),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: screen.screenHeight * 0.65,
          child: wd,
        );
      });
}

///显示购买视频的弹框
Future showBuyVideo(BuildContext context, VideoModel videoModel) {
  if (videoModel.isReportFinish == false) {
    videoModel.isReportFinish = true;
    EventTrackingManager().addVideoDatas(videoModel.id, videoModel.title);
  }
  return newDialogTaskManager.addDialogNewTaskToQueue(
      () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomPurchaseVideoDialog(videoModel);
          }),
      uniqueId: "showBuyVideo");
}

Future showBuyVideoHjll(BuildContext context, VideoModel videoModel) {
  if (videoModel.isReportFinish == false) {
    videoModel.isReportFinish = true;
    EventTrackingManager().addVideoDatas(videoModel.id, videoModel.title);
  }
  return newDialogTaskManager.addDialogNewTaskToQueue(
      () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return CoinVideoDialogHjllView(viewModel: videoModel);
          }),
      uniqueId: "showBuyVideo");
}

///显示选择上传视频和图片的弹框
Future<UploadType> showUploadType(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withAlpha(125),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //   topLeft: Radius.circular(Dimens.pt10),
      //   topRight: Radius.circular(Dimens.pt10),
      // )),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SelectUploadWidget();
      });
}

/// 展示视频审核规则的dialog
Future showVideoReviewRuleDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
                onTap: () => safePopPage(),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimens.pt4),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: AppPaddings.padding8, vertical: AppPaddings.padding16),
                    child: ImageLoader.withP(ImageType.IMAGE_SVG,
                            width: (screen.screenWidth - 4 * AppPaddings.appMargin), address: AssetsSvg.CHECK_VIDEO_RULE)
                        .load()))
          ],
        );
      });
}

///显示配置价格和时间弹窗
Future showConfigPriceAndTimeDialog(BuildContext context, int currentDuration, int totalDuration, double coinValue) {
  return showDialog(
      context: context,
      builder: (context) {
        return SetPriceAndTimeView(coinValue, currentDuration, totalDuration);
      });
}

///打赏红包
Future showRewardDialog(BuildContext context, String videoId) {
  return showDialog<void>(
      context: context,
      builder: (context) {
        return RewardDialog(videoId);
        // Dialog(child: Container(width: 100,height: 100,color: Colors.red,));
      });
}

///显示标签页弹框
Future showPostListDialog(BuildContext context, Map<String, dynamic> config) {
  // var wd = PayForPage().buildPage(args);
  List<Widget> getList() {
    var keys = config.keys.toList();
    List<Widget> list = [];
    for (var i = 0; i < keys.length; i++) {
      list.add(
        GestureDetector(
          onTap: () {
            safePopPage();
            if (config[keys[i]] != null) {
              config[keys[i]]();
            }
          },
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: Dimens.pt10),
            child: Text(
              keys[i],
              style: TextStyle(fontSize: Dimens.pt16, color: Colors.black54),
            ),
          ),
        ),
      );
      if (i != keys.length - 1) {
        list.add(Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.pt20),
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(0, 0, 0, 0), Color.fromRGBO(0, 0, 0, 0.1), Color.fromRGBO(0, 0, 0, 0)],
            ),
          ),
        ));
      }
    }
    list.add(Container(
      height: Dimens.pt10,
      color: Color.fromRGBO(0, 0, 0, 0.08),
    ));
    list.add(
      GestureDetector(
        onTap: () {
          safePopPage();
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: Dimens.pt10),
          child: Text(
            '取消',
            style: TextStyle(
              fontSize: Dimens.pt16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
    return list;
  }

  var btmNum = MediaQuery.of(context).padding.bottom;
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt10),
        topRight: Radius.circular(Dimens.pt10),
      )),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ListView(
          children: getList(),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: btmNum == 0 ? 0 : 16, left: 0, right: 0),
        );
      });
}

showShareVideoDialog(
  BuildContext context,
  Function closeFunc, {
  VideoModel videoModel,
  String topicName,
  bool isLongVideo,
  bool isFvVideo,
  String titleDesc,
  String contentDesc,
  UserInfoModel userInfo,
}) {
  CustomYYDialog(closeFunc: closeFunc).build(context)
    ..widget(ShareVideoView(
      userData: userInfo ?? GlobalStore.getMe(),
      videoModel: videoModel,
      topicName: topicName,
      isLongVideo: isLongVideo,
      isFvVideo: isFvVideo,
      titleDesc: titleDesc,
      contentDesc: contentDesc,
    ))
    ..backgroundColor = Colors.transparent
    ..show();
}

///签到奖励对话框
Future showDayMarkDialog(BuildContext context, DayMarkData dayMarkData) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          height: screen.screenHeight * 0.65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Container(
              //   child: Image.asset(
              //     "assets/images/day_mark_success.png",
              //     height: Dimens.pt144,
              //     width: Dimens.pt144,
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(
                  left: Dimens.pt20,
                  right: Dimens.pt16,
                ),
                child: Text(
                  "第${dayMarkData.value}天连续签到奖励",
                  style: TextStyle(
                    //color: Color.fromRGBO(209, 0, 0, 1),
                    color: Colors.black,
                    fontSize: Dimens.pt18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: Dimens.pt16,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Dimens.pt20,
                  right: Dimens.pt16,
                ),
                child: Text(
                  dayMarkData.xList[dayMarkData.value - 1].prizes[1].name,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    fontSize: Dimens.pt18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: Dimens.pt10,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Dimens.pt20,
                  right: Dimens.pt16,
                ),
                child: Text(
                  dayMarkData.xList[dayMarkData.value - 1].prizes[0].name,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    fontSize: Dimens.pt18,
                    fontWeight: FontWeight.w600,
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

///展示国家区号对话框
Future showCountryCodeDialogUI(BuildContext context, List<CountryCodeList> codeList, Function callback) {
  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt17),
        topRight: Radius.circular(Dimens.pt17),
      )),
      // isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
            width: Dimens.pt284,
            margin: EdgeInsets.only(top: Dimens.pt16),
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      callback(codeList[index].code);
                      safePopPage(context);
                    },
                    title: Text(
                      "${codeList[index].code} ${codeList[index].city}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 6);
                },
                itemCount: codeList.length ?? 0));
      });
}
