

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///線路pingcheck失敗提示框
class RetryPingDialog extends StatelessWidget {
  RetryPingDialog({
    Key key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child: Center(
              child: Image(
                image: AssetImage('assets/images/ic_not_net_tip.png'),
                width: 60,
              ),
            ),
          ),
          Center(
            child: Text(
              Lang.LINE_CHECK_ERROR,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                Lang.CHECK_PHONE_NETWORK,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffaaaaaa),
                  height: 1.5,
                ),
              ),
            ),
          ),
          Container(
            width: screen.screenWidth,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: FlatButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                onPressed: () => safePopPage(true),
                child: Text(
                  Lang.RECHECK_LINE,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
