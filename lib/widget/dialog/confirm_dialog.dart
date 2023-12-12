import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';

// final _i40 = 40;
// final _i20 = 20;
// final _i200 = 200;
// final _h32 = 35;

/// 使用事例：
/// [return] 确认返回 true, 点击取消与点击背景返回 false
/// ```dart
/// bool ok = await showConfirm(...)
/// if(ok){
///   print('点击了确认！')
/// }else{
///   print('点击了取消！')
/// }
/// ```
/// [content] 提示的内容
Future<bool> showConfirm(BuildContext context,
    {String title = "",
    String content = "",
    Widget child,
    bool showCancelBtn = false,
    bool barrierDismissible = true,
    String cancelText = Lang.CANCEL,
    String sureText = Lang.SURE,
    Alignment alignment = Alignment.center}) async {
  var res = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(AppPaddings.appMargin),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: alignment,
              child: Column(
                children: <Widget>[
                  // title
                  Visibility(
                    visible: TextUtil.isNotEmpty(title),
                    child: Text(title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimens.pt16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        )),
                  ),
                  // title 和content的分割线
                  Visibility(
                    visible: TextUtil.isNotEmpty(title) && (null != child || TextUtil.isNotEmpty(content)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimens.pt8),
                      child: getHengLine(w: Dimens.pt260, color: AppColors.primaryRaised),
                    ),
                  ),
                  // content
                  Visibility(
                    visible: (null != child || TextUtil.isNotEmpty(content)),
                    child: null != child
                        ? child
                        : Text(content,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimens.pt13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            )),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: Dimens.pt10),
                  //   child: getHengLine(
                  //       w: Dimens.pt260, color: AppColors.primaryRaised),
                  // ),
                  SizedBox(height: Dimens.pt16),
                  //buttons
                  Row(
                    mainAxisAlignment:
                        showCancelBtn ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                        visible: showCancelBtn,
                        child: getLinearGradientBtn(cancelText,
                            width: Dimens.pt110,
                            height: Dimens.pt35,
                            enable: false,
                            onTap: () => safePopPage(false)),
                        // getCommonBtn(cancelText,
                        //     width: Dimens.pt110,
                        //     height: Dimens.pt35,
                        //     enableColor: AppColors.primaryDisable,
                        //     onTap: () => safePopPage(false)),
                      ),
                      getLinearGradientBtn(sureText,
                          width: showCancelBtn ? Dimens.pt110 : Dimens.pt160,
                          height: Dimens.pt35,
                          enableColors: [const Color(0xff84a4f9), const Color(0xff2b5dde)],
                          onTap: () => safePopPage(true)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
  return res == null ? false : res;
}

// Widget _splitLine() {
//   return Container(
//     width: 1.0,
//     color: Color.fromRGBO(25, 25, 25, 0.2),
//     height: 19,
//   );
// }
