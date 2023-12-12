import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';

import 'message_detail/MessageDetails.dart';

class OfficialMessageCell extends StatelessWidget {
  final ListElement model;

  OfficialMessageCell({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (model.isShowDate == true)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              model.yydDate,
              style: TextStyle(
                color: Color(0xffb1b1b1),
                fontSize: 14,
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.fromLTRB(16, (model.isShowDate == true) ? 6 : 8, 16, 0),
          padding: EdgeInsets.fromLTRB(8, 0, 12, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.lightBlack,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.messageType + "：",
                      style: TextStyle(
                        color: Color(0xffe3e3e3),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      model.hmTime,
                      style: TextStyle(
                        color: Color(0xffb1b1b1),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Color(0xff292929),
              ),
              SizedBox(height: 12),
              _buildRichText(model.content ?? ""),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRichText(String descText) {
    bool isSuccess = true;
    String specialText = "";
    List<String> textArr = [];
    if (descText.contains("推广失败")) {
      isSuccess = false;
      specialText = "推广失败";
    } else if (descText.contains("推广成功")) {
      specialText = "推广成功";
    } else if (descText.contains("未通过")) {
      isSuccess = false;
      specialText = "未通过";
    } else if (descText.contains("已通过")) {
      specialText = "已通过";
    } else if (descText.contains("审核通过")) {
      specialText = "审核通过";
    }else if (descText.contains("审核失败")) {
      isSuccess = false;
      specialText = "审核失败";
    } else if (descText.contains("提现失败")) {
      isSuccess = false;
      specialText = "提现失败";
    } else if (descText.contains("提现成功")) {
      specialText = "提现成功";
    } else {}
    if (specialText.isNotEmpty) {
      textArr = descText.split(specialText);
    }
    if (textArr.length > 1) {
      List<TextSpan> spanArr = [];
      for (int i = 0; i < textArr.length; i++) {
        spanArr.add(
          TextSpan(
            text: textArr[i],
          ),
        );
        if (i != textArr.length - 1) {
          spanArr.add(
            TextSpan(
              text: specialText,
              style: TextStyle(
                color: isSuccess ? Color(0xffee7e31) : Color(0xffd75a55),
              ),
            ),
          );
        }
      }
      return Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xffd0d0d0),
          ),
          children: spanArr,
        ),
      );
    } else {
      return Text(
        descText,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xffcfd0d0),
          height: 1.5,
        ),
      );
    }
  }
}
