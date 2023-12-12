import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

import 'ai_face_record_page.dart';
import 'ai_record_page.dart';

class AITotalPage extends StatefulWidget {
  int selectIndex = 0;

  AITotalPage(this.selectIndex);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AITotalPageState();
  }
}

class _AITotalPageState extends State<AITotalPage> {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 3, vsync: ScrollableState(), initialIndex: widget.selectIndex);
    tabController.addListener(() {
      widget.selectIndex = tabController.index;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("生成记录"),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 4, top: 8),
            alignment: Alignment.center,
            height: 40,
            width: screen.screenWidth,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                bool isSelected = widget.selectIndex == index;
                return Container(
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.selectIndex != index) {
                          widget.selectIndex = index;
                          tabController.animateTo(index);
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              index == 0
                                  ? "AI脱衣"
                                  : index == 1
                                      ? "视频换脸"
                                      : "图片换脸",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Color(0xff999999),
                              ),
                            ),
                            SizedBox(height: 2),
                            Container(
                              height: 2,
                              width: 18,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryTextColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                AiRecordPage(
                  position: 0,
                ),
                AiRecordPage(
                  position: 1,
                ),
                AiRecordPage(
                  position: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
