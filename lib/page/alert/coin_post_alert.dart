import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

class CoinPostAlert extends StatelessWidget {

  final VideoModel videoModel;

  const CoinPostAlert({Key key, this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, states) {
      bool inSufficentBalance = false;
      return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 235, 217, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              //height: 264.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 18.w,
                  ),
                  Text(
                    "本图集需要购买解锁",
                    style: TextStyle(
                        fontSize: 16.nsp, color: Colors.black),
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  Container(
                    height: 1.w,
                    color: Color.fromRGBO(230, 230, 230, 1),
                  ),
                  SizedBox(
                    height: 12.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "该内容由UP主[${videoModel.publisher.name ?? ""}]上传，并设置价格为：",
                        style: TextStyle(
                            fontSize: 11.nsp,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 21.w,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 6.w),
                          child: Image.asset(
                            "assets/weibo/video_buy_icon.png",
                            width: 27.w,
                            height: 27.w,
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Text(
                          GlobalStore.isVIP()
                              ? videoModel.coins.toString()
                              : videoModel.originCoins
                              .toString(),
                          style: TextStyle(
                              fontSize: 47.nsp,
                              color: Color.fromRGBO(23, 23, 23, 1)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 21.w,
                  ),
                  inSufficentBalance
                      ? GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) {
                          Config.payFromType = PayFormType.banner;
                          Config.payBuyType = 2;
                          return MemberCentrePage()
                              .buildPage({"position": "1"});
                        },
                      )).then((value) {
                        safePopPage(false);
                      });
                      /*Gets.Get.to(
                                      MemberCentrePage()
                                      .buildPage({"position": "1"}),
                                      ).then((value) {
                                    safePopPage(false);
                                  });*/
                    },
                    child: Image.asset(
                      "assets/weibo/insufficent_balance.png",
                      width: 228.w,
                      height: 36.w,
                    ),
                  )
                      : GestureDetector(
                    onTap: () async {
                      try {
                        await netManager.client.postBuyVideo(
                            videoModel.id,
                            videoModel.title,
                            GlobalStore.isVIP()
                                ? videoModel.coins
                                : videoModel.originCoins,
                            1);
                        safePopPage(true);
                      } on DioError catch (e) {
                        var error = e.error;
                        if (error is ApiException) {
                          if (error.code == 8000) {
                            inSufficentBalance = true;
                            states(() {});
                            Config.videoModel = videoModel;
                            Config.payFromType = PayFormType.video;
                            AnalyticsEvent.clickBuyMembership(videoModel.title, videoModel.id,(videoModel.tags ?? []).map((e) => e.name).toList(), VipPopUpsType.atlasGold);
                          }
                        } else {
                          showToast(msg: e.toString());
                        }
                      } catch (e) {}
                    },
                    child: Image.asset(
                      "assets/weibo/video_buy_confirm.png",
                      height: 36.w,
                    ),
                  ),
                  SizedBox(
                    height: 21.w,
                  ),
                  Container(
                    height: 1.w,
                    color: Color.fromRGBO(230, 230, 230, 1),
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  Text(
                    "* 作者原创不易，会持续上传更多优秀作品",
                    style: TextStyle(
                        fontSize: 10.nsp,
                        color: Color.fromRGBO(23, 23, 23, 0.8)),
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  Text(
                    "* 朋友都可上传，分享你的幸福生活",
                    style: TextStyle(
                        fontSize: 10.nsp,
                        color: Color.fromRGBO(23, 23, 23, 0.8)),
                  ),
                  SizedBox(
                    height: 18.w,
                  ),
                ],
              ),
            ),
          ));
    });
  }
}