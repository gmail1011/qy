import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_store/cache_video_model.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_view_video_cell.dart';

///我的收藏列表页面
class MineViewCacheTableView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineViewCacheTableViewState();
  }
}

class _MineViewCacheTableViewState extends State<MineViewCacheTableView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<CachedVideoModel> videoList = [];

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _loadData(true);
    bus.on(EventBusUtils.delVideoCache, (arg) {
      _loadData(true);
    });
  }

  var page = 1;

  void _loadData(bool isReload) {
    if (isReload)
      page = 1;
    else
      page += 1;
    _getCacheVideo();
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

  ///获取缓存列表
  void _getCacheVideo() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));
      videoList = await CachedVideoStore().getCachedVideosByType(CACHED_TYPE_FILM);
      if (videoList.isEmpty) {
        setReqControllerState(false, true, false);
      } else {
        setReqControllerState(false, false, false);
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
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: pullYsRefresh(
              refreshController: refreshController,
              enablePullUp: false,
              onRefresh: () async {
                Future.delayed(Duration(milliseconds: 1000), () {
                  _loadData(true);
                });
              },
              onLoading: () => _loadData(false),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.9),
                  itemCount: videoList.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return MineViewVideoCell(index, videoList[index].videoModel,isCache: true,);
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
