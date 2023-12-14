import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:get/route_manager.dart' as Gets;

enum VipAlertType {
  vip,
  sign, // 签到权限
  post, //  发帖
  background, // 背景
  createUnit, //新建合集
  vipPostImg, // 社区图像贴
  vipWithdraw, // 取款
  descText, // 自定义文本
  ai, // ai脱衣
  message, // 私聊跳转
  cache, // 缓存
  oneButton,
  twoButton,
}

class VipRankAlert extends StatefulWidget {
  final VipAlertType type;
  final String descText;

  const VipRankAlert({
    Key key,
    this.type = VipAlertType.vip,
    this.descText,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VipRankAlertState();
  }

  static show(BuildContext context, {VipAlertType type, String descText}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return VipRankAlert(
          type: type,
          descText: descText,
        );
      },
    );
  }
}

class _VipRankAlertState extends State<VipRankAlert> {
  String get descText {
    if (widget.type == VipAlertType.sign) {
      return "充值VIP才能签到";
    } else if (widget.type == VipAlertType.vip) {
      return "您还不是VIP无法评论";
    } else if (widget.type == VipAlertType.post) {
      return "今日上传已达上限\n开通会员/大V无限上传";
    } else if (widget.type == VipAlertType.background) {
      return "您还不是VIP无法自定义背景";
    } else if (widget.type == VipAlertType.createUnit) {
      return "您还不是VIP无法创建合集";
    } else if (widget.type == VipAlertType.vipPostImg) {
      return "您还不是VIP无法查看更多图片";
    } else if (widget.type == VipAlertType.vipWithdraw) {
      return "您还不是VIP无法提现";
    } else if (widget.type == VipAlertType.ai) {
      return "您还不是VIP无法使用AI脱衣";
    } else if (widget.type == VipAlertType.message) {
      return "您还不是VIP无法进行查看哦";
    } else if (widget.type == VipAlertType.cache) {
      return "您还不是VIP无法进行视频缓存哦";
    }
    return widget.descText ?? "";
  }

  String get titleText {
    if (widget.type == VipAlertType.createUnit) {
      return "新建合集";
    }
    return "温馨提示";
  }

  @override
  Widget build(BuildContext context) {
    double scale = MediaQuery.of(context).size.width / 428;
    if (scale > 1) scale = 1;
    if (scale < 0.88) scale = 0.88;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 352 * scale,
            // height: 176 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Color(0xff2e2e2e),
                  Color(0xff2e2e2e),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.1),
                ),
                SizedBox(height: 28 * scale),
                _buildDescText(scale),
                SizedBox(height: 26 * scale),
                if (widget.type == VipAlertType.vip ||
                    widget.type == VipAlertType.createUnit ||
                    widget.type == VipAlertType.background ||
                    widget.type == VipAlertType.vipPostImg ||
                    widget.type == VipAlertType.vipWithdraw ||
                    widget.type == VipAlertType.descText ||
                    widget.type == VipAlertType.message ||
                    widget.type == VipAlertType.cache ||
                    widget.type == VipAlertType.sign ||
                    widget.type == VipAlertType.ai)
                  _buildSimpleButton(scale)
                else if (widget.type == VipAlertType.post)
                  _buildDoubleButton(scale)
                else
                  SizedBox(),
                SizedBox(height: 32 * scale),
              ],
            ),
          ),
          SizedBox(height: 24),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildDescText(double scale) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        descText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18 * scale,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSimpleButton(double scale) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
      },
      child: Container(
        width: 164 * scale,
        height: 42 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42 * scale / 2),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryTextColor,
               AppColors.primaryTextColor,
            ],
          ),
        ),
        child: Text(
          (widget.type == VipAlertType.createUnit) ? "成为VIP" : "开通会员",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 * scale,
          ),
        ),
      ),
    );
  }

  Widget _buildDoubleButton(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            Config.payFromType = PayFormType.user;
            Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
          },
          child: Container(
            width: 132 * scale,
            height: 42 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42 * scale / 2),
              color: Colors.white.withOpacity(0.3)
            ),
            child: Text(
              "稍后再说",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * scale,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            JRouter().jumpPage(MY_CERTIFICATION_PAGE);
          },
          child: Container(
            width: 132 * scale,
            height: 42 * scale,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42 * scale / 2),
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryTextColor,
                   AppColors.primaryTextColor,
                ],
              ),
            ),
            child: Text(
              "开通大V",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * scale,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Image.asset(
        "assets/images/alert_white_close.png",
        height: 36,
        width: 36,
      ),
    );
  }
}
