import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/setting/you_hui_juan/you_hui_juan_entity.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class YiGuoQiPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YiGuoQiPageState();
  }
}

class _YiGuoQiPageState extends State<YiGuoQiPage> {
  int page = 1;
  int count = 10;

  List<YouHuiJuanData> data = [];

  YouHuiJuanData youHuiJuanData;

  bool isLoadingFinish;

  RefreshController refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshController = new RefreshController();
    initData();
  }

  Future initData() async {
    try {
      List<dynamic> lists =
          await netManager.client.getYouHuiJuan(3, page, count);

      if (page == 1) {
        data.clear();
        refreshController.resetNoData();
        refreshController.refreshCompleted();
      }

      if (lists != null && lists.length == 0) {
        refreshController.loadNoData();
      }

      if (lists != null && lists.length > 0) {
        lists.forEach((element) {
          YouHuiJuanData youHuiJuanData = YouHuiJuanData().fromJson(element);
          data.add(youHuiJuanData);
        });
      }

      isLoadingFinish = true;

      setState(() {});
    } catch (e) {
      isLoadingFinish = true;
      refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoadingFinish == null && data.length == 0
        ? Center(
            child: LoadingWidget(),
          )
        : data.length == 0
            ? Container(
                child: Center(
                child: Text(
                  "没有数据",
                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt20),
                ),
              ))
            : Container(
                margin: EdgeInsets.only(
                    top: Dimens.pt16, left: Dimens.pt15, right: Dimens.pt15),
                child: pullYsRefresh(
                  refreshController: refreshController,
                  onRefresh: () async {
                    Future.delayed(Duration(milliseconds: 1700), () {
                      page = 1;
                      initData();
                      refreshController.refreshCompleted();
                    });
                  },
                  onLoading: () async {
                    Future.delayed(Duration(milliseconds: 1700), () {
                      page++;
                      initData();
                      refreshController.loadComplete();
                    });
                  },
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: Dimens.pt16,
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            // data[index].goodsType == 1
                            //     ? Image.asset(
                            //         "assets/images/lou_feng_you_hui_juan.png")
                            //     : Image.asset(
                            //         "assets/images/hui_yuan_you_hui_juan.png"),
                            Positioned(
                              left: Dimens.pt80,
                              top: 0,
                              child: Container(
                                //color: Colors.blue,
                                // height: Dimens.pt30,
                                margin: EdgeInsets.only(
                                    top: Dimens.pt10, right: Dimens.pt10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index].goodsName,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: Dimens.pt6,
                                    ),
                                    Text(
                                      data[index].goodsDesc,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: Dimens.pt46,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data[index].goodsOrigin,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: Dimens.pt24,
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(right: Dimens.pt4),
                                          child: Text(
                                            DateTimeUtil.utc2iso(
                                                    data[index].expiredTime,) +
                                                " 过期",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    Colors.white.withOpacity(0.8),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
  }
}
