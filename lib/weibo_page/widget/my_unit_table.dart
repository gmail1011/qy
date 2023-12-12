import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/publish/works_manager/work_unit_detail_page.dart';
import 'package:flutter_app/page/publish/works_manager/work_video_unit_page.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;

class MyUnitTable extends StatefulWidget {
  final UserInfoModel userInfo;

  const MyUnitTable({Key key, this.userInfo}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyUnitTableState();
  }
}

class _MyUnitTableState extends State<MyUnitTable> {
  MineWorkUnit workUnitModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadUnitData();
    });
  }

  void _loadUnitData({int page = 1, int size = 10}) async {
    try {
      MineWorkUnit responseData = await netManager.client
          .getWorkUnitList(page, size, widget.userInfo?.uid,0);
      if (page == 1) {
        workUnitModel = responseData;
      } else {}
    } catch (e) {
      debugLog(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (workUnitModel?.list?.isNotEmpty == true) {
      return Container(
        padding: EdgeInsets.only(top: 16),
        child: Container(
          height: 36,
          width: screen.screenWidth,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: workUnitModel.list.length + 1,
            itemBuilder: (context, index) {
              if (index == workUnitModel.list.length) {
                return InkWell(
                  onTap: () {
                    Gets.Get.to(
                      () => WorkVideoUnitPage(isShowAppbar: true ,userInfo: widget.userInfo,),
                      opaque: false,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 1),
                      Text(
                        "全部",
                        style: TextStyle(
                          color: Color(0xffcccccc),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Color(0xffcccccc),
                        size: 12,
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                );
              } else {
                var model = workUnitModel.list[index];
                return InkWell(
                  onTap: () {
                    Gets.Get.to(
                      () => WorkUnitDetailPage(model: model, userInfo: widget.userInfo,),
                      opaque: false,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 6),
                    child: _buildItemWidget(model.collectionName ?? ""),
                  ),
                );
              }
            },
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildItemWidget(String title) {
    return Container(
      padding: EdgeInsets.only(left: 6, right: 4),
      decoration: BoxDecoration(
        color: Color(0xff1e1e1e),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/unit_book.png",
            width: 14,
          ),
          SizedBox(width: 2),
          Text(
            title,
            style: TextStyle(
              color: Color(0xffcccccc),
              fontSize: 12,
            ),
          ),
          SizedBox(width: 2),
          Icon(
            Icons.keyboard_arrow_right,
            color: Color(0xffcccccc),
            size: 12,
          ),
        ],
      ),
    );
  }
}
