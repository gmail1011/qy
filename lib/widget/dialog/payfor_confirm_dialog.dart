import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/novel_player_page/state.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';

/// 显示支付确认对话框
Future<String> showConfirmDialog(
    BuildContext context, String title, String confirmText,
    {String subTitle = ""}) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: Dimens.pt284,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: Dimens.pt30, left: Dimens.pt26, right: Dimens.pt26),
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: Dimens.pt16,
                    height: 1.4,
                    color: Color(0xff363636),
                  ),
                ),
              ),
              Visibility(
                visible: TextUtil.isNotEmpty(subTitle),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Dimens.pt5, left: Dimens.pt26, right: Dimens.pt26),
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: Dimens.pt16,
                      height: 1.4,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: Dimens.pt30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: Dimens.pth40,
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color(0xffD8D8D8),
                                          width: Dimens.pt1))),
                              child: FlatButton(
                                highlightColor: Color(0xffffffff),
                                child: Text(
                                  Lang.cancel,
                                ),
                                onPressed: () => safePopPage('cancel'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: Dimens.pth40,
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Color(0xffD8D8D8),
                                          width: Dimens.pt1),
                                      left: BorderSide(
                                          color: Color(0xffD8D8D8),
                                          width: Dimens.pt1))),
                              child: FlatButton(
                                highlightColor: Color(0xffffffff),
                                child: Text(
                                  confirmText,
                                  style: TextStyle(color: Color(0xffFC3066)),
                                ),
                                onPressed: () {
                                  //关闭对话框并返回true
                                  safePopPage(confirmText);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 显示支付确认对话框
Future<String> showPayForConfirmDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SizedBox(
          width: Dimens.pt308,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Image(
                  image: AssetImage(AssetsImages.BG_PAY_FOR_SUCCEESS),
                  width: Dimens.pt308,
                  height: Dimens.pt450),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dimens.pt70,
                        left: Dimens.pt26,
                        right: Dimens.pt26),
                    child: Text(
                      "订单支付确认",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Dimens.pt18,
                        height: 1.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dimens.pt46,
                        left: Dimens.pt26,
                        right: Dimens.pt26),
                    child: Text.rich(
                      TextSpan(
                          style: TextStyle(
                              color: Color(0xff425453),
                              fontSize: Dimens.pt13,
                              height: 1.4),
                          text: "1.支付成功后，一般会在",
                          children: <TextSpan>[
                            TextSpan(
                                text: '1～10分钟到账',
                                style: TextStyle(
                                    color: AppColors.primaryTextColor,
                                    fontSize: Dimens.pt13,
                                    fontWeight: FontWeight.normal)),
                            TextSpan(
                              text: "，如超时未到账，请联系在线客服为你处理。",
                              style: TextStyle(
                                  color: Color(0xff425453),
                                  fontSize: Dimens.pt13,
                                  height: 1.4),
                            ),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dimens.pt8, left: Dimens.pt26, right: Dimens.pt26),
                    child: Text(
                      "2.受特殊行业限制，如支付失败可尝试重新发起订单，系统会自动为您处理。",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Dimens.pt13,
                        height: 1.4,
                        color: Color(0xff425453),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dimens.pt8, left: Dimens.pt26, right: Dimens.pt26),
                    child: Text(
                      "3.本APP有隐定的广告收益，产品稳定安全可放心使用。",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Dimens.pt13,
                        height: 1.4,
                        color: Color(0xff425453),
                      ),
                    ),
                  ),

                  Container(
                    height: Dimens.pth35,
                    width: Dimens.pt200,
                    margin: const EdgeInsets.only(top: 4),
                    padding: EdgeInsets.all(0),
                    child: FlatButton(
                      color: Colors.transparent,
                      child: Text(
                        "支付遇到问题？",
                        style: TextStyle(
                          color: Color(0xff425453),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        //关闭对话框并返回true
                        safePopPage("question");
                      },
                    ),
                  ),

                  Container(
                    height: Dimens.pth35,
                    width: Dimens.pt200,
                    margin: const EdgeInsets.only(top: 26),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: AppColors.linearBackGround),
                    child: FlatButton(
                      child: Text(
                        "支付成功",
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 13,
                        ),
                      ),
                      onPressed: () {
                        //关闭对话框并返回true
                        safePopPage("已支付");
                      },
                    ),
                  ),


                  const SizedBox(height: 34),


                  InkWell(
                    onTap: () {
                      safePopPage("cancel");
                    },
                    child: Image(
                        image: AssetImage("assets/weibo/images/comment_close.png"),
                        width: Dimens.pt34,
                        height: Dimens.pt34),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
