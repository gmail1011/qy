import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_list/HjllCommunityListPage.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'HjllQuanziListPage.dart';

class HjllCommunityQuanziDetailPage extends StatefulWidget {
  String videoTagId;
  String videoTagName;
  TagDetailModel tagDetailModel;

  List<LiaoBaTagsDetailDataVideos> videoList = [];

  HjllCommunityQuanziDetailPage({Key key, this.videoTagId, this.videoTagName});

  @override
  State<HjllCommunityQuanziDetailPage> createState() => _HjllCommunityQuanziDetailPageState();
}

class _HjllCommunityQuanziDetailPageState extends State<HjllCommunityQuanziDetailPage> {
  int moduleSort = 3;
  TabController tabController = TabController(length: Config.communityVideType.length, vsync: ScrollableState());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  _loadData() async {
    widget.tagDetailModel = await netManager.client.getTagDetail(widget.videoTagId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("${widget.videoTagName}"),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              (widget.tagDetailModel == null)
                  ? SizedBox()
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: CustomNetworkImage(
                        fit: BoxFit.cover,
                        height: 90,
                        width: 90,
                        imageUrl: widget.tagDetailModel?.coverImg ?? "",
                      ),
                    ),
              SizedBox(width: 12),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 28,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.tagDetailModel?.description ?? "",
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Visibility(
                            visible: widget.tagDetailModel?.hasCollected == true ? false : true,
                            child: GestureDetector(
                              child: Container(
                                  width: 63,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryTextColor),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "+",
                                        style: TextStyle(color: AppColors.primaryTextColor, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        "关注",
                                        style: TextStyle(color: AppColors.primaryTextColor, fontSize: 12),
                                      ),
                                    ],
                                  )),
                              onTap: () async {
                                bool isFollow = !widget.tagDetailModel.hasCollected;

                                widget.tagDetailModel.hasCollected = isFollow;

                                try {
                                  await netManager.client.postCollect(widget.tagDetailModel.id, 'tag', isFollow);
                                } catch (e) {
                                  showToast(msg: Lang.FOLLOW_ERROR, gravity: ToastGravity.CENTER);
                                }
                                setState(() {});
                              },
                            )),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "${widget.tagDetailModel?.videoCountDesc ?? 0}个帖子",
                    style: TextStyle(color: Color(0xff999999), fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "${widget.tagDetailModel?.playCountDesc ?? 0}浏览",
                    style: TextStyle(color: Color(0xff999999), fontSize: 12),
                  ),
                ],
              ))
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 12, top: 10),
            child: commonTabBar(
              TabBar(
                controller: tabController,
                tabs: Config.communityVideType
                    .map(
                      (e) => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 1),
                        height: 26,
                        child: Text(
                          "  $e  ",
                          maxLines: 1,
                        ),
                      ),
                    )
                    .toList(),
                indicator: BoxDecoration(
                  color: Color(0xff1f2030),
                  borderRadius: BorderRadius.circular(13),
                ),
             //   indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: Color.fromRGBO(153, 153, 153, 1),
                unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                labelColor: Colors.white,
                isScrollable: true,
                labelStyle: TextStyle(fontSize: 14),
                labelPadding: EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: Config.communityVideType
                  .map(
                    (e) => HjlQuanziListPage(
                      typeName: e,
                      videoTagId: widget.videoTagId,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
