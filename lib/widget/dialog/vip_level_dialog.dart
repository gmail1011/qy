import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

/// 显示vipdialog isJump 是否在dialog 内部处理跳转事件
Future<int> showVipLevelDialog(
  BuildContext context,
  String content, {
  bool isJump = true,
  bool barrierDismissibleValue = true,
}) {
  return showGeneralDialog<int>(
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
    barrierColor: Colors.black.withOpacity(.4),
    barrierDismissible: barrierDismissibleValue,
    barrierLabel: "",
    transitionDuration: Duration(milliseconds: 200),
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(199, 255, 249, 1),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: Dimens.pt24),
                      child: Column(
                        children: <Widget>[
                          Text(
                            Lang.VIP_LEVEL_DIALOG_TITLE,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0),
                                  Colors.black,
                                  Colors.black.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            content,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            safePopPage(1);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Dimens.pt36,
                            width: Dimens.pt120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(42),
                                color: Colors.black.withOpacity(0.2)
                            ),
                            child: Text(
                              "稍后再说",
                              style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            if (isJump) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                return RechargeVipPage("");
                              }));
                            } else {
                              safePopPage(2);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Dimens.pt36,
                            width: Dimens.pt120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(42),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(97, 254, 238, 1),
                                  Color.fromRGBO(1, 214, 190, 1),
                                ],
                              ),
                            ),
                            child: Text(
                              "开通会员",
                              style: TextStyle(fontSize: Dimens.pt14, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
