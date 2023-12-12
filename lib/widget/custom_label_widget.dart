import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLabelWidget extends StatelessWidget {
  final List<String> list;
  final ValueChanged<int> onTag;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final double width;
  final double heigth;

  CustomLabelWidget(
      {this.list,
      this.onTag,
      this.fontSize,
      this.fontColor,
      this.fontWeight,
      this.padding,
      this.width,
      this.heigth});

  @override
  Widget build(BuildContext context) {
    var widgtList = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      var _list = GestureDetector(
        child: Container(
            padding: EdgeInsets.only(left: 4.w,right: 4.w,top: 4.w,bottom:4.w),
            decoration: BoxDecoration(
              color: Colors.transparent, // 透明底色
              borderRadius: BorderRadius.circular((4)), // 圆角度
            ),
            child: ShadowText(
              "#${list[i]}",
              maxLines: 1,
              fontSize: fontSize ?? 14.w,
              color: fontColor ?? Colors.white,
            )),
        onTap: () => onTag?.call(i),
      );
      widgtList.add(_list);
    }
    return Container(
      width: width ?? Dimens.pt280,
      height: 32.w, // 最多1排
      child: Wrap(
        crossAxisAlignment:
        WrapCrossAlignment.center, //垂直居中 交叉轴（crossAxis）方向上的对齐方式。
        spacing: 6.w, // 主轴(水平)方向间距
        alignment: WrapAlignment.start,
        children: widgtList,
      ),
    );
  }
}
