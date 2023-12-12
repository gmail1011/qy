import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinBuyAlert extends StatefulWidget {
  final VideoModel videoModel;

  CoinBuyAlert({Key key, this.videoModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CoinBuyAlertState();
  }
}

class _CoinBuyAlertState extends State<CoinBuyAlert> {
  bool inSufficentBalance = false; // true 余额不足

  bool get hasDiscount {
    if ((widget.videoModel?.coins ?? 0) > 0 &&
        (widget.videoModel?.coins != widget.videoModel?.originCoins)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
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
                "本内容需购买解锁",
                style: TextStyle(fontSize: 16.nsp, color: Colors.black),
              ),
              SizedBox(height: 8.w),
              Container(
                height: 1.w,
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              SizedBox(height: 12.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "该内容由UP主[${widget.videoModel.publisher.name ?? ""}]上传，并设置价格为：",
                    style: TextStyle(
                        fontSize: 11.nsp, color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
              SizedBox(height: 21.w),
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
                    SizedBox(width: 6.w),
                    if (hasDiscount)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: widget.videoModel.coins?.toString() ?? "",
                              style: TextStyle(
                                fontSize: 47.nsp,
                                color: Color.fromRGBO(23, 23, 23, 1),
                              ),
                            ),
                            TextSpan(text: "     "),
                            TextSpan(
                              text: "原价",
                              style: TextStyle(
                                fontSize: 16.nsp,
                                color: Color.fromRGBO(132, 132, 132, 1),
                              ),
                            ),
                            TextSpan(
                              text:
                                  (widget.videoModel.originCoins?.toString() ??
                                          "") +
                                      "金币",
                              style: TextStyle(
                                fontSize: 21.nsp,
                                color: Color.fromRGBO(98, 98, 98, 1),
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Color.fromRGBO(98, 98, 98, 1),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        GlobalStore.isVIP()
                            ? widget.videoModel.coins.toString()
                            : widget.videoModel.originCoins.toString(),
                        style: TextStyle(
                            fontSize: 47.nsp,
                            color: Color.fromRGBO(23, 23, 23, 1)),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 21.w),
              _buildButton(),
              SizedBox(height: 21.w),
              Container(
                height: 1.w,
                color: Color.fromRGBO(230, 230, 230, 1),
              ),
              SizedBox(height: 8.w),
              Text(
                "* 作者原创不易，会持续上传更多优秀作品",
                style: TextStyle(
                    fontSize: 10.nsp, color: Color.fromRGBO(23, 23, 23, 0.8)),
              ),
              SizedBox(height: 4.w),
              Text(
                "* 朋友都可上传，分享你的幸福生活",
                style: TextStyle(
                    fontSize: 10.nsp, color: Color.fromRGBO(23, 23, 23, 0.8)),
              ),
              SizedBox(height: 18.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    if (inSufficentBalance) {
      return GestureDetector(
        onTap: () {
          /* Gets.Get.to(MemberCentrePage()
                                 .buildPage({"position": "1"}),
                             ).then((value) {
                                 safePopPage(false);
                             });*/
          Config.videoModel = widget.videoModel;
          Config.payFromType = PayFormType.video;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return MemberCentrePage().buildPage({"position": "1"});
            },
          )).then((value) {
            safePopPage(false);
          });
          AnalyticsEvent.clickBuyMembership(
              widget.videoModel.title,
              widget.videoModel.id,
              (widget.videoModel.tags ?? []).map((e) => e.name).toList(),
              VipPopUpsType.gold);
        },
        child: Container(
          height: 36.w,
          width: 210,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.w / 2),
              gradient: LinearGradient(
                colors: AppColors.buttonWeiBo,
              )),
          child: Text(
            "余额不足，前往充值",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
    } else {
      if (!GlobalStore.isVIP()) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  Config.videoModel = widget.videoModel;
                  Config.payFromType = PayFormType.video;
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return MemberCentrePage().buildPage({"position": "0"});
                    },
                  )).then((value) {
                    safePopPage(false);
                  });
                  AnalyticsEvent.clickBuyMembership(
                      widget.videoModel.title,
                      widget.videoModel.id,
                      (widget.videoModel.tags ?? [])
                          .map((e) => e.name)
                          .toList(),
                      VipPopUpsType.vip);
                },
                child: Container(
                  height: 36.w,
                  width: 116,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36.w / 2),
                    gradient: LinearGradient(
                      colors: AppColors.buttonWeiBo,
                    ),
                  ),
                  child: Text(
                    "VIP优惠购买",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  try {
                    await netManager.client.postBuyVideo(
                        widget.videoModel.id,
                        widget.videoModel.title,
                        GlobalStore.isVIP()
                            ? widget.videoModel.coins
                            : widget.videoModel.originCoins,
                        1);
                    safePopPage(true);
                  } on DioError catch (e) {
                    var error = e.error;
                    if (error is ApiException) {
                      if (error.code == 8000) {
                        inSufficentBalance = true;
                        setState(() {});
                      }
                    } else {
                      showToast(msg: e.toString());
                    }
                  } catch (e) {}
                },
                child: Container(
                  height: 36.w,
                  width: 116,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36.w / 2),
                    border: Border.all(
                        color: Color.fromRGBO(150, 150, 150, 1), width: 1),
                  ),
                  child: Text(
                    "确认支付",
                    style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        return GestureDetector(
          onTap: () async {
            try {
              await netManager.client.postBuyVideo(
                  widget.videoModel.id,
                  widget.videoModel.title,
                  GlobalStore.isVIP()
                      ? widget.videoModel.coins
                      : widget.videoModel.originCoins,
                  1);
              safePopPage(true);
            } on DioError catch (e) {
              var error = e.error;
              if (error is ApiException) {
                if (error.code == 8000) {
                  inSufficentBalance = true;
                  setState(() {});
                }
              } else {
                showToast(msg: e.toString());
              }
            } catch (e) {}
          },
          child: Container(
            height: 36.w,
            width: 210,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.w / 2),
                gradient: LinearGradient(
                  colors: AppColors.buttonWeiBo,
                )),
            child: Text(
              "确认支付",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
    }
  }
}
