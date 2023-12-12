import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';

///支付风控提示对话框
class PayNoticeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        alignment: Alignment.center,
        height: 420,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage("assets/images/hj_pay_tips_bg.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 27, right: 27, bottom: 27),
                child: commonSubmitButton("确认支付", height: Dimens.pt36, onTap: () => safePopPage("startPay")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
