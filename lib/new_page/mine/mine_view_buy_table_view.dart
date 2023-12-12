import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_view_video_cell.dart';

///我的收藏列表页面
class MineViewBuyTableView extends StatefulWidget {
  final int type; //1：视频 2：帖子
  MineViewBuyTableView(this.type);

  @override
  State<StatefulWidget> createState() {
    return _MineViewBuyTableViewState();
  }
}

class _MineViewBuyTableViewState extends State<MineViewBuyTableView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<VideoModel> videoList = [];
  List<VideoModel> postList = [];

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _loadData(true);
  }

  var page = 1;

  void _loadData(bool isReload) {
    if (isReload)
      page = 1;
    else
      page += 1;
    if (widget.type == 1) {
      _getBuyVideo(page);
    } else {
      _getBuyPost(page);
    }
  }

  void setReqControllerState(bool isCatch, bool dataIsEmpty, bool hasNext) {
    if (isCatch) {
      if (page == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }

      requestController.requestFail();
    } else {
      requestController.requestSuccess();
      if (page == 1 && dataIsEmpty) requestController.requestDataEmpty();
      if (page == 1)
        refreshController.refreshCompleted();
      else {
        refreshController.loadComplete();
        if (dataIsEmpty) refreshController.loadNoData();
      }
      if (!hasNext) refreshController.loadNoData();
    }
  }

  void _getBuyVideo(int page) async {
    _loadBuyPicData(page, "SP");
  }

  void _getBuyPost(int page) async {
    _loadBuyPicData(page, "COVER");
  }

  ///我的购买
  void _loadBuyPicData(int page, String type) async {
    int pageNumber = page;
    int pageSize = Config.PAGE_SIZE;
    int uid = GlobalStore.getMe().uid;

    try {
      MineVideo works = await netManager.client.getMineBuy(pageSize, pageNumber, type, uid);
      if ((works?.list ?? []).isNotEmpty) {
        switch (type) {
          case "SP":
            if (page == 1) videoList.clear();
            videoList.addAll(works?.list);
            break;
          case "COVER":
            if (page == 1) postList.clear();
            postList.addAll(works?.list);
            break;
        }
        setReqControllerState(false, false, works.hasNext);
      } else {
        if (pageNumber == 1)
          setReqControllerState(false, true, works.hasNext);
        else
          setReqControllerState(false, false, works.hasNext);
      }
      setState(() {});
    } catch (e) {
      setReqControllerState(true, false, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: BaseRequestView(
        controller: requestController,
        child: Stack(children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: pullYsRefresh(
                refreshController: refreshController,
                onRefresh: () async {
                  Future.delayed(Duration(milliseconds: 1000), () {
                    _loadData(true);
                  });
                },
                onLoading: () => _loadData(false),
                child: widget.type == 1
                    ? GridView.builder(
                        padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 168/130,),
                        itemCount: videoList.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return MineViewVideoCell(index, videoList[index]);
                        })
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        shrinkWrap: true,
                        itemCount: postList.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return WordImageWidgetForHjll(
                            videoModel: postList[index],
                            padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                            showTopInfo: false,
                          );
                          // return MineViewPostCell(index, postList[index]);
                        })),
          ),
        ]),
      ),
    );
  }
}
