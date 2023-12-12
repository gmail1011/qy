import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum RecordingType {
  buyLog, //购买记录
  favoritesLog, //收藏记录
  reserveLog //预约记录
}

class ItemView extends StatefulWidget {
  final RecordingType type;

  const ItemView(this.type, {Key key}) : super(key: key);
  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  // 楼风列表
  List<LouFengItem> louFengList = [];
  int pageNumber = 1;
  int pageSize = 10;
  bool isMustNotShowBuyImg = false;
  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();
  // 获取列表
  void _getData() async {
    LouFengModel louFengModel;
    try {
      if (RecordingType.buyLog == widget.type) {
        louFengModel = await netManager.client.getBuyList(pageNumber, pageSize);
        isMustNotShowBuyImg = true;
      } else if(RecordingType.favoritesLog == widget.type){
        int uid = GlobalStore.getMe()?.uid ?? 0;
        louFengModel = await netManager.client
            .getCollectList(pageNumber, pageSize, uid, 'loufeng');
      }else if(RecordingType.reserveLog == widget.type){
        int uid = GlobalStore.getMe()?.uid ?? 0;
        louFengModel = await netManager.client.getReserveList(pageNumber, pageSize);
      }
      if ((louFengModel.list.length ?? 0) == 0 && pageNumber == 1) {
        baseRequestController.requestDataEmpty();
      } else {
        baseRequestController.requestSuccess();
      }
      if (pageNumber == 1) {
        refreshController.refreshCompleted(resetFooterState: true);
      }
      if (!louFengModel.hasNext) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }

      setState(() {
        if (pageNumber == 1) {
          louFengList = louFengModel.list ?? [];
        } else {
          louFengList.addAll(louFengModel.list ?? []);
        }
      });
    } catch (e) {
      if (pageNumber == 1) {
        baseRequestController.requestFail();
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }

      l.e('getBuyList=', e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
      margin: EdgeInsets.only(top: Dimens.pt16),
      child: BaseRequestView(
        retryOnTap: () {
          pageNumber = 1;
          _getData();
        },
        controller: baseRequestController,
        child: pullYsRefresh(
          refreshController: refreshController,
          onLoading: () {
            pageNumber++;
            _getData();
          },
          onRefresh: () {
            pageNumber = 1;
            _getData();
          },
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return itemBuilderView(
                louFengList[index],
                click: () async {
                  LouFengItem louFengItem = await JRouter().go(
                      YUE_PAO_DETAILS_PAGE,
                      arguments: {'id': louFengList[index].id});
                  if (louFengItem != null) {
                    setState(() {
                      louFengList.map(
                        (item) {
                          if (item.id == louFengItem.id) {
                            return louFengItem;
                          }
                          return item;
                        },
                      );
                    });
                  }
                },
                isMustNotShowBuyImg: isMustNotShowBuyImg,
              );
            },
            itemCount: louFengList.length,
          ),
        ),
      ),
    );
  }
}
