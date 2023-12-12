import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'state.dart';

///填写推广码
Future<String> showEditConvertDialog(
    SettingState state, Dispatch dispatch, ViewService viewService) {
  return showDialog<String>(
      context: viewService.context,
      builder: (BuildContext context) {
        final controller = TextEditingController();
        String inputText;
        controller.addListener(() {
          inputText = controller.text.toString();
        });

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.only(top: Dimens.pt17),
            width: Dimens.pt286,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    Lang.INPUT_EXCHANGE_CODE,
                    style: TextStyle(
                        fontSize: Dimens.pt18, color: Color(0xff363636)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Dimens.pt21_5, right: Dimens.pt21_5),
                  child: TextField(
                    controller: controller,
                    maxLines: 1,
                    autofocus: true,
                    autocorrect: true,
                    textAlign: TextAlign.left,
                    maxLengthEnforced: true,
                    cursorWidth: 2.0,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      fillColor: Color(0xff9797),
                    ),
                    onChanged: (text) {
                      inputText = text;
                    },
                  ),
                ),
                Container(
                  height: Dimens.pt50,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          right: 0,
                          child: FlatButton(
                            onPressed: () {
                              if (inputText.isNotEmpty) {
                               safePopPage(inputText);
                              } else {
                                showToast(msg: "您没有输入兑换码");
                              }
                            },
                            child: Text(
                              Lang.SURE,
                              style: TextStyle(
                                  fontSize: Dimens.pt16,
                                  color: Color(0xff666666)),
                            ),
                          )),
                      Positioned(
                          right: Dimens.pt60,
                          child: FlatButton(
                            onPressed: () {
                              safePopPage(null);
                            },
                            child: Text(
                              Lang.cancel,
                              style: TextStyle(
                                  fontSize: Dimens.pt16,
                                  color: Color(0xff666666)),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
