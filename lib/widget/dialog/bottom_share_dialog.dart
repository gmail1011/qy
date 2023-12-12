

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///底部分享对话框
class BottomShareDialog extends StatefulWidget {
  final bool isCollect;

  BottomShareDialog({Key key, this.isCollect});

  @override
  State<BottomShareDialog> createState() => _BottomShareDialog();
}

class _BottomShareDialog extends State<BottomShareDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: Dimens.pt10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              Lang.SHARE_TO,
              style: TextStyle(
                fontSize: Dimens.pt14,
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          Container(
            width: screen.screenWidth,
            padding: EdgeInsets.symmetric(
                vertical: Dimens.pt12, horizontal: Dimens.pt28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            children: <Widget>[
                              svgAssets(AssetsSvg.IC_SHARE_UNCOLLECT),
                              Text(
                                widget.isCollect ? Lang.CANCEL_COLLECT : " 收藏",
                                style: TextStyle(
                                  fontSize: Dimens.pt10,
                                  height: 1.4,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () =>
                              safePopPage('share_uncollect'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            children: <Widget>[
                              svgAssets(AssetsSvg.IC_SHARE_CODE),
                              Text(
                                Lang.QR_CODE,
                                style: TextStyle(
                                  fontSize: Dimens.pt10,
                                  height: 1.4,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () =>
                              safePopPage('share_code'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            children: <Widget>[
                              svgAssets(AssetsSvg.IC_SHARE_REPORT),
                              Text(
                                Lang.REPORT,
                                style: TextStyle(
                                  fontSize: Dimens.pt10,
                                  height: 1.4,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () =>
                              safePopPage('share_report'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: FlatButton(
                          child: Column(
                            children: <Widget>[
                              svgAssets(AssetsSvg.IC_COPY_LINK),
                              Text(
                                Lang.COPY_LINK,
                                style: TextStyle(
                                  fontSize: Dimens.pt10,
                                  height: 1.4,
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () =>
                              safePopPage('copy_link'),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: Dimens.pt12),
                  child: Divider(
                    height: Dimens.pt1,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: () => safePopPage('cancel'),
                        child: Text(
                          Lang.cancel,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: Dimens.pt14,
                            height: 1.5,
                          ),
                        ),
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
