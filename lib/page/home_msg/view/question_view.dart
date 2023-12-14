import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';

class QuestionView extends StatefulWidget {
  final int index;
  final int allCount;

  const QuestionView({Key key, this.index, this.allCount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionViewState();
  }
}

class _QuestionViewState extends State<QuestionView> {
  int get selectIndex => 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.6),
            Colors.black.withOpacity(0),
          ],
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xff242424),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  widget.index.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  "/${widget.allCount}",
                  style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primaryTextColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: widget.index,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryTextColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  if (widget.allCount - widget.index > 0)
                    Expanded(
                      flex: widget.allCount - widget.index,
                      child: SizedBox(),
                    ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Text(
              "这是海角官方发送的讨论话题离开家绿卡发动机来说领导看见风口浪尖了历史的开房记录独立空间?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
            _buildTopicItem("A.文字描述，文字描述，肯德基", false),
            _buildTopicItem("B.文字描述，文字描述，肯德基看交换空间卡来开房记录的是恐惧了空间了空间", false),
            _buildTopicItem("A.文字描述，文字描述，肯德基", false),
          ],
        ),
      ),
    );
  }

  //question_selected.png
  Widget _buildTopicItem(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? AppColors.primaryTextColor.withOpacity(0.2) : Color(0xff323232),
              border: Border.all(color: isSelected ? AppColors.primaryTextColor : Colors.transparent),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xff999999),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/isSelected.png",
                width: 26,
                height: 18,
              ),
            ),
        ],
      ),
    );
  }
}
