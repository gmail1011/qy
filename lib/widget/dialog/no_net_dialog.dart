

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///启动页无网提示框
class NoNetDialog extends StatefulWidget {
  NoNetDialog({Key key});

  @override
  State<NoNetDialog> createState() => _NoNetDialog();
}

class _NoNetDialog extends State<NoNetDialog> {
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
              Lang.NETWORK_CONNECT_ERROR,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
          Center(
            child: Text(
              Lang.PLEASE_LOOK_OR_RETRY,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xffcccccc),
                height: 1.5,
              ),
            ),
          ),
          Container(
            width: screen.screenWidth,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 16),
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 27,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FlatButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => safePopPage(false),
                      child: Text(
                        Lang.SETTING,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 27,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FlatButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => safePopPage(true),
                      child: Text(
                        Lang.RETRY,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
