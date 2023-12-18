import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/model/vote/topic_detail_response.dart';
import 'package:flutter_base/utils/screen.dart';

class QuestionView extends StatefulWidget {
  final int index;
  final int allCount;
  final TopicDetailModel model;
  final bool hasVoted;

  const QuestionView({
    Key key,
    this.index,
    this.allCount,
    this.model,
    this.hasVoted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionViewState();
  }
}

class _QuestionViewState extends State<QuestionView> {
  int get selectIndex => 0;

  bool get isMulCheck => widget.model.isMulCheck == true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.all(1),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.6),
              Colors.black.withOpacity(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                    (widget.index + 1).toString(),
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
                      flex: widget.index + 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    if (widget.allCount - widget.index > 1)
                      Expanded(
                        flex: widget.allCount - widget.index,
                        child: SizedBox(),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 28),
              Text.rich(
                  TextSpan(
                    text: widget.model?.title ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                    children: [
                      TextSpan(
                        text: isMulCheck ? " (多选)" : "",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ),
                  SizedBox(height: 18),
                  ..._buildVotesMenu(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildVotesMenu() {
    List<Widget> votesArr = [];
    for (int i = 0; i < (widget.model?.options?.length ?? 0); i++) {
      TopicSelectInfo selectInfo = widget.model?.options[i];
      votesArr.add(_buildTopicItem(i, selectInfo));
    }
    return votesArr;
  }

  Widget _buildTopicItem(int index, TopicSelectInfo model) {
    bool isSelected = model?.hasVoted == true;
    List<String> charArr = [
      "A.",
      "B.",
      "C.",
      "D.",
      "E.",
      "F.",
      "G.",
      "H.",
      "I.",
      "J.",
      "K.",
      "L.",
      "M.",
      "N.",
      "",
    ];
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (widget.hasVoted == true) {
            return;
          }
          if (isSelected == false && isMulCheck == false) {
            for (int i = 0; i < (widget.model?.options?.length ?? 0); i++) {
              TopicSelectInfo selectInfo = widget.model?.options[i];
              selectInfo.hasVoted = false;
            }
          }
          model?.hasVoted = !isSelected;
          setState(() {});
        },
        child: Stack(
          children: [
            Container(
              width: screen.screenWidth - 16 * 4,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? AppColors.primaryTextColor.withOpacity(0.2) : Color(0xff323232),
                border: Border.all(color: isSelected ? AppColors.primaryTextColor : Colors.transparent),
              ),
              child: Text(
                charArr[index] + (model.option ?? ""),
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
                  "assets/images/question_selected.png",
                  width: 26,
                  height: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
