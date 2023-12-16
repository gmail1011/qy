import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/vote/topic_detail_response.dart';
import 'package:flutter_app/model/vote/topic_type_response.dart';
import 'package:flutter_app/page/home_msg/view/question_result_alert.dart';
import 'package:flutter_app/page/home_msg/view/question_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';

class QuestionAnswPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestionAnswPageState();
  }
}

class _QuestionAnswPageState extends State<QuestionAnswPage> {
  TopicTypeResponse topicInfo;
  TopicDetailResponse dataModel;
  PageController pageController = PageController();
  bool isLoading = false;
  int get allCount => dataModel?.list?.length ?? 0;
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

  void _loadData() async {
    try {
      dynamic responseData = await netManager.client.getVoteGroup(1, 10);
      debugLog(responseData);
      topicInfo = TopicTypeResponse.fromJson(responseData);
      if(topicInfo?.list?.isNotEmpty == true) {
        responseData = await netManager.client.getVoteDetail(topicInfo.list.first.id, 1, 10);
        dataModel = TopicDetailResponse.fromJson(responseData);
      }
      debugLog(responseData);
    } catch (e) {
      debugLog(e);
    }
    dataModel ??= TopicDetailResponse();
    setState(() {});
  }

  void _submitVote() async {
    List<String> selectedArr = [];
    for(int i = 0; i < (dataModel?.list?.length ?? 0); i++){
      TopicDetailModel detailModel = dataModel.list[i];
      bool selected = false;
      for(int j = 0; j < (detailModel?.options?.length ?? 0); j++){
        TopicSelectInfo selectInfo = detailModel?.options[j];
        if(selectInfo.hasVoted == true){
          selected = true;
          selectedArr.add(selectInfo.id);
        }
      }
      if(selected == false){
        showToast(msg: "请完成第${i+1}题哦～");
        pageController.jumpToPage(i);
        return;
      }
    }
    try {
      if(isLoading) return;
      isLoading = true;
      dynamic responseData = await netManager.client.postVoteSubmit(topicInfo.list.first.id, selectedArr);
      debugLog(responseData);
      QuestionResultAlert.show(context, type: 1, descText: "1231231312323");
    } catch (e) {
      debugLog(e);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar(dataModel?.title ?? ""),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 16),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (dataModel == null) {
      return LoadingCenterWidget();
    } else if (dataModel?.list?.isNotEmpty != true) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          dataModel = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: allCount,
              itemBuilder: (context, index) {
                return QuestionView(
                  index: index,
                  allCount: allCount,
                  model: dataModel?.list[index],
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
                        _submitVote();
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
                      child: isLoading ? CupertinoActivityIndicator() :  Text(
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
      );
    }
  }
}
