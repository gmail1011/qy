import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/model/video_paged_list.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_view_video_cell.dart';

///我的收藏列表页面
class MineViewCollectTableView extends StatefulWidget {
  final int type; //1：视频 2：帖子
  MineViewCollectTableView(this.type);

  @override
  State<StatefulWidget> createState() {
    return _MineViewCollectTableViewState();
  }
}

class _MineViewCollectTableViewState extends State<MineViewCollectTableView>
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
    bus.on(EventBusUtils.delVideoCollect, (arg) {
      setState(() {
        videoList.removeAt(arg);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusUtils.delVideoCollect);
  }

  var page = 1;

  void _loadData(bool isReload) {
    if (isReload)
      page = 1;
    else
      page += 1;
    if (widget.type == 1) {
      _getCollectVideo(page);
    } else {
      _getCollectPost(page);
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
      if (page == 1 && dataIsEmpty)
        requestController.requestDataEmpty();
      else {
        if (page == 1)
          refreshController.refreshCompleted();
        else {
          refreshController.loadComplete();
          if (dataIsEmpty) refreshController.loadNoData();
        }
        if (!hasNext) refreshController.loadNoData();
      }
    }
  }

  void _getCollectVideo(int page) async {
    await _requestVideoData(page, "video");
  }

  void _getCollectPost(int page) async {
    await _requestVideoData(page, "img");
  }

  /// 获取收藏视频
  Future<void> _requestVideoData(int page, String type) async {
    Map<String, dynamic> mapList = {};
    mapList['type'] = type;
    mapList['pageNumber'] = page;
    mapList['pageSize'] = Config.PAGE_SIZE;
    mapList['uid'] = GlobalStore.getMe()?.uid ?? 0;
    BaseResponse res = await HttpManager().get(Address.MY_FAVORITE, params: mapList);
    if (res.code == 200) {
      PagedList list = PagedList.fromJson(res.data);
      List<VideoModel> modelList = VideoModel.toList(list.list);

      if (modelList == null || modelList.length == 0) {
        setReqControllerState(false, true, true);
      } else {
        switch (type) {
          case "video":
            if (page == 1) videoList.clear();
            videoList.addAll(modelList);
            break;
          case "img":
            if (page == 1) postList.clear();
            postList.addAll(modelList);

            break;
        }
        setReqControllerState(false, false, modelList.length >= Config.PAGE_SIZE);
        setState(() {});
      }
    } else {
      showToast(msg: res.msg ?? '');
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
            margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
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
                         padding: EdgeInsets.only(left: 10, right: 10),
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
                        shrinkWrap: true,
                        itemCount: postList.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return WordImageWidgetForHjll(
                            videoModel: postList[index],
                            padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                            showTopInfo: false,
                            isMyCollect: true,
                          );
                          // return MineViewPostCell(index, postList[index]);
                        })),
          ),
        ]),
      ),
    );
  }
}
