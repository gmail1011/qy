import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../assets/app_colors.dart';
import '../../common/net2/net_manager.dart';
import '../../utils/date_time_util.dart';
import '../../widget/common_widget/error_widget.dart';
import '../setting/you_hui_juan/you_hui_juan_entity.dart';

class PayForTicketView extends StatefulWidget {
  Function onItemClick;

  PayForTicketView(this.onItemClick);

  @override
  State<StatefulWidget> createState() {
    return _PayForTicketViewState();
  }
}

class _PayForTicketViewState extends State<PayForTicketView> {
  ScrollController scrollController = ScrollController();

  List<YouHuiJuanData> data = [];
  YouHuiJuanData selectItem;

  @override
  void initState() {
    super.initState();
    getTicket();
  }

  void getTicket() async {
    var tickets = await netManager.client.getYouHuiJuan(2, 1, 50);
    if (tickets != null && tickets.length > 0) {
      tickets.forEach((element) {
        YouHuiJuanData youHuiJuanData = YouHuiJuanData().fromJson(element);
        data.add(youHuiJuanData);
      });
    }
    // for (int i = 0; i < 5; i++) {
    //   var item = YouHuiJuanData();
    //   item.id = "$i";
    //   item.goodsValue = 1;
    //   item.expiredTime = "2023-07-25T17:59:32.652+08:00";
    //   data.add(item);
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.payBackgroundColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.pt17),
              topRight: Radius.circular(Dimens.pt17),
            ),
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      safePopPage(selectItem);
                    },
                    child: Container(
                        width: Dimens.pt50,
                        height: Dimens.pt50,
                        child: Center(
                          child: Image.asset(
                            "assets/images/hls_ai_icon_back.png",
                            width: 22.w,
                            height: 22.w,
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: Dimens.pt50,
                      alignment: Alignment.center,
                      child: Center(
                          child: Text(
                        "选择优惠券",
                        style: TextStyle(
                          fontSize: Dimens.pt17,
                          color: Color(0xff151515),
                        ),
                      )),
                    ),
                  )
                ],
              ),
              Center(
                child: Divider(
                  color: Color(0xffe5ded3),
                  height: 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: data == null || data.length == 0
                    ? CErrorWidget("暂无数据", txtColor: Colors.black)
                    : CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              var item = data[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectItem = item;
                                  });
                                  widget.onItemClick(item);
                                },
                                child: Container(
                                  height: 88.w,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/hls_ai_item_bg.png",
                                        height: 88.w,
                                        fit: BoxFit.fill,
                                      ),
                                      Container(
                                          width: 108.w,
                                          height: 88.w,
                                          child: Center(
                                            child: Image.asset(
                                              "assets/images/hls_ai_icon_ai.png",
                                              width: 44.w,
                                              height: 48.w,
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(left: 120.w),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${item.goodsValue}金币",
                                                style: TextStyle(
                                                    color: Color(0xfff26a50),
                                                    fontSize: 23,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "有效期：",
                                                    style: TextStyle(
                                                      color: Color(0xff645e5b),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${DateTimeUtil.utc2iso(item.expiredTime)}",
                                                    style: TextStyle(
                                                      color: Color(0xff645e5b),
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          )),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Image.asset(
                                            (selectItem != null &&
                                                    selectItem.id == item.id)
                                                ? "assets/images/hls_ai_icon_select.png"
                                                : "assets/images/hls_ai_icon_unselect.png",
                                            width: 16.w,
                                            height: 16.w,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }, childCount: data?.length ?? 0),
                          ),
                          // SliverToBoxAdapter(
                          //     child: _buildBuyVIPGoldCoinUI(state, dispatch)),
                        ],
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
