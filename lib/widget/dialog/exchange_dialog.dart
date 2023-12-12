import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

class ExchangeDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExchangeDialogState();
  }
}

class ExchangeDialogState extends State<ExchangeDialog> {
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.pt12),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: Dimens.pt10),
              child: Text(Lang.INPUT_EXCHANGE_CODE,
                  style: TextStyle(color: Colors.black, fontSize: Dimens.pt17)),
            ),
            Container(
              height: Dimens.pt35,
              margin: EdgeInsets.all(Dimens.pt14),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(212, 212, 212, 1),
                      width: Dimens.pt1)),
              child: TextField(
                maxLines: 1,
                autofocus: true,
                autocorrect: true,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                maxLengthEnforced: true,
                cursorWidth: 2.0,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),
                ],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(Dimens.pt8),
                    fillColor: Color(0xff9797),
                    border: InputBorder.none),
                onChanged: (text) {
                  inputString = text;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Dimens.pt16),
              child: Divider(
                  height: 1.0,
                  indent: 0.0,
                  color: Color.fromRGBO(212, 212, 212, 1)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    safePopPage();
                  },
                  child: Container(
                    height: Dimens.pt45,
                    width: Dimens.pt125,
                    color: Colors.white,
                    child: Center(
                      child: Text(Lang.cancel),
                    ),
                  ),
                ),
                Container(
                    height: Dimens.pt45,
                    child: VerticalDivider(
                        color: Color.fromRGBO(212, 212, 212, 1))),
                GestureDetector(
                  onTap: () {
                    if (inputString == null) {
                      showToast(msg: "請輸入兌換碼");
                      return;
                    }
                    exchangeCode();
                  },
                  child: Container(
                    color: Colors.white,
                    height: Dimens.pt45,
                    width: Dimens.pt125,
                    child: Center(
                      child: Text(Lang.SURE),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> exchangeCode() async {
    // Map<String, dynamic> params = Map();
    // params['code'] = inputString;
    // BaseResponse res =
    //     await HttpManager().post(Address.EXCHANGE_CODE, params: params);
    try {
      await netManager.client.postExChangeCode(inputString);
      showToast(msg: Lang.REDEMPTION_SUCCESS);
      safePopPage();
    } catch (e) {
      showToast(msg: e.msg);
      l.e('postExChangeCode', e.toString());
    }
    // if (res.code == 200) {
    //   showToast(msg: Lang.REDEMPTION_SUCCESS);
    //   safePopPage();
    // } else {
    //   showToast(msg: res.msg);
    // }
  }
}
