import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/film_tv_video/AllTags.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_list/HjllCommunityListPage.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_quanzi_detail/HjllCommunityQuanziDetailPage.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

///影视长视频列表
Widget buildView(HjllCommunityChildState state, Dispatch dispatch, ViewService viewService) {
  double width = (screen.screenWidth - 10 * 2 - 7 * 2) / 3;
  double height = ((screen.screenWidth - 10 * 2 - 7 * 2) / 3) * (66 / 131);
  return SafeArea(
    //color: Color.fromRGBO(13, 14, 31, 1),
    child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        // 返回一个 Sliver 数组给外部可滚动组件。
        return <Widget>[
          SliverStickyHeader(
              sticky: false,
              header: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ///广告位置
                    (state.adsList == null || state.adsList.length == 0)
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(
                              top: 20,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: AdsBannerWidget(
                                state.adsList,
                                width: screen.screenWidth - 10 * 2,
                                height: (screen.screenWidth - 10 * 2) * (169 / 408),
                                onItemClick: (index) {
                                  var ad = state.adsList[index];
                                  JRouter().handleAdsInfo(ad.href, id: ad.id);
                                },
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: (state.allTags == null || state.allTags.length == 0)
                          ? SizedBox()
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.allTags == null ? 0 : (state.allTags?.length ?? 0),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 7.0,
                                childAspectRatio: 131 / 66,
                              ),
                              itemBuilder: (context, index) {
                                AllTags allTag = state.allTags[index];
                                return GestureDetector(
                                  onTap: () {
                                    clearAllCache();

                                    Gets.Get.to(HjllCommunityQuanziDetailPage(
                                      videoTagId: allTag.id,
                                      videoTagName: allTag.tagName,
                                    ),opaque: false).then((value) {
                                      clearAllCache();
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(2)),
                                      ),
                                      alignment: Alignment.center,
                                      width: width,
                                      height: height,
                                      child: Stack(
                                        children: [
                                          CustomNetworkImage(
                                            imageUrl: state.allTags[index].coverImg,
                                            width: width,
                                            height: height,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            width: width,
                                            height: height,
                                            color: Color.fromRGBO(0, 0, 0, 0.6),
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("${state.allTags[index].tagName}",
                                                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14)),
                                                Text("${state.allTags[index].videoCount}个帖子",
                                                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12))
                                              ],
                                            ),
                                          ),
                                          (allTag.hotMark == null || allTag.hotMark == "")
                                              ? SizedBox()
                                              : Positioned(
                                                  child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [Color.fromRGBO(252, 118, 118, 1), Color.fromRGBO(212, 39, 39, 1)]),
                                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(6))),
                                                  width: 26,
                                                  height: 14,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "${state.allTags[index].hotMark}",
                                                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 11),
                                                  ),
                                                ))
                                        ],
                                      )),
                                );
                              }),
                    ),
                    (state.allTags == null || state.allTags?.length == 0)
                        ? SizedBox()
                        : SizedBox(
                            height: 6,
                          ),
                  ],
                ),
              )),
        ];
      },
      body: HjllCommunityListPage(
        videoTagId: state.sectionID,
      ),
    ),
  );
}

