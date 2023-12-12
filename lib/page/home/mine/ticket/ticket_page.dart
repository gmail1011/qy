import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/user/member_centre_page/wallet/gold_tickets.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TicketPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TicketPageState();
  }


}

class _TicketPageState extends State<TicketPage> {
  int pageNumber = 1;
  int pageSize = 20;
  int type;

  int pageNumberOutTime = 1;
  int pageSizeOutTime = 20;

  GoldTickets goldTickets;

  GoldTickets goldTicketsOutTime;

  List<String> _myTabs = [
    "已拥有",
    "已过期",
  ];

  TabController tabController =
      new TabController(length: 2, vsync: ScrollableState());

  RefreshController refreshController = RefreshController();

  RefreshController refreshControllerOutTime = RefreshController();
  BaseRequestController requestControllerOutTime = BaseRequestController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTicket(0);

    getOutTicket(2);
  }

  Future getTicket(int type) async {
    try {
      dynamic model =
          await netManager.client.getTickets(pageNumber, pageSize, type);

      if (null != model) {
        GoldTickets goldTicketsTemp = GoldTickets.fromJson(model);

        if (pageNumber == 1) {
          goldTickets = null;
          goldTickets = goldTicketsTemp;

          refreshController.refreshCompleted();

        } else {
          if (goldTicketsTemp.list == null ||
              goldTicketsTemp.list.length == 0) {
            refreshController.loadNoData();
          } else {
            goldTickets.list.addAll(goldTicketsTemp.list);

            refreshController.loadComplete();
          }
        }


        setState(() {});
      } else {
      }
    } catch (e) {}
  }

  Future getOutTicket(int type) async {
    try {
      dynamic model = await netManager.client
          .getTickets(pageNumberOutTime, pageSizeOutTime, type);

      if (null != model) {
        GoldTickets goldTicketsTemp = GoldTickets.fromJson(model);

        if (pageNumberOutTime == 1) {
          goldTicketsOutTime = null;
          goldTicketsOutTime = goldTicketsTemp;

          refreshControllerOutTime.refreshCompleted();
        } else {
          if (goldTicketsTemp.list == null ||
              goldTicketsTemp.list.length == 0) {
            refreshControllerOutTime.loadNoData();
          } else {
            goldTicketsOutTime.list.addAll(goldTicketsTemp.list);

            refreshControllerOutTime.loadComplete();
          }
        }

        requestControllerOutTime.requestSuccess();

        setState(() {});
      } else {
        requestControllerOutTime.requestDataEmpty();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FullBg(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          titleSpacing: .0,
          title: Text(
            "我的优惠券",
            style: TextStyle(
                fontSize: AppFontSize.fontSize18,
                color: Colors.white,
                height: 1.4),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => safePopPage(),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(25),
            child: commonTabBar(
              TabBar(
                controller: tabController,
                tabs: _myTabs.map((e) => Text(e)).toList(),
                indicator: RoundUnderlineTabIndicator(
                  borderSide: BorderSide(color: AppColors.weiboColor, width: 2),
                ),
                indicatorWeight: 4,
                isScrollable: true,
                unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
                labelColor: Colors.white,
                labelPadding: EdgeInsets.symmetric(horizontal: 20),
                labelStyle: TextStyle(fontSize: Dimens.pt16),
                unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
                /*onTap: (index) =>
                    dispatch(
                        MyFavoriteActionCreator.changeEditState(
                            state.tabController.index)),*/
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            goldTickets == null
                ? LoadingWidget()
                : Container(
                    margin: EdgeInsets.only(
                      left: Dimens.pt21,
                      right: Dimens.pt21,
                    ),
                    child: pullYsRefresh(
                      refreshController: refreshController,
                      onRefresh: () {
                        pageNumber = 1;
                        getTicket(0);
                      },
                      onLoading: () {
                        pageNumber = pageNumber + 1;
                        getTicket(2);
                      },
                      //enablePullDown: false,
                      child: ListView.builder(
                        itemCount: goldTickets.list.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: Dimens.pt88,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              top: Dimens.pt14,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/weibo/coupon_bg.png"),
                              ),
                            ),
                            width: screen.screenWidth,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: Dimens.pt6,
                                ),

                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "加赠券",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt16),
                                    ),
                                    Text(
                                      "¥" +
                                          goldTickets.list[index].price
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimens.pt22),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  width: Dimens.pt22,
                                ),

                                Container(
                                  // margin: EdgeInsets.only(left: Dimens.pt18),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        goldTickets.list[index].name,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                242, 106, 80, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimens.pt23),
                                      ),
                                      Text(
                                        "有效期: " +
                                            DateTimeUtil.utc2iso(
                                              goldTickets
                                                  .list[index].expireTime,
                                            ),
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 94, 91, 1),
                                            fontSize: Dimens.pt12),
                                      ),
                                    ],
                                  ),
                                ),

                                //SizedBox(width: Dimens.pt10,),

                                goldTickets.list[index].used
                                    ? Container()
                                    : Container(
                                  margin: EdgeInsets.only(
                                      left: Dimens.pt16),
                                  width: Dimens.pt23,
                                  height: Dimens.pt30,
                                  color:
                                  Color.fromRGBO(234, 114, 85, 1),
                                  child: Text(
                                    "立",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Dimens.pt12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),




            goldTicketsOutTime == null
                ? LoadingWidget()
                : Container(
                    margin: EdgeInsets.only(
                      left: Dimens.pt21,
                      right: Dimens.pt21,
                    ),
                    child: BaseRequestView(
                      retryOnTap: () {
                        //return dispatch(LongVideoActionCreator.refreshVideo());
                      },
                      child: pullYsRefresh(
                        refreshController: refreshControllerOutTime,
                        onRefresh: () {
                          pageNumberOutTime = 1;
                          getOutTicket(0);
                        },
                        onLoading: () {
                          pageNumberOutTime = pageNumberOutTime + 1;
                          getOutTicket(2);
                        },
                        child: ListView.builder(
                          itemCount: goldTicketsOutTime.list.length,
                          itemBuilder: (context, index) {


                            return Container(
                              height: Dimens.pt88,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                top: Dimens.pt14,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      "assets/weibo/no_coupon_bg.png"),
                                ),
                              ),
                              width: screen.screenWidth,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: Dimens.pt6,
                                  ),

                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "加赠券",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimens.pt16),
                                      ),
                                      Text(
                                        "¥" +
                                            goldTicketsOutTime.list[index].price
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimens.pt22),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    width: Dimens.pt22,
                                  ),

                                  Container(
                                    // margin: EdgeInsets.only(left: Dimens.pt18),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goldTicketsOutTime.list[index].name,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  102, 102, 102, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimens.pt23),
                                        ),
                                        Text(
                                          "有效期: " +
                                              DateTimeUtil.utc2iso(
                                                goldTicketsOutTime
                                                    .list[index].expireTime,
                                              ),
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  100, 94, 91, 1),
                                              fontSize: Dimens.pt12),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //SizedBox(width: Dimens.pt10,),

                                  goldTicketsOutTime.list[index].used
                                      ? Container()
                                      : Container(
                                    margin: EdgeInsets.only(
                                        left: Dimens.pt16),
                                    width: Dimens.pt23,
                                    height: Dimens.pt30,
                                    color:
                                    Color.fromRGBO(234, 114, 85, 1),
                                    child: Text(
                                      "立",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Dimens.pt12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      controller: requestControllerOutTime,
                    ),
                  ),
          ],
          dragStartBehavior: DragStartBehavior.down,
        ),
      ),
    );
  }
}
