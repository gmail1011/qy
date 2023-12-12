import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/wallet/game_bill_detail/game_bill_detail_entity.dart';
import 'package:flutter_app/page/wallet/pay_for_nake_chat/model/nake_chat_bill_detail_entity.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/custom_refresh_footer.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NakeChatBillDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GameBillDetailPageState();
  }
}

class _GameBillDetailPageState extends State<NakeChatBillDetailPage> {
  int pageNumber = 1;
  int pageSize = 10;
  NakeChatBillDetailData gameBillDetailEntity;

  EasyRefreshController refreshController;

  bool requestComplete = false;

  List<NakeChatBillDetailDataList> xList = [];

  bool isHasMore = true;
  bool isRefresh = true;

  bool isLoading  = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshController = new EasyRefreshController();
    getGameBillDetail();
  }

  Future getGameBillDetail() async {
    isLoading = true;
    dynamic result = await netManager.client.getNakeChatMineBillList(
      pageNumber,
      pageSize,
    );
    gameBillDetailEntity = NakeChatBillDetailData().fromJson(result);

    if (gameBillDetailEntity != null &&
        gameBillDetailEntity.xList != null &&
        gameBillDetailEntity.xList.length > 0) {
      if (isRefresh) {
        xList.clear();
      }
      isHasMore = true;
      xList.addAll(gameBillDetailEntity.xList);
    } else {
      isHasMore = false;
    }

    isLoading = false;

    setState(() {});
  }

  Widget getCoinText(BuildContext context, int index) {
    String value;

    if (double.parse((xList[index].fruitCoin.toString() ?? 0)) > 0) {
      value = "+" + xList[index].fruitCoin.toString() + "元";
    } else if (double.parse((xList[index].fruitCoin.toString() ?? 0)) < 0) {
      value = xList[index].fruitCoin.toString() + "元";
    } else if (double.parse((xList[index].fruitCoin.toString() ?? 0)) == 0) {
      value = (xList[index].amount ~/ 10).toString() + "元";
    }

    return Text(value,
        style: TextStyle(color: Colors.white, fontSize: Dimens.pt14));
  }

  Widget getItem(BuildContext context, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: Dimens.pt18,
              right: Dimens.pt16,
              bottom: Dimens.pt10,
            ),
            child: Column(
              children: <Widget>[
                Divider(
                  color: Color(0xFFd8d8d8),
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${xList[index].desc ??= ""}",
                              style: TextStyle(
                                  color: Color(0xffd8d8d8),
                                  fontSize: Dimens.pt14,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(padding: EdgeInsets.only(top: Dimens.pt5)),
                            Text(
                              "${xList[index].tranType ??= ""}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: Dimens.pt12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(padding: EdgeInsets.only(top: Dimens.pt5)),
                            Text(
                              xList[index].createdAt == null ||
                                      xList[index].createdAt == ""
                                  ? ""
                                  : DateTimeUtil.utc2iso(xList[index].createdAt),
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: Dimens.pt12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.fromLTRB(Dimens.pt9, 0, 0, 0),
                          child: getCoinText(context, index)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(
          title: "我的賬單",
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              EasyRefresh.custom(
                enableControlFinishLoad: true,
                enableControlFinishRefresh: true,
                controller: refreshController,
                header: ClassicalHeader(
                  enableInfiniteRefresh: false,
                  bgColor: null,
                  textColor: Colors.white,
                  float: false,
                  showInfo: false,
                  enableHapticFeedback: true,
                  refreshText: "下拉刷新",
                  refreshReadyText: "松開刷新",
                  refreshingText: "刷新中...",
                  refreshedText: "刷新完成",
                  refreshFailedText: "刷新失敗，請檢查網絡～",
                ),
                footer: CustomRefreshFooter(
                    loadText: "上拉加載",
                    loadReadyText: "松開加載",
                    loadingText: "加載中...",
                    loadedText: "加載成功",
                    loadFailedText: "加載失敗，請檢查網絡～",
                    noMoreText: "親，人家也是有底線的喲～",
                    showInfo: false,
                    bgColor: Colors.transparent,
                    textColor: Color(0xffBDBDBD),
                    infoColor: Color(0xffBDBDBD),
                    fontSize: 13,
                    infoFontSize: 11),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return getItem(context, index);
                      },
                      childCount: xList.length == 0 ? 0 : xList.length,
                    ),
                  ),
                ],
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 2000));
                  isRefresh = true;
                  pageNumber = 1;
                  pageSize = 10;
                  await getGameBillDetail().then((value) {
                    refreshController.finishRefresh(
                      success: true,
                    );
                    refreshController.finishLoad(
                        success: true, noMore: !isHasMore);
                  });
                },
                onLoad: () async {
                  isRefresh = false;
                  pageNumber += 1;
                  pageSize = 10;
                  await getGameBillDetail().then((value) {
                    refreshController.finishLoad(
                        success: true, noMore: !isHasMore);
                  });
                },
              ),
              //加载动画
              Offstage(
                offstage: gameBillDetailEntity == null
                    ? false
                    : true,
                child: Center(child: Container()),
              ),

              Offstage(
                offstage: isLoading ? false : true,
                child: Center(child: LoadingWidget()),
              ),

              //空页面
              Offstage(
                offstage: xList.length == 0 ? false : true,
                child: InkResponse(
                  child: Container(
                      width: Dimens.pt360, child: CErrorWidget("沒有數據...")),
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
