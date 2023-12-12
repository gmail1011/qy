import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/route_manager.dart' as Gets;

class HjlSearchPostResultPage extends StatefulWidget {
  String keywords;

  List<LiaoBaTagsDetailDataVideos> videoList = [];

  HjlSearchPostResultPage({Key key, this.keywords});

  @override
  State<HjlSearchPostResultPage> createState() => _HjlSearchPostResultPageState();
}

class _HjlSearchPostResultPageState extends State<HjlSearchPostResultPage> {
  RefreshController refreshController = RefreshController();
  int pageSize = 10;
  int pageNumber = 1;
  int moduleSort = 3;
  List<VideoModel> videoList = [];
  BaseRequestController baseRequestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _loadaListData() async {
    if (pageNumber == 1) {
      videoList.clear();
    }
    try {
      var model = await netManager.client.getVideoData(pageNumber, pageSize, [widget.keywords], 'COVER');
      if ((model.list.length ?? 0) == 0 && pageNumber == 1) {
        baseRequestController.requestDataEmpty();
      } else {
        baseRequestController.requestSuccess();
      }

      if (!model.hasNext) {
        refreshController.loadNoData();
      } else {
        if (pageNumber == 1) {
          refreshController.refreshCompleted();
        } else {
          refreshController.loadComplete();
        }
      }
      if (model.list != null) {
        videoList.addAll(model.list);
      }
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
    setState(() {});
  }

  _loadMoreData() async {
    pageNumber += 1;
    await _loadaListData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
        child: BaseRequestView(
      retryOnTap: () => _refreshData(),
      controller: baseRequestController,
      child: (videoList != null && videoList.length > 0)
          ? pullYsRefresh(
              refreshController: refreshController,
              enablePullDown: true,
              child:  ListView.builder(
                padding: EdgeInsets.only(left: 10, right: 10),
                itemBuilder: (context, index) {
                  return WordImageWidgetForHjll(
                    videoModel: videoList[index],
                    showTopInfo: false,
                  );
                },
                itemCount: videoList == null ? 0 : (videoList?.length ?? 0),
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
