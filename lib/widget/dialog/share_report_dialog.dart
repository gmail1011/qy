

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///分享对话框
class ShareReportDialog extends StatefulWidget {
  final List<dynamic> reportList;

  ShareReportDialog({Key key, this.reportList});

  @override
  State<ShareReportDialog> createState() => _ShareReportDialog();
}

class _ShareReportDialog extends State<ShareReportDialog> {
  List<bool> checkedList = [];

  @override
  void initState() {
    super.initState();
    checkedList.length = widget.reportList.length;
  }

  String checked = 'cancel';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: Dimens.pt10, left: Dimens.pt10, right: Dimens.pt10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Lang.REPORT,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimens.pt18,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: widget.reportList.length * Dimens.pt20,
                  child: ListView.builder(
                    itemCount: widget.reportList.length,
                    itemExtent: Dimens.pt20,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: screen.screenWidth,
                        height: Dimens.pt100,
                        child: Row(
                          children: <Widget>[
                            Text.rich(
                              TextSpan(
                                text: widget.reportList[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff0000000),
                                  height: 1.5,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Checkbox(
                                  value: checkedList[index] ?? false,
                                  activeColor: Colors.red,
                                  onChanged: (val) {
                                    if (val) {
                                      checked = widget.reportList[index];
                                    } else {
                                      checked = 'cancel';
                                    }
                                    if (this.mounted == false) {
                                      return;
                                    }
                                    setState(() {
                                      checkedList = [];
                                      checkedList.length =
                                          widget.reportList.length;
                                      checkedList[index] = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: Dimens.pt40,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xffD8D8D8),
                                    width: Dimens.pt1),
                                right: BorderSide(
                                    color: Color(0xffD8D8D8),
                                    width: Dimens.pt1))),
                        child: FlatButton(
                          highlightColor: Color(0xffffffff),
                          child: Text(
                            "确定",
                          ),
                          onPressed: () => safePopPage(
                              checked.isNotEmpty ? checked : 'cancel'), // 关闭对话框
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: Dimens.pt40,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color(0xffD8D8D8),
                                    width: Dimens.pt1),
                                left: BorderSide(
                                    color: Color(0xffD8D8D8),
                                    width: Dimens.pt1))),
                        child: FlatButton(
                          highlightColor: Color(0xffffffff),
                          child: Text(
                            "取消",
                            //style: TextStyle(color: Color(0xffFC3066)),
                          ),
                          onPressed: () {
                            //关闭对话框并返回true
                            safePopPage('cancel');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
