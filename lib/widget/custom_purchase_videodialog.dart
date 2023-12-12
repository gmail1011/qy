import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:dio/dio.dart';

///购买视频对话框
class CustomPurchaseVideoDialog extends StatefulWidget {
  final VideoModel videoModel;

  CustomPurchaseVideoDialog(this.videoModel, {Key key});

  @override
  State<CustomPurchaseVideoDialog> createState() =>
      _CustomPurchaseVideoDialog();
}

class _CustomPurchaseVideoDialog extends State<CustomPurchaseVideoDialog> {
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
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.circular(17),
            ),
            child: _buildBuyCoinUI(),
          ),
          const SizedBox(height: 25),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              safePopPage("cancel");
            },
            child: Image(
                image: AssetImage(AssetsImages.ICON_PAY_FOR_CANCEL),
                width: Dimens.pt34,
                height: Dimens.pt34),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyCoinUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: Dimens.pt10, top: Dimens.pt18),
          child: Center(
            child: Text(
              "本视频需要购买解锁",
              style: TextStyle(
                fontSize: Dimens.pt16,
                color: Color(0xff171717),
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
        ),
        Divider(
          height: Dimens.pt1,
          color: Color.fromRGBO(0, 0, 0, 0.2),
        ),
        SizedBox(height: 18),
        Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Image.asset(
                  "assets/weibo/video_buy_icon.png",
                  width: 27,
                  height: 27,
                ),
              ),
              getShowText(),
            ],
          ),
        ),
        SizedBox(height: 12),

        ///修改展示金额
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: Dimens.pt16 + 4,
            right: Dimens.pt16,
          ),
          child: Text(
            "钱包余额：${((GlobalStore.getWallet().amount ?? 0) + (GlobalStore.getWallet().income ?? 0))}",
            style: TextStyle(
              fontSize: Dimens.pt10,
              height: 1.4,
              color: Color(0xff171717).withOpacity(0.8),
            ),
          ),
        ),
        SizedBox(height: 8),
        _buildButton(),
        // Center(
        //   heightFactor: 1.3,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       FlatButton(
        //         onPressed: () => safePopPage(true),
        //         padding: EdgeInsets.all(0),
        //         child: Container(
        //           width: Dimens.pt228,
        //           height: Dimens.pt36,
        //           decoration: BoxDecoration(
        //             color: Color(0xfffe7f0f),
        //             borderRadius: BorderRadius.circular(Dimens.pt17),
        //           ),
        //           padding: GlobalStore.isVIP()
        //               ? EdgeInsets.only(
        //                   left: Dimens.pt12,
        //                   right: Dimens.pt12,
        //                 )
        //               : EdgeInsets.only(
        //                   left: Dimens.pt40,
        //                   right: Dimens.pt40,
        //                 ),
        //           child: Center(
        //             child: Text(
        //               Lang.BUY_CONFIRM,
        //               style: TextStyle(
        //                 fontSize: Dimens.pt16,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Divider(
        //   height: Dimens.pt1,
        //   color: Color.fromRGBO(0, 0, 0, 0.2),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(top: Dimens.pt10),
        // ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget getShowText() {
    if (hasDiscount)
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.videoModel.coins?.toString() ?? "",
              style: TextStyle(
                fontSize: Dimens.pt40,
                color: Color.fromRGBO(23, 23, 23, 1),
              ),
            ),
            TextSpan(text: "     "),
            TextSpan(
              text: "原价",
              style: TextStyle(
                fontSize: Dimens.pt16,
                color: Color.fromRGBO(132, 132, 132, 1),
              ),
            ),
            TextSpan(
              text: (widget.videoModel.originCoins?.toString() ?? "") + "金币",
              style: TextStyle(
                fontSize: Dimens.pt21,
                color: Color.fromRGBO(98, 98, 98, 1),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                decorationColor: Color.fromRGBO(98, 98, 98, 1),
              ),
            ),
          ],
        ),
      );
    else
      return Text(
        widget.videoModel.originCoins.toString(),
        style: TextStyle(
            fontSize: Dimens.pt40, color: Color.fromRGBO(23, 23, 23, 1)),
      );
  }

  Widget _buildButton() {
    if (!GlobalStore.isVIP()) {
      //&& GlobalStore.isVIP() == false){
      return Container(
        margin: EdgeInsets.only(
          left: Dimens.pt16,
          right: Dimens.pt16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  Config.videoModel = widget.videoModel;
                  Config.payFromType = PayFormType.video;
                  safePopPage(false);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return MemberCentrePage().buildPage({"position": "0"});
                    },
                  ));
                },
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36 / 2),
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
            ),
            SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  safePopPage(true);
                },
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36 / 2),
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
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          safePopPage(true);
        },
        child: Container(
          height: 36,
          margin: EdgeInsets.only(
            left: Dimens.pt16,
            right: Dimens.pt16,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36 / 2),
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
