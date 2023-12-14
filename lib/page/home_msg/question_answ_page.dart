import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/page/home_msg/view/question_result_alert.dart';
import 'package:flutter_app/page/home_msg/view/question_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/screen.dart';

class QuestionAnswPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestionAnswPageState();
  }
}

class _QuestionAnswPageState extends State<QuestionAnswPage> {
  var dataModel;

  PageController pageController = PageController();

  int get allCount => 10;
  bool  get isLastPage{
    if(pageController?.hasClients == true){
      if((pageController.offset + 50) >= screen.screenWidth * (allCount - 1)){
        return true;
      }
    }
    return false;
  }


  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
      });
    });
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
        padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: allCount,
                itemBuilder: (context, index) {
                  return QuestionView(
                    index: index,
                    allCount: allCount,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 44,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 136,
                    child: GestureDetector(
                      onTap: (){
                        double offset = pageController.offset;
                        offset = offset - screen.screenWidth;
                        pageController.jumpTo(max(0, offset));
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
                        if(isLastPage){
                          QuestionResultAlert.show(context, type: 1, descText: "1231231312323");
                        }else {
                          double offset = pageController.offset;
                          offset = offset + screen.screenWidth;
                          pageController.jumpTo(min(screen.screenWidth*allCount, offset));
                        }
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
