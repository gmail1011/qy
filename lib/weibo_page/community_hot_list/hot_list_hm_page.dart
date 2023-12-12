import 'package:flutter/material.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/image/custom_network_image.dart';
import '../../common/net2/net_manager.dart';
import '../../model/TopListUPModel.dart';
import '../../model/top_list_up_item_model.dart';
import '../../widget/common_widget/error_widget.dart';
import '../../widget/common_widget/ys_pull_refresh.dart';
import '../../widget/coupon_widget.dart';
import '../widget/bloggerPage.dart';

///黑马榜
class HotListHMPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotListHMPageState();
  }
}

class _HotListHMPageState extends State<HotListHMPage> {
  TopListUPModel tupl;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getTopList();
  }

  void getTopList() async {
    tupl = await netManager.client.getHMUpList();

    refreshController.refreshCompleted();
    setState(() {});
  }

  ///关注
  void _followUser(TopListUpItemModel item) async {
    /// 用户uid
    try {
      await netManager.client.getFollow(item.uid, true);
      showToast(msg: "关注成功～");
      setState(() {
        item.hasFollow = true;
      });
    } catch (e) {
      showToast(msg: e.toString() ?? '');
    }
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
                  "assets/images/hls_bd_zyb_hm.png",
                  fit: BoxFit.fill,
                  height: 120,
                ),
                Container(
                    margin: EdgeInsets.only(top: 120),
                    alignment: Alignment.center,
                    child: (tupl == null || tupl.list == null)
                        ? CErrorWidget("暂无数据")
                        : ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = tupl.list[index];
                              return GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> map = {
                                    'uid': item.uid,
                                    'uniqueId':
                                        DateTime.now().toIso8601String(),
                                  };
                                  Gets.Get.to(BloggerPage(map), opaque: false);
                                },
                                child: Container(
                                  height: 70,
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  color: Color(0x7a222222),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(26)),
                                          child: CustomNetworkImage(
                                            imageUrl: item?.portrait ?? "",
                                            width: 52,
                                            height: 52,
                                          ),
                                        ),
                                        if (item.isVip)
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Image.asset(
                                                "assets/images/hls_bd_hm_vip.png",
                                                width: 15,
                                                height: 15),
                                          )
                                      ]),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          item?.name ?? "",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17.nsp,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        if (item.superUser == 1)
                                                          Image.asset(
                                                              "assets/images/hls_bd_hm_wg.png",
                                                              width: 20,
                                                              height: 20),
                                                      ],
                                                    ),
                                                    SizedBox(height: 7),
                                                    Text(
                                                      "7日粉丝增长数：${item.fans}",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff4e586e),
                                                          fontSize: 13.nsp),
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (!item.hasFollow)
                                                GestureDetector(
                                                  onTap: () {
                                                    _followUser(item);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Image.asset(
                                                      "assets/images/hls_bd_follow_btn.png",
                                                      width: 68,
                                                      height: 26,
                                                    ),
                                                  ),
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
                            itemCount: tupl.list.length ?? 0)),
              ],
            ),
          )),
    );
  }
}
