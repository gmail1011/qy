import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/message/fans_obj.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'bloggerPage.dart';

class MyFollowPage extends StatefulWidget{

  int uid;

  MyFollowPage(this.uid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyFollowPageState();
  }

}

class MyFollowPageState extends State<MyFollowPage>{

  int pageNumber = 1;
  int pageSize = 20;
  RefreshController refreshController = new RefreshController();

  WatchlistModel fansObj;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  void initData() async{
    try {

      WatchlistModel fansObjTemp = await netManager.client.getBloggerFollowedUserList(pageNumber, widget.uid,pageSize);

      if (pageNumber > 1) {
        fansObj.list.addAll(fansObjTemp.list);
        refreshController.loadComplete();
      } else {
        fansObj = fansObjTemp;
        refreshController.loadComplete();
      }

      if (fansObjTemp.hasNext) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }

      setState(() {

      });
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("关注",style: TextStyle(color: Colors.white,fontSize: 16.nsp),),
      ),

      body: fansObj == null ? LoadingWidget() : fansObj.list == null || fansObj.list.length == 0 ? CErrorWidget("暂无数据") : Container(
        margin: EdgeInsets.only(left: 16.w,right: 16.w),
        child: pullYsRefresh(
          refreshController: refreshController,
          enablePullDown: false,
          onRefresh: () {
            pageNumber = 1;
            initData();
          },
          onLoading: () {
            pageNumber += 1;
            initData();
          },
          child: ListView.builder(
            itemCount: fansObj.list.length,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.only(bottom: 6.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: GestureDetector(
                            onTap: () {
                              Map<String, dynamic> arguments =
                              {
                                'uid': fansObj.list[index].uid,
                                'uniqueId': DateTime.now()
                                    .toIso8601String(),
                              };

                              Gets.Get.to(
                                BloggerPage(arguments),
                              );
                            },
                            child: CustomNetworkImage(
                              fit: BoxFit.cover,
                              width: 78.w,
                              height: 78.w,
                              imageUrl: fansObj.list[index].portrait,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Map<String, dynamic> arguments = {
                              'uid': fansObj.list[index].uid,
                              'uniqueId': DateTime.now()
                                  .toIso8601String(),
                            };

                            Gets.Get.to(
                              BloggerPage(arguments),opaque: false,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fansObj.list[index]
                                      .name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.nsp),
                                ),
                                SizedBox(
                                  height: 9.w,
                                ),
                                Text(
                                  "粉丝: " +
                                      fansObj.list[index].fans
                                          .toString() ?? "0",
                                  style: TextStyle(
                                      color: Color.fromRGBO(
                                          78, 88, 110, 1),
                                      fontSize: 15.nsp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Visibility(
                            visible: fansObj.list[index]
                                .hasFollow ??
                                false
                                ? false
                                : true,
                            child: GestureDetector(
                              onTap: () async {
                                await netManager.client
                                    .getFollow(
                                    fansObj.list[index].uid,
                                    !fansObj.list[index]
                                        .hasFollow);

                                fansObj.list[index]
                                    .hasFollow
                                    ? fansObj.list[index]
                                    .hasFollow = false
                                    : fansObj.list[index]
                                    .hasFollow = true;

                                showToast(msg: "关注成功");
                                setState(() {

                                });
                              },
                              child: Image.asset(
                                "assets/weibo/guanzhu.png",
                                width: 68.w,
                                height: 26.w,
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 9.w,
                    ),
                    Container(
                      height: 1.w,
                      margin: EdgeInsets.only(
                          left: 78.w, right: 58.w),
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}