

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:sprintf/sprintf.dart';

///购买视频对话框
class PurchaseVideoDialog extends StatefulWidget {
  final VideoModel videoModel;

  PurchaseVideoDialog(this.videoModel, {Key key});

  @override
  State<PurchaseVideoDialog> createState() => _PurchaseVideoDialog();
}

class _PurchaseVideoDialog extends State<PurchaseVideoDialog> {
  void leftCallBack() {
//    if (widget.leftCallBack != null) widget.leftCallBack();
    safePopPage(true);
  }

  void rightCallBack() {
//    if (widget.rightCallBack != null) widget.rightCallBack(context);
    safePopPage(false);
  }

  @override
  Widget build(BuildContext context) {
    String titleTxt =
        sprintf(Lang.BUY_TXT1, [widget.videoModel.publisher.name]);
    return Container(
      padding: EdgeInsets.only(top: Dimens.pt10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.pt14),
            child: Center(
              child: Text(
                Lang.BUY_CONFIRM,
                style: TextStyle(
                  fontSize: Dimens.pt14,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
          ),
          Divider(
            height: Dimens.pt1,
            color: Color.fromRGBO(0, 0, 0, 0.2),
          ),
          Container(
            width: screen.screenWidth,
            padding: EdgeInsets.symmetric(
                vertical: Dimens.pt12, horizontal: Dimens.pt20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  //
                  child: Text(
                    titleTxt,
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      height: 1.4,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ),
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.videoModel.coins.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimens.pt50,
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text: Lang.BUY_GOLD,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimens.pt10,
                            height: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  heightFactor: 1.3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: Dimens.pt50),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: leftCallBack,
                          child: Container(
                            width: Dimens.pt102,
                            height: Dimens.pt29,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.pt15),
                              border: Border.all(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  width: Dimens.pt1),
                            ),
                            child: Center(
                              child: Text(
                                Lang.BUY_CAMERA,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: rightCallBack,
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: Dimens.pt102,
                          height: Dimens.pt29,
                          decoration: BoxDecoration(
                            color: Color(0xffFF5C89),
                            borderRadius: BorderRadius.circular(Dimens.pt15),
                          ),
                          child: Center(
                            child: Text(
                              Lang.BUY_CONFIRM,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: Dimens.pt1,
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      Lang.BUY_TXT2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Dimens.pt10,
                        height: 1.4,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      Lang.BUY_TXT3,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: Dimens.pt10,
                        height: 1.4,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      Lang.BUY_TXT4,
                      style: TextStyle(
                        fontSize: Dimens.pt10,
                        height: 1.4,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
