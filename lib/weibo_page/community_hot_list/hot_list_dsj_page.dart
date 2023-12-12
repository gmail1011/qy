import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/net2/net_manager.dart';
import '../../model/TopListModel.dart';
import '../../model/top_list_circle_item_model.dart';
import '../../widget/common_widget/ys_pull_refresh.dart';
import '../../widget/coupon_widget.dart';

///大事记
class HotListDSJPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotListDSJPageState();
  }
}

class _HotListDSJPageState extends State<HotListDSJPage>
    with TickerProviderStateMixin {
  List<TopListCircleItemModel> circleItems = [];
  TopListCircleItemModel currentSelect;
  TopListModel tlm;

  int pageNumber = 1;
  int pageSize = 20;
  bool showCircleItems = false;
  bool hasMoreCircleItem = false;

  RefreshController refreshController;
  RefreshController refreshController2;

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    refreshController2 = RefreshController();
    init();
  }

  void init() async {
    await getTopCircleList();
    if (circleItems != null) getTopList(circleItems.first);
  }

  Future<void> getTopCircleList() async {
    var tlcm = await netManager.client.getTopSeriesList(pageNumber, pageSize);
    hasMoreCircleItem = tlcm.hasNext;
    if (pageNumber == 1) {
      circleItems.clear();
      refreshController2.refreshCompleted();
    } else {
      refreshController2.loadComplete();
    }
    circleItems.addAll(tlcm.list);
    setState(() {});
  }

  void getTopList(TopListCircleItemModel item) async {
    currentSelect = item;
    tlm = await netManager.client.getTopList(item.type, seriesID: item.id);
    refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screen.screenHeight - screen.bottomNavBarH - 10,
      child: Stack(
        children: [
          Positioned.fill(
            child: pullYsRefresh(
                refreshController: refreshController,
                enablePullUp: false,
                onRefresh: () {
                  getTopList(currentSelect);
                },
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/hls_bd_zyb_dsj.png",
                      fit: BoxFit.fill,
                      height: 120,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 110),
                      child: (tlm == null || tlm.list == null)
                          ? CErrorWidget("暂无数据")
                          : ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var item = tlm.list[index].videoInfo;
                                var hasComment = false;
                                return GestureDetector(
                                  onTap: () {
                                    Map<String, dynamic> maps = Map();
                                    maps["videoId"] = item.id;
                                    Gets.Get.to(
                                        () => FilmTvVideoDetailPage()
                                            .buildPage(maps),
                                        opaque: false);
                                  },
                                  child: Container(
                                    height: hasComment ? 170 : 127,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    margin: EdgeInsets.only(top: 10),
                                    color: Color(0x7a222222),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 107,
                                          child: Row(
                                            children: [
                                              CustomNetworkImage(
                                                  imageUrl: item?.cover ?? "",
                                                  width: 175,
                                                  height: 97),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item?.title ?? "",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.nsp,
                                                            height: 1.2),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "@${item?.publisher?.name}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    12.nsp),
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            "${item?.playCount}观看\t\t${item?.commentCount}评论数",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff4e586e),
                                                                fontSize:
                                                                    13.nsp),
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        if (hasComment) SizedBox(height: 10),
                                        if (hasComment)
                                          Container(
                                            height: 33,
                                            padding: EdgeInsets.only(left: 15),
                                            decoration: BoxDecoration(
                                              color: Color(0x47343434),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "\“",
                                                  style: TextStyle(
                                                      color: Color(0xfff68216),
                                                      fontSize: 23.nsp),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  item.comment.content,
                                                  style: TextStyle(
                                                      color: Color(0xffa0a0a0),
                                                      fontSize: 13.nsp),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return line();
                              },
                              itemCount: tlm.list.length ?? 0),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 95, left: 16),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showCircleItems = !showCircleItems;
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              currentSelect?.title ?? "",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.nsp),
                            ),
                            Image.asset(
                              showCircleItems
                                  ? "assets/images/hls_dsj_arrow_down.png"
                                  : "assets/images/hls_dsj_arrow-up.png",
                              width: 12,
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Positioned.fill(
              top: 120,
              left: 0,
              child: Container(
                width: screen.screenWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: showCircleItems,
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 20, left: 16, right: 16),
                          decoration: BoxDecoration(
                              color: Color(0xff171717),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))),
                          child: pullYsRefresh(
                            refreshController: refreshController2,
                            enablePullUp: hasMoreCircleItem,
                            onRefresh: () {
                              pageNumber = 1;
                              getTopCircleList();
                            },
                            onLoading: () {
                              pageNumber += 1;
                              getTopCircleList();
                            },
                            child: GridView.builder(
                                itemCount: circleItems.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, //横向数量
                                  crossAxisSpacing: 5, //间距
                                  mainAxisSpacing: 5, //行距
                                  childAspectRatio: 200 / 50,
                                ),
                                itemBuilder: (context, index) {
                                  var item = circleItems[index];
                                  var isSelect = item.id == currentSelect.id;
                                  return GestureDetector(
                                    onTap: () {
                                      showCircleItems = false;
                                      getTopList(item);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: isSelect
                                          ? BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/hls_bd_zy_select_bg.png"),
                                                  fit: BoxFit.fitWidth))
                                          : BoxDecoration(
                                              color: Color(0xff1d1d1d),
                                              border: Border.all(
                                                  color: Color(0x40767676),
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                      child: Center(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                              color: isSelect
                                                  ? Colors.white
                                                  : Color(0xffa8a8a8),
                                              fontSize: 14.nsp),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
