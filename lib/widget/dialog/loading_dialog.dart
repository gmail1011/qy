import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

final loadingDialog = LoadingDialog();

class LoadingDialog {
  ProgressDialog pr;

  /// [shotTip] 是否显示左下边脚的进度
  /// [isDismissible] 是否可以点击外部返回
  /// [child] 自己定义loading
  Future<bool> show(BuildContext context,
      {String message = "loading...",
      bool showTip = false,
      bool isDismissible = true,
      Widget child}) async {
    if (null != pr && pr.isShowing()) await pr.hide();
    pr = null;

    pr = ProgressDialog(
      context,
      type: showTip ? ProgressDialogType.Download : ProgressDialogType.Normal,
      isDismissible: isDismissible,
      // customBody: LinearProgressIndicator(
      //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      //   backgroundColor: Colors.white,
      // ),
      customBody: child,
    );

    pr.style(
      message: message,
      // message:
      //     'Lets dump some huge text into the progress dialog and check whether it can handle the huge text. If it works then not you or me, flutter is awesome',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return pr.show();
  }

  Future dismiss() async {
    if (null != pr && pr.isShowing()) await pr.hide();
    pr = null;
    return;
  }

  Future update(double progress, {dynamic message}) async {
    if (!(pr?.isShowing() ?? false)) return;
    pr?.update(
        progress: progress.toInt().toDouble(),
        message: (message ?? '').toString());
  }
}
