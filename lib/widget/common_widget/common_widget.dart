import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/awards_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';

/// 横线
Widget getHengLine({
  double w = 0,
  double h = 1.0,
  Color color,
  double paddingTop = 0,
  double paddingBottom = 0,
  double paddingLeft = 0,
  double paddingRight = 0,
}) {
  if (w <= 0) w = double.infinity;
  return Container(
    margin: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight),
    height: h,
    width: w,
    color: color ?? AppColors.divideColor,
  );
}

/// 竖线
Widget getSuLine({
  double h = 0,
  double w = 2,
  Color color,
  double paddingTop = 0,
  double paddingBottom = 0,
  double paddingLeft = 0,
  double paddingRight = 0,
}) {
  if (h == 0) h = Dimens.pt20;
  return Container(
    margin: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight),
    height: h,
    width: w,
    color: color ?? AppColors.divideColor,
  );
}

/// 获取通用 水平渐变btn
/// [ebable] 是否处于激活状态颜色
/// [enableColors]激活状态颜色
/// [prefix] 前缀
/// [suffix] 后缀
/// [horizontal] 渐变方向，默认水平渐变
Widget getLinearGradientBtn(String title,
    {VoidCallback onTap,
    List<Color> enableColors,
    double height,
    double width,
    bool enable = true,
    double fontSize,
    bool horizontal = true,
    Widget prefix,
    Widget suffix,
    Color textColor = Colors.white}) {
  if (null == width) width = Dimens.pt120;
  if (null == height) height = Dimens.pt40;
  if (null == fontSize) fontSize = AppFontSize.fontSize14;
  if (null == enableColors) enableColors = AppColors.primaryRaiseds;
  var disableColor = <Color>[
    AppColors.primaryDisable,
    AppColors.primaryDisable
  ];
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          gradient: LinearGradient(
            colors: enable ? enableColors : disableColor,
            begin: horizontal ? Alignment.centerLeft : Alignment.topCenter,
            end: horizontal ? Alignment.centerRight : Alignment.bottomCenter,
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            null != prefix ? prefix : Container(),
            Text(title, style: TextStyle(color: textColor, fontSize: fontSize)),
            null != suffix ? suffix : Container(),
          ],
        ),
      ),
    ),
  );
}

/// 获取通用button，
/// [ebable] 是否处于激活状态颜色
/// [enableColor]激活状态颜色
/// [prefix] 前缀
/// [suffix] 后缀
Widget getCommonBtn(String text,
    {double width,
    double height,
    bool enable = true,
    double fontSize,
    Color enableColor,
    VoidCallback onTap,
    Widget prefix,
    Widget suffix,
    Color textColor = Colors.white}) {
  if (null == width) width = Dimens.pt260;
  if (null == height) height = Dimens.pt38;
  if (null == fontSize) fontSize = AppFontSize.fontSize14;
  if (null == enableColor) enableColor = Color.fromRGBO(144, 185, 255, 1);
  var disableColor = AppColors.primaryDisable;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: enable ? enableColor : disableColor,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              //阴影
              BoxShadow(
                  color: (enable ? enableColor : disableColor).withOpacity(0.5),
                  offset: Offset(0.0, 4.0),
                  blurRadius: 9.0)
            ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              null != prefix ? prefix : Container(),
              Text(text,
                  style: TextStyle(color: textColor, fontSize: fontSize)),
              null != suffix ? suffix : Container(),
            ]),
      ),
      onTap: onTap,
    ),
  );
}

/// 获取通用button，
/// [ebable] 是否处于激活状态颜色
/// [enableColor]激活状态颜色
/// [prefix] 前缀
/// [suffix] 后缀
Widget buildCommonButton(String text,
    {double width,
    double height,
    bool enable = true,
    double fontSize,
    Color enableColor,
    VoidCallback onTap,
    Widget prefix,
    Widget suffix,
    Color textColor = Colors.white}) {
  if (null == width) width = Dimens.pt260;
  if (null == height) height = Dimens.pt38;
  if (null == fontSize) fontSize = AppFontSize.fontSize14;
  if (null == enableColor) enableColor = Color(0xFFFD7F10);
  var disableColor = Colors.transparent;
  return Material(
    color: Colors.transparent,
    child: InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: enable ? enableColor : disableColor,
          border: Border.all(color: enableColor, width: 1), //enable
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              null != prefix ? prefix : Container(),
              Text(text,
                  style: TextStyle(
                      color: enable ? Colors.white : enableColor,
                      fontSize: fontSize)),
              null != suffix ? suffix : Container(),
            ]),
      ),
      onTap: onTap,
    ),
  );
}

/// 获取统一通用的appbar
Widget getCommonAppBar(String title,
    {VoidCallback onBack, bool centerTitle = true, List<Widget> actions}) {
  return AppBar(
    elevation: 0,
    centerTitle: centerTitle,
    titleSpacing: .0,
    title: Text(
      title,
      style: TextStyle(
        fontSize: AppFontSize.fontSize18,
        color: Colors.white,
        height: 1.4,
      ),
    ),
    // leading: IconButton(
    //   icon: Icon(Icons.arrow_back),
    //   onPressed: onBack ?? () => safePopPage(),
    // ),
    leading: GestureDetector(
      onTap: onBack ?? () => safePopPage(),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 13,right: 13,top: 6,bottom: 6),
        child: Image.asset("assets/weibo/back_arrow.png"),
      ),
    ),
    actions:  actions,
  );
}

/// 获取vip等级的图标
Widget getVipLevelWidget(bool isVip, int vipLevel) {
  if (isVip && 1 == vipLevel) {
    return ImageLoader.withP(
      ImageType.IMAGE_SVG,
      address: AssetsSvg.ICON_VIP,
      height: Dimens.pt14,
    ).load();
  } else if (isVip && 2 == vipLevel) {
    return ImageLoader.withP(
      ImageType.IMAGE_SVG,
      address: AssetsSvg.ICON_SVIP,
      height: Dimens.pt14,
    ).load();
  } else {
    return Container();
  }
}

///公用的提交按钮
Widget getCommonSubmitButton(String title, Function onTap) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      height: Dimens.pt32,
      margin: EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.center,
      child: Text(title, style: TextStyle(fontSize: 14, color: Colors.white)),
    ),
  );
}

///公用的提交按钮
Widget commonSubmitButton(String title,
    {double width,
    double height,
    double radius = 22,
    double fontSize,
    Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width ?? Dimens.pt228,
      height: height ?? Dimens.pt44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
            colors: AppColors.vipSubmitBtnColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
      ),
      child: Text(
        title,
        style:
            TextStyle(fontSize: fontSize ?? Dimens.pt15, color: Colors.black),
      ),
    ),
  );
}

///公用的提交按钮
Widget getCommonShareButton(String title, Function onTap) {
  return InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      height: Dimens.pt32,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 6),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff425453),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1),
            color: Color(0xff425453),
            width: 54,
            height: 1,
          ),
        ],
      ),
      //425453
    ),
  );
}

///公用弹出框
void commonNotifyDialog(BuildContext context, String content,
    {Function onTapCallback}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "提示",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "取消",
              style: TextStyle(
                color: Color(0xff262626),
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(
              "确定",
              style: TextStyle(
                color: Color(0xffff7600),
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onTapCallback();
            },
          ),
        ],
      );
    },
  );
}

///设置称号
Widget buildHonorLevelUI({
  bool hasKingIcon,
  List<AwardsExpire> honorLevelList,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Visibility(
        visible: hasKingIcon ?? false,
        child: Container(
          margin: EdgeInsets.only(left: 4),
          child: Image(
            image: AssetImage(AssetsImages.ICON_KING_LEVEL),
            width: Dimens.pt12,
            height: Dimens.pt12,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Visibility(
        visible: (honorLevelList ?? []).isNotEmpty,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (honorLevelList ?? []).isNotEmpty
                ? honorLevelList
                    .map(
                      (item) => item.isExpire
                          ? Container(
                              margin: EdgeInsets.only(left: 4),
                              child: CustomNetworkImage(
                                imageUrl: item.imageUrl ?? "",
                                width: Dimens.pt12,
                                height: Dimens.pt12,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(),
                    )
                    .toList()
                : []),
      ),
    ],
  );
}

///公用TabBar
Widget commonTabBar(Widget tabBar) {
  return Theme(
      data: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: tabBar);
}

///填写兑换码
Future<String> showRedemptionCodeDialog(BuildContext context) {
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final inputController = TextEditingController();
        String inputText;
        inputController.addListener(() {
          inputText = inputController.text.toString();
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
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.pt22,
                        color: Color(0xFFFF7600)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: Dimens.pt16,
                      left: Dimens.pt21_5,
                      right: Dimens.pt21_5),
                  child: TextField(
                    controller: inputController,
                    maxLines: 1,
                    maxLength: 10,
                    autofocus: true,
                    autocorrect: true,
                    textAlign: TextAlign.left,
                    maxLengthEnforced: true,
                    cursorWidth: 2.0,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")),
                    ],
                    decoration: InputDecoration(
                      hintText: "请输入兑换码",
                      contentPadding: EdgeInsets.all(10.0),
                      fillColor: Color(0xff9797),
                      counterText: "",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
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
                              if ((inputText ?? "").isNotEmpty) {
                                safePopPage(inputText);
                              } else {
                                showToast(msg: "您没有输入兑换码");
                              }
                            },
                            child: Text(
                              Lang.SURE,
                              style: TextStyle(
                                  fontSize: Dimens.pt16,
                                  color: Color(0xFFFD7F10)),
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
