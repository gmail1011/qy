import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/navigator_util.dart';

class NoPermissionDialog extends StatelessWidget {
  final String msg;

  const NoPermissionDialog({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 280,
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Text(
                Lang.NP_PERMISSION,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Color(0xff363636),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Color(0xffD8D8D8), width: 1))),
                            child: FlatButton(
                              highlightColor: Color(0xffffffff),
                              child: Text(msg ?? Lang.RETRY),
                              onPressed: () => safePopPage(false), // 关闭对话框
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Color(0xffD8D8D8), width: 1),
                                    left: BorderSide(
                                        color: Color(0xffD8D8D8), width: 1))),
                            child: FlatButton(
                              highlightColor: Color(0xffffffff),
                              child: Text(
                                "去设置",
                                style: TextStyle(color: Color(0xffFC3066)),
                              ),
                              onPressed: () {
                                //关闭对话框并返回true
                                safePopPage(true);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
