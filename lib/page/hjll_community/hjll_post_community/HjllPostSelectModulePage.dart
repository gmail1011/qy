import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/search/PostModuleModel.dart';
import 'package:flutter_app/model/search/SearchPostModuleModel.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/route_manager.dart' as Gets;

class HjllPostSelectModuelPage extends StatefulWidget {
  String keywords;

  HjllPostSelectModuelPage({Key key, this.keywords});

  @override
  State<HjllPostSelectModuelPage> createState() => _HjllPostSelectModuelPageState();
}

class _HjllPostSelectModuelPageState extends State<HjllPostSelectModuelPage> {
  RefreshController refreshController = RefreshController();
  int pageSize = 10;
  int pageNumber = 1;
  List<PostModuleModel> postModuleList = [];
  BaseRequestController baseRequestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _loadaListData() async {
    if (pageNumber == 1) {
      postModuleList.clear();
    }
    try {
      var value = await netManager.client.publisherTags();
      SearchPostModuleModel model = SearchPostModuleModel.fromJson(value);

      if ((model.list.length ?? 0) == 0) {
        baseRequestController.requestDataEmpty();
      } else {
        baseRequestController.requestSuccess();
      }

      refreshController.refreshCompleted(resetFooterState: true);
      if (model.list != null) {
        postModuleList.addAll(model.list);
      }
      // if(!model.hasNext){
      //   refreshController.loadNoData();
      // }
    } catch (e) {
      baseRequestController.requestFail();
      refreshController.refreshFailed();
    }
  }

  _initData() async {
    pageNumber = 1;
    await _loadaListData();
    setState(() {});
  }

  _refreshData() async {
    pageNumber = 1;
    await _loadaListData();
    refreshController.refreshCompleted();
    setState(() {});
  }

  _loadMoreData() async {
    pageNumber += 1;
    await _loadaListData();
    refreshController.loadComplete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getCommonAppBar("选择帖子标签"),
        body: BaseRequestView(
          retryOnTap: () => _refreshData(),
          controller: baseRequestController,
          child: (postModuleList != null && postModuleList.length > 0)
              ? pullYsRefresh(
                  refreshController: refreshController,
                  enablePullDown: false,
                  enablePullUp: false,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        PostModuleModel postModelModel = postModuleList[index];
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 408,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(32, 39, 51, 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                ClipOval(
                                    child: CustomNetworkImage(
                                  imageUrl: postModelModel.coverImg ?? "",
                                  width: 46,
                                  height: 46,
                                )),
                                SizedBox(width: 8),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "#${postModelModel.name}",
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text("${postModelModel.vidCountDesc}个帖子",
                                            style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: 12)),
                                        Expanded(child: SizedBox()),
                                        Text("${postModelModel.playCountDesc}浏览",
                                            style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: 12)),
                                        Expanded(child: SizedBox()),
                                        Text("${postModelModel.followCountDesc}关注",
                                            style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: 12)),
                                        SizedBox(
                                          width: 23,
                                        )
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                          onTap: () {
                            safePopPage(postModelModel);
                          },
                        );
                      },
                      itemCount: postModuleList == null ? 0 : (postModuleList?.length ?? 0),
                    ),
                  ),
                  onLoading: () {
                    _loadMoreData();
                  },
                  onRefresh: () {
                    _refreshData();
                  },
                )
              : EmptyWidget("mine", 3),
        ));
  }
}
