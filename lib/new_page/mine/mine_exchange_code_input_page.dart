import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

///兑换码
class MineExchangeCodeInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineExchangeCodeInputPageState();
  }
}

class _MineExchangeCodeInputPageState extends State<MineExchangeCodeInputPage> {
  TextEditingController controller;
  var inputText = '';
  bool isClear = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.clear();
  }

  void _onExChangeCode() async {
    try {
      await netManager.client.postExChangeCode(inputText);
      showToast(msg: Lang.REDEMPTION_SUCCESS);
      safePopPage();
    } catch (e) {
      l.d('postExChangeCode', e.toString());
      showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: "兑换码"),
        body: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(children: [
            Container(
              height: 38,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)), color:  Color(0xff242424)),
              child: TextField(
                keyboardType: TextInputType.text,
                autofocus: true,
                autocorrect: true,
                textInputAction: TextInputAction.search,
                cursorColor: Colors.white,
                textAlign: TextAlign.left,
                controller: controller,
                style: TextStyle(color: Colors.white, fontSize: 14),
                onChanged: (text) {
                  inputText = text;
                },
                onSubmitted: (text) {
                  _onExChangeCode();
                },
                decoration: InputDecoration(hintText: "请输入", hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _onExChangeCode();
              },
              child: Container(
                height: 47,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: AppColors.linearBackGround),
                child: Center(
                  child: Text(
                    "确定",
                    style:  TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.0),
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
