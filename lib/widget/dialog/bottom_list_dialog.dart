import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';

class ItemData {
  String title;
  Color titleColor;
  ItemData(this.title, {this.titleColor = Colors.black});
}

/// 显示列表对话框
Future<int> showListDialog(BuildContext ctx, List<ItemData> datas,
    {String title, bool showCancel = true}) async {
  if (null == datas || datas.isEmpty) return -1;

  var itemHeight = Dimens.pt40;

  return showModalBottomSheet(
    context: ctx,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.only(bottom: screen.paddingBottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextUtil.isEmpty(title)
                ? Container()
                : Container(
                    width: Dimens.pt340,
                    padding: EdgeInsets.all(Dimens.pt8),
                    alignment: Alignment.center,
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: datas.length,
              padding: EdgeInsets.symmetric(horizontal: 0),
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    height: itemHeight,
                    child: _createItemWidget(datas[index]),
                  ),
                  onTap: () => safePopPage(index),
                );
              },
            ),
            showCancel
                ? GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.1,
                          child: Container(
                            alignment: Alignment.center,
                            height: 10,
                            color: Color(0XFFbdbdbd),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: itemHeight,
                          child: _createCancelItemWidget(),
                        ),
                      ],
                    ),
                    onTap: () => safePopPage(-1),
                  )
                : Container(),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
      );
    },
  );
}

Widget _createItemWidget(ItemData item) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: itemView(
          item,
        ),
      ),
      Divider(
        height: Dimens.pt0,
        indent: Dimens.pt0,
        color: Colors.black12,
      ),
    ],
  );
}

Widget _createCancelItemWidget() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Divider(
        height: Dimens.pt0,
        indent: Dimens.pt0,
        color: Colors.black12,
      ),
      Expanded(
        child: itemView(
          ItemData(Lang.CANCEL),
        ),
      ),
    ],
  );
}

Widget itemView(ItemData data) {
  var style = TextStyle(
    fontSize: 16,
    color: data.titleColor,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
  return InkWell(
    child: Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(data.title, style: style),
        ],
      ),
    ),
  );
}
