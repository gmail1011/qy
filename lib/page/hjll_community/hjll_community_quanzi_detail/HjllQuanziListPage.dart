import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';

import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';

import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HjlQuanziListPage extends StatefulWidget {
  final String typeName;
  final String videoTagId;



  HjlQuanziListPage({Key key, this.typeName, this.videoTagId, bool isQuanziDetail = false}) : super(key: key);

  @override
  State<HjlQuanziListPage> createState() => _HjlQuanziListPageState();
}

class _HjlQuanziListPageState extends State<HjlQuanziListPage> {
  RefreshController refreshController = RefreshController();
  int pageSize = 10;
  int pageNumber = 1;
  int moduleSort = 3;
  List<VideoModel> videoList;


  @override
  void initState() {
    super.initState();
    //圈子详情 排序类型 1、推荐，2、最新，3、最热 4、精华，5、视频
    switch (widget.typeName) {
      case "推荐":
        moduleSort = 1;
        break;
      case "最新":
        moduleSort = 2;
        break;
      case "最热":
        moduleSort = 3;
        break;
      case "精华":
        moduleSort = 4;
        break;
      case "视频":
        moduleSort = 5;
        break;
      default:
        moduleSort = 1;
        break;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initData();
    });
  }

  _loadaListData() async {
    if (pageNumber == 1) {
      videoList?.clear();
    }
    try {
      TagBean tagListModel = await netManager.client.requestTagListData(pageNumber, 25, widget.videoTagId, sortType: moduleSort.toString());
      videoList ??= [];
      if (tagListModel != null && tagListModel.list != null) {
        videoList?.addAll(tagListModel.list);
      }
      if (!tagListModel.hasNext) {
        refreshController.loadNoData();
      }else {
        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadComplete();
      videoList ??= [];
    }
    refreshController.refreshCompleted();
    setState(() {});
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
    if(videoList == null){
      return LoadingWidget();
    }else if(videoList.isNotEmpty != true){
      return CErrorWidget("暂无数据", retryOnTap: (){
        videoList = null;
        setState(() {});
        _initData();
      },);
    }else {
      return pullYsRefresh(
        refreshController: refreshController,
        onLoading: () {
          _loadMoreData();
        },
        onRefresh: () {
          _refreshData();
        },
        child: ListView.builder(
          itemCount: videoList?.length ?? 0,
          itemBuilder: (context, index) {
            VideoModel _realModel = videoList[index];
            return WordImageWidgetForHjll(
              videoModel: _realModel,
              showTopInfo: false,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    clearAllCache();
    super.dispose();
  }
}
