import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'in_come_entity.dart';

class InComePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InComePageState();
  }
}

class InComePageState extends State<InComePage> {
  int pageNumber = 1;
  int pageSize = 16;

  RefreshController refreshUserController = RefreshController();

  InComeEntityModel inComeData;

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
      // dynamic messageDetail = await netManager.client.getInCome(
      //   pageNumber,
      //   pageSize,
      // );
      //
      // if (pageNumber > 1) {
      //   InComeData dynamicData123 = InComeData().fromJson(messageDetail);
      //   inComeData.xList.addAll(dynamicData123.xList);
      //   if (dynamicData123.hasNext) {
      //     refreshUserController.loadComplete();
      //   } else {
      //     refreshUserController.loadNoData();
      //   }
      // } else {
      //   inComeData = InComeData().fromJson(messageDetail);
      //
      //   refreshUserController.refreshCompleted();
      //
      //   if (inComeData.hasNext) {
      //     refreshUserController.loadComplete();
      //   } else {
      //     refreshUserController.loadNoData();
      //   }
      // }

      setState(() {});
    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("收益", actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: GestureDetector(
            onTap: () {
              JRouter().go(PAGE_WITHDRAW);
            },
            child: Image.asset(
              "assets/weibo/cash_out_button.png",
              width: 80.w,
              height: 33.w,
            ),
          ),
        ),
      ]),
      body: inComeData == null
          ? LoadingWidget()
          : inComeData.list == null || inComeData.list.length == 0
              ? CErrorWidget("暂无数据")
              : Container(
                  margin: EdgeInsets.only(top: 20.w, left: 32.w, right: 32.w),
                  child: pullYsRefresh(
                    refreshController: refreshUserController,
                    onRefresh: () {
                      pageNumber = 1;
                      getData();
                    },
                    onLoading: () {
                      pageNumber += 1;
                      getData();
                    },
                    child: ListView.builder(
                      itemCount: inComeData?.list?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      inComeData.list[index].tranType ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.nsp),
                                    ),
                                  ),
                                  Text(
                                    serversTimeToString(
                                        inComeData.list[index].createdAt),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12.nsp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 17.w,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      inComeData.list[index].desc ?? "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.nsp),
                                    ),
                                  ),
                                  Text(
                                    "+ " +
                                        inComeData.list[index].actualAmount
                                            .toString(),
                                    style: TextStyle(
                                        color: Color.fromRGBO(246, 216, 93, 1),
                                        fontSize: 16.nsp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 26.w,
                              ),
                              Container(
                                color: Color.fromRGBO(39, 39, 39, 1),
                                height: 1.w,
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
