import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/route_manager.dart' as Gets;

import 'MyVIdeoCollectDetailPage.dart';

class MyVideoCollectListPage extends StatefulWidget {

  Function(String) callback;
  bool isEdit;
  bool loading = true;
  MineWorkUnit responseData;


  MyVideoCollectListPage();

  @override
  State<MyVideoCollectListPage> createState() => _MyVideoCollectListPageState();
}

class _MyVideoCollectListPageState extends State<MyVideoCollectListPage> {

  RefreshController refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    bus.on(EventBusUtils.startEditLikeCollectList, (arg) {
      if(mounted){
        widget.isEdit = !(widget.isEdit??false);
        setState(() {});
      }
    });
    widget.loading = true;
    _loadData();
  }

  _loadData() async {
    widget.responseData = await netManager.client.getWorkUnitList(1, 100, GlobalStore.getMe().uid,1);
    refreshController.refreshCompleted();
    widget.loading = false;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  widget.loading?Container(
        child: LoadingWidget(title: "加载中..."),
      ):pullYsRefresh(
        onRefresh: _loadData,
        refreshController: refreshController,
        child: Stack(
          children: [
            Container(
                width: screen.screenWidth,
                height: screen.screenHeight-140,
                color: Colors.transparent,
                alignment: Alignment.center,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(21, 21, 21, 1),
                              Color.fromRGBO(21, 21, 21, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                        ),
                      ),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: (widget.responseData==null || widget.responseData.list==null)?0:widget.responseData.list.length,
                            itemBuilder: (context, index) {
                              WorkUnitModel workUnitModel =  widget.responseData.list[index];
                              return Container(
                                child: _buildItemCell(workUnitModel),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
            widget.isEdit??false?Positioned(child: Row(
              children: [
                SizedBox(width: 16,),
                Expanded(child: GestureDetector(
                  onTap: () async {
                    List<String> vIds = [];
                    for(var model in widget.responseData.list){
                      if(model.isSelect??false){
                        vIds.add(model.id);
                      }
                    }
                    if(vIds.length==0){
                      showToast(msg: "请选择话题");
                      return;
                    }
                    if(vIds.length>1){
                      showToast(msg: "一次只能删除一个话题");
                      return;
                    }
                    try {
                      await netManager.client.collectionDel(vIds[0]);
                      showToast(msg: "操作成功！");
                      _loadData();
                    } catch (e) {
                      showToast(msg: "操作失败！");
                    }
                  },
                  child: Container(
                    height: 44,
                    alignment: Alignment.center,
                    child: Text("删除",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(254, 127, 15, 1),
                              Color.fromRGBO(234, 139, 37, 1),
                            ]
                        )
                    ),
                  ),
                ),),
                SizedBox(width: 16,),
              ],
            ),left: 0,right: 0,bottom: 10,):SizedBox()
          ],
        ),

      )
    );
  }
  _buildItemCell(WorkUnitModel workUnitModel){
    return GestureDetector(
      child:  Container(
        height: 118,
        alignment: Alignment.centerLeft,
        color: Color.fromRGBO(34, 34, 34, 0.5),
        margin: EdgeInsets.only(top: 10),
        child:Stack(
          children: [
            Row(
              children: [
                SizedBox(width: 16,),
                CustomNetworkImage(
                  imageUrl: workUnitModel.coverImg??"",
                  fit: BoxFit.cover,
                  height: 98,
                  width: 186,
                ),
                SizedBox(width: 7,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 3,),
                        Text("${workUnitModel.collectionName}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14,),maxLines: 1,),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text("影片部数:${workUnitModel.totalCount}部",style: TextStyle(color: Color(0xffaba9a9),fontSize: 13),)
                  ],
                ),
              ],
            ),
            widget.isEdit??false?Positioned(
                right: 10,bottom: 10,
                child: GestureDetector(
                    onTap: () {
                      workUnitModel.isSelect = !(workUnitModel.isSelect??false);
                      setState(() {

                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: workUnitModel.isSelect??false?Image.asset("assets/images/unit_selected.png",width: 20,height: 20,):Image.asset("assets/images/unit_unselected.png",width: 20,height: 20,),
                    )
                ),
            ):SizedBox()
          ],
        )

      ),
      onTap: (){
        Gets.Get.to(() =>MyVIdeoCollectDetailPage(workUnitModel.id));
      },
    );
  }

}


