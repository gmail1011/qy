import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/vote/VoteItemModel.dart';
import 'package:flutter_app/page/vote/VoteCellWidget.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/weibo_page/message/activity_entity.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ActivityDetailPage.dart';

class AnnouncePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnnouncePageState();
  }
}

class AnnouncePageState extends State<AnnouncePage> {
  ActivityData activityData;
  List<VoteItemModel> voteList;

  int pageNumber = 1;
  int pageSize = 100;

  RefreshController refreshUserController = RefreshController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    refreshUserController?.dispose();
    super.dispose();
  }

  void getData() async {
    try {
      dynamic messageDetail = await netManager.client.getDynamicAnnounce(
        pageNumber,
        pageSize,
      );

      activityData = ActivityData().fromJson(messageDetail);

      List<ActivityDataList> xList = activityData.xList;
      List<ActivityDataList> xListTemp = [];
      try {
        voteList = await netManager.client.voteList();
        voteList.forEach((element) {
          if(element!=null){
            ActivityDataList activityDataList = ActivityDataList();
            activityDataList.isVote = true;
            activityDataList.voteItemModel = element;
            xListTemp.add(activityDataList);
          }
        });
      } catch (e) {
      }
      xList.insertAll(0,xListTemp);
      setState(() {});
    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("公告"),
      body: activityData == null
          ? LoadingWidget()
          : activityData.xList == null || activityData.xList.length == 0
              ? CErrorWidget("暂无数据")
              : Container(
                  margin: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      ActivityDataList activityDataList = activityData.xList[index];
                      if(activityDataList.isVote==null ||activityDataList.isVote==false){
                        return GestureDetector(
                          onTap: () {
                            Gets.Get.to(
                                  () => ActivityDetailPage(activityData.xList[index]),
                            );
                            try {
                              String title =
                                  activityData.xList[index].title ?? '';
                              String id = activityData.xList[index].id ?? '';
                              AnalyticsEvent.clickToActivityDetailsEvent(
                                  title, id);
                            } catch (e) {}
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 25.w),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  child: CustomNetworkImage(
                                    imageUrl: activityData.xList[index].cover,
                                    width: screen.screenWidth,
                                    height: 208.w,
                                  ),
                                ),
                                SizedBox(
                                  height: 13.w,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      activityData.xList[index].title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    Spacer(),
                                    /*Row(
                          children: [
                            Text(
                              "立即进入",
                              style: TextStyle(color: Color.fromRGBO(126, 160, 190, 1), fontSize: 14.nsp),
                            ),

                            SizedBox(width: 3.w,),

                            Image.asset("assets/weibo/dynamic_right_arrow.png",width: 30.w,height: 30.w,),
                          ],
                        ),*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return VoteCellWidget(voteItemModel:activityDataList.voteItemModel,buttonCallback: (){
                          getData();
                        },);
                      }
                    },
                    itemCount: activityData.xList.length,
                  )),
    );
  }
}
