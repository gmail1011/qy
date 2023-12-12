import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/publish/works_manager/work_create_unit_page.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_cell.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_detail_page.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkVideoUnitPage extends StatefulWidget {
  final bool isShowAppbar;
  final UserInfoModel userInfo;

  const WorkVideoUnitPage({
    Key key,
    this.isShowAppbar,
    this.userInfo,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkVideoUnitPageState();
  }
}

class _WorkVideoUnitPageState extends State<WorkVideoUnitPage> {
  int currentPage = 1;
  RefreshController refreshController = RefreshController();
  MineWorkUnit workUnitModel;

  bool get isMe {
    if (widget.userInfo == null) return true;
    return GlobalStore.isMe(widget.userInfo?.uid);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadUnitData();
    });
  }

  void _loadUnitData({int page = 1, int size = 10}) async {
    try {
      MineWorkUnit responseData = await netManager.client.getWorkUnitList(
          page, size, widget.userInfo?.uid ?? GlobalStore.getMe().uid,0);
      currentPage = page;
      if (page == 1) {
        workUnitModel = responseData;
      } else {
        workUnitModel.list?.addAll(responseData.list ?? []);
      }
      if ((responseData.list?.length ?? 0) < size) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } catch (e) {
      refreshController.loadNoData();
      workUnitModel ??= MineWorkUnit();
      debugLog(e);
    }
    refreshController.refreshCompleted();

    setState(() {});
  }

  void _loadMoreData() {
    _loadUnitData(page: currentPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isShowAppbar == true) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => safePopPage(),
          ),
          title: Text(
            "合集列表",
            style: TextStyle(
              fontSize: AppFontSize.fontSize18,
            ),
          ),
        ),
        body: _buildContent(),
      );
    } else {
      return _buildContent();
    }
  }

  Widget _buildContent() {
    if (workUnitModel == null) {
      return LoadingWidget();
    } else {
      return Stack(
        children: [
          SmartRefresher(
            onRefresh: _loadUnitData,
            onLoading: _loadMoreData,
            enablePullUp: (workUnitModel.list?.isNotEmpty == true),
            controller: refreshController,
            child: ListView.builder(
              itemCount: workUnitModel.list?.length ?? 0,
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              itemBuilder: (context, index) {
                var model = workUnitModel.list[index];
                return Container(
                  padding: EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    onTap: () async {
                      var result = await Gets.Get.to(
                          () => WorkUnitDetailPage(
                                model: model,
                                userInfo: widget.userInfo,
                              ),
                          opaque: false);
                      if (result == true) {
                        setState(() {});
                        //refreshController.requestRefresh();
                      }
                    },
                    child: WorkUnitCell(
                      imageWidth: 152 * 0.85,
                      imageHeight: 85 * 0.85,
                      imageUrl: model.coverImg,
                      title: model.collectionName,
                      descText: "视频数量：${model.totalCount ?? 0}部",
                    ),
                  ),
                );
              },
            ),
          ),
          if (workUnitModel.list?.isNotEmpty == true)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: _buildAddUnitButton(),
            )
          else
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: _buildAddUnitButton(),
            ),
        ],
      );
    }
  }

  Widget _buildAddUnitButton() {
    if (isMe == false) return SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            if (!GlobalStore.isVIP()) {
              VipRankAlert.show(
                context,
                type: VipAlertType.createUnit,
              );
              return;
            }
            var result =
            await Gets.Get.to(() => WorkCreateUnitPage(), opaque: false);
            if (result == true) {
              showToast(msg: "合集创建成功");
              refreshController.requestRefresh();
            }
          },
          child: Container(
            height: 42,
            width: 272,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffdd903f),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Text(
              "新建合集",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
