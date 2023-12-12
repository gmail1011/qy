// token异常全局弹窗
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

class TakenAbnormalDialog extends StatefulWidget {
  _TakenAbnormalDialogState createState() => new _TakenAbnormalDialogState();
}

class _TakenAbnormalDialogState extends State<TakenAbnormalDialog> {
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    Lang.TOKEN_AB_NORMAL_1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimens.pt20,
                      fontWeight: FontWeight.bold,
                      // 每一个字符之间的间距
                      letterSpacing: 8,
                    ),
                  ),
                  // 文字 【如有疑問，請練習客服】
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimens.pt20),
                    child: Text(Lang.TOKEN_AB_NORMAL_2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimens.pt16,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getLinearGradientBtn(
                  Lang.TOKEN_AB_NORMAL_4,
                  enableColors: [
                    Color.fromRGBO(144, 185, 255, 1),
                    Color.fromRGBO(137, 217, 255, 1),
                  ],
                  onTap: () {
                    exit(0);
                  },
                ),
                getLinearGradientBtn(Lang.TOKEN_AB_NORMAL_3, enableColors: [
                  Color(0xFFFE7F0F),
                  Color(0xFFEA8B25),
                ], onTap: () async {
                  if ((GlobalStore.store?.getState()?.meInfo?.mobile ?? '')
                      .isNotEmpty) {
                    JRouter().go(RECOVER_ACCOUNT).then((_) {
                      safePopPage();
                    });
                  } else {
                    // VariableConfig.authToken = null;
                    netManager.setToken(null);
                    exit(0);
                  }
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
