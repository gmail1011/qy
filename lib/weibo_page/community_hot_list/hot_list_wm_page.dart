import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/net2/net_manager.dart';
import '../../model/TopListModel.dart';
import '../../page/home/film_tv/film_tv_video_detail/film_video_introduction/page.dart';
import '../../widget/common_widget/ys_pull_refresh.dart';
import '../../widget/coupon_widget.dart';
import 'package:get/route_manager.dart' as Gets;

///周榜、月榜（week/month）
class HotListWMPage extends StatefulWidget {
  var type = 0; //week:0 month:1     week, month, debate, event
  String seriesID;

  HotListWMPage(this.type, {this.seriesID});

  @override
  State<StatefulWidget> createState() {
    return _HotListWMPageState();
  }
}

class _HotListWMPageState extends State<HotListWMPage> {
  TopListModel tlm;

  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getTopList();
  }

  void getTopList() async {
    tlm = await netManager.client.getTopList(
        widget.type == 0 ? "week" : "month",
        seriesID: widget.seriesID);

    refreshController.refreshCompleted();
    if (tlm != null && tlm.list != null) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: pullYsRefresh(
          refreshController: refreshController,
          enablePullUp: false,
          onRefresh: () {
            getTopList();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset(
                  widget.type == 0
                      ? "assets/images/hls_bd_zyb_zb.png"
                      : "assets/images/hls_bd_zyb_yb.png",
                  fit: BoxFit.fill,
                  height: 120,
                ),
                Container(
                    margin: EdgeInsets.only(top: 110),
                    alignment: Alignment.center,
                    child: (tlm == null || tlm.list == null)
                        ? CErrorWidget("暂无数据")
                        : ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = tlm.list[index].videoInfo;
                              return GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> maps = Map();
                                  maps["videoId"] = item.id;

                                  maps['videoModel'] = item;

                                  Gets.Get.to(
                                      () => FilmTvVideoDetailPage()
                                          .buildPage(maps),
                                      opaque: false);
                                },
                                child: Container(
                                  height: 107,
                                  color: Color(0x7a222222),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      CustomNetworkImage(
                                          imageUrl: item?.cover ?? "",
                                          width: 175,
                                          height: 97),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item?.title ?? "",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.nsp,
                                                    height: 1.2),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "@${item?.publisher?.name}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.nsp),
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "${item?.playCount}观看\t\t${item?.commentCount}评论数",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff4e586e),
                                                        fontSize: 13.nsp),
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
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return line();
                            },
                            itemCount: tlm.list.length ?? 0)),
              ],
            ),
          )),
    );
  }
}
