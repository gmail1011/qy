import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';

/// 账号封禁全局弹窗
class AccountBanDialog extends StatelessWidget {
  final String tip;

  final int uid;

  AccountBanDialog(this.tip, this.uid);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: svgAssets(AssetsSvg.ICON_CLOSE_ACCOUNT,
                  width: 60, height: 60),
            ),
            Text(
              "此帳號已被封禁",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "账号ID：${uid == 0 ? "未登录" : uid}\n${tip == "" ? "具体原因请咨询客服" : tip}",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () async {
                csManager.openServices(context);
              },
              child: Container(
                width: 160,
                height: 40,
                margin: EdgeInsets.only(top: 0, bottom: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 163, 5, 25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "联系客服",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
