import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

///邀请码
class MineInviteCodeInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineInviteCodeInputPageState();
  }
}

class _MineInviteCodeInputPageState extends State<MineInviteCodeInputPage> {
  TextEditingController controller;
  var inputText = '';
  bool isClear = false;

  var inviteCode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    _queryInviteCode();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.clear();
  }

  /// 绑定推广码
  _bindPromotionCode() async {
    if (inviteCode.toString() == "0") {
      try {
        await netManager.client.getProxyBind(inputText);
        showToast(msg: Lang.BIND_SUCCESS);
        GlobalStore.updateUserInfo(null);
      } catch (e) {
        l.d('getProxyBind', e.toString());
        showToast(msg: e.toString() ?? '');
      }
    } else {
      showToast(msg: "您已綁定了推廣碼,不能重復綁定");
    }
  }

  ///查询是否绑定推广码
  void _queryInviteCode() async {
    try {
      dynamic data = await netManager.client.QUERY_TUI_GUANG();
      inviteCode = data["inviter"];
    } catch (e) {
      l.d('postExChangeCode', e.toString());
      showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: "邀请码"),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            Container(
              height: 42,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)), color: const Color(0xff202733)),
              child: TextField(
                keyboardType: TextInputType.text,
                autofocus: true,
                autocorrect: true,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.white,
                textAlign: TextAlign.left,
                controller: controller,
                style: TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (text) {
                  inputText = text;
                },
                onSubmitted: (text) {
                  _bindPromotionCode();
                },
                decoration: InputDecoration(hintText: "请输入", hintStyle: TextStyle(color: Color(0xff434c55))),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _bindPromotionCode();
              },
              child: Container(
                height: 47,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: AppColors.linearBackGround),
                child: Center(
                  child: Text(
                    "确定",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14.0),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
