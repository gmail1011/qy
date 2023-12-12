import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'input_single_btn_view.dart';

class MyVideoCollectListDialogView extends StatefulWidget {

  final Function(String) callback;

  MineWorkUnit responseData;

  MyVideoCollectListDialogView(this.callback);

  @override
  State<MyVideoCollectListDialogView> createState() => _MyVideoCollectListDialogViewState();
}

class _MyVideoCollectListDialogViewState extends State<MyVideoCollectListDialogView> {

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    widget.responseData = await netManager.client.getWorkUnitList(1, 100, GlobalStore.getMe().uid,1);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:GestureDetector(
        child:Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          color: Colors.transparent,
          alignment: Alignment.center,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 235, 217, 1),
                          Color.fromRGBO(255, 255, 255, 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                    ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 16,),
                      Text("添加到播放列表"),
                      SizedBox(height: 13,),
                      Container(
                        height:1 ,
                        color: Color.fromRGBO(229, 222, 211, 1),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: (widget.responseData.list==null ||widget.responseData == null)?0:widget.responseData.list.length,
                        itemBuilder: (context, index) {
                          WorkUnitModel workUnitModel =  widget.responseData.list[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: _buildItemCell(workUnitModel),
                          );
                        },
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        child:Row(
                          children: [
                            SizedBox(width: 16,),
                            Image.asset("assets/images/icon_add_collect.png",width: 17,height: 17,),
                            SizedBox(width: 10,),
                            Text("新建收藏列表",style: TextStyle(color: Color.fromRGBO(254, 127, 15, 1)),)
                          ],
                        ),
                        onTap: (){
                          if(!(GlobalStore.isVIP() && GlobalStore.getWallet().consumption>0)){
                            showToast(msg: "您还不是VIP 无法创建播放列表");
                            return;
                          }
                          safePopPage();
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return InputSingleBtnDialogView(
                                  title:"新建列表",
                                  btnText:"创建",
                                  callback: (text) async {
                                    try {
                                      await netManager.client.postWorkUnitAdd(text, "", "", 1000,1);
                                      showToast(msg: "合集创建成功");
                                    } on DioError catch (e) {
                                      showToast(msg: "合集创建失败");
                                    }
                                  },
                                );
                              });
                        },
                      ),
                      SizedBox(height: 40,),
                    ],
                  ),
                )
              ],
            )
        ),
        onTap: (){
          safePopPage(false);
        },
      ),

    );
  }
  _buildItemCell(WorkUnitModel workUnitModel){
    return GestureDetector(
      child:  Container(
        height: 41,
        width: screen.screenWidth,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(width: 16,),
            Image.asset("assets/images/icon_collect_folder.png",width: 18,height: 18,),
            SizedBox(width: 7,),
            Expanded(child: Text("${workUnitModel.collectionName}",style: TextStyle(color: Color.fromRGBO(21, 21, 21, 1),fontSize: 18),))
          ],
        ),
      ),
      onTap: (){
        safePopPage(false);
        widget.callback(workUnitModel.id);
      },
    );
  }

}


