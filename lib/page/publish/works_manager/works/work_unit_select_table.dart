import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/publish/works_manager/work_create_unit_page.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_cell.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkUnitSelectTable extends StatefulWidget {
  final Function cancelCallback;
  final List<VideoModel> videoList;
  const WorkUnitSelectTable({Key key, this.videoList,this.cancelCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkUnitSelectTableState();
  }
}

class _WorkUnitSelectTableState extends State<WorkUnitSelectTable> {
  int currentPage = 1;
  RefreshController refreshController = RefreshController();
  MineWorkUnit workUnitModel;
  List<int> selectIndexArr = [];
  int selectedIndex = -1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadUnitData();
    });
  }

  void _loadUnitData({int page = 1, int size = 100}) async {
    try {
      MineWorkUnit responseData = await netManager.client
          .getWorkUnitList(page, size, GlobalStore.getMe().uid,0);
      currentPage = page;
      if (page == 1) {
        workUnitModel = responseData;
      } else {
        workUnitModel.list?.addAll(responseData.list ?? []);
        if ((responseData.list?.length ?? 0) < size) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      }
    } catch (e) {
      refreshController.loadNoData();
      debugLog(e);
    }
    workUnitModel ??= MineWorkUnit();
    refreshController.refreshCompleted();

    setState(() {});
  }

  void _loadMoreData() {
    _loadUnitData(page: currentPage + 1);
  }

  void _loadAddToUnit() async{
    if(selectedIndex < 0){
      showToast(msg: "请选择合集");
      return;
    }
    try {
      var cid = workUnitModel.list[selectedIndex].id;
      List<String> vIds = [];
      for(var model in widget.videoList){
        vIds.add(model.id);
      }
      WBLoadingDialog.show(context);
      await netManager.client.postWorkUnitVideoAdd(cid, vIds);
      Navigator.of(context).pop();
      showToast(msg: "添加成功");
    }catch(e){
      showToast(msg: "添加失败");
    }
    WBLoadingDialog.dismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: widget.cancelCallback,
                child: Container(),
              ),
            ),
            Container(
              height: 488,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 235, 217, 1),
                    Color.fromRGBO(255, 251, 247, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 56,
                    alignment: Alignment.center,
                    child: Text(
                      "合集列表",
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Color(0xffe4ded4),
                  ),
                  Expanded(child: _buildListView()),
                  Container(
                    height: 80,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          color: Color(0xffe0e0e0),
                        ),
                        SizedBox(height: 12),
                        _buildAddUnitButton(),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    if (workUnitModel == null) {
      return LoadingWidget();
    } else if ( workUnitModel.list?.isNotEmpty != true) {
      return CErrorWidget("暂无数据");
    } else {
      return SmartRefresher(
        onRefresh: _loadUnitData,
        onLoading: _loadMoreData,
        controller: refreshController,
        child: ListView.builder(
          itemCount: workUnitModel?.list?.length ?? 0,
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          itemBuilder: (context, index) {
            var model = workUnitModel.list[index];
            return Container(
              padding: EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () async {
                  selectedIndex = index;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Expanded(
                      child: WorkUnitCell(
                        imageWidth: 150* 0.85,
                        imageHeight: 85 * 0.85,
                        imageUrl: model?.coverImg ?? "",
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xff333333),
                        ),
                        title: model?.collectionName ?? "",
                        descText: "视频数量：${model?.totalCount ?? 0}部",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Image.asset(
                          selectedIndex == index
                            ? "assets/images/unit_selected.png"
                            : "assets/images/unit_unselected.png",
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildAddUnitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: InkWell(
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
              width: 146,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                border: Border.all(color: Color(0xff666666), width: 1),
              ),
              child: Text(
                "新建合集",
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 18),
        Container(
          child: InkWell(
            onTap: _loadAddToUnit,
            child: Container(
              width: 146,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffdd903f),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Text(
                "添加合集",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
