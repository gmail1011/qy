import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/page/home_msg/view/question_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';

class QuestionAnswPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestionAnswPageState();
  }
}

class _QuestionAnswPageState extends State<QuestionAnswPage> {
  var dataModel;

  PageController pageController = PageController();


  bool  get isLastPage => false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("题目"),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return QuestionView(
                    index: index,
                    allCount: 10,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 44,
              child: Row(
                children: [
                  Expanded(
                    flex: 136,
                    child: GestureDetector(
                      onTap: (){
                        int preIndex = (pageController.page - 1).toInt();
                        pageController.jumpToPage(min(0, preIndex));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xff333333),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          "上一题",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 195,
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          isLastPage ? "提交测试" : "下一题",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  Widget _buildContent() {
    if (dataModel == null) {
      return LoadingCenterWidget();
    } else if (dataModel == null) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          dataModel = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return Container();
    }
  }
}
