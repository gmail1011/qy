import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/full_bg.dart';

///群相关
class MineGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineGroupPageState();
  }
}

class _MineGroupPageState extends State<MineGroupPage> {
  BaseRequestController requestController = BaseRequestController();
  List<OfficeItemData> dataList1 = [];
  List<OfficeItemData> dataList2 = [];

  @override
  void initState() {
    super.initState();
    _getAppData();
  }

  void _getAppData() async {
    try {
      List<OfficeItemData> list = await netManager.client.getOfficeList(2);

      if ((list ?? []).isNotEmpty) {
        dataList1 = list
            .where((element) => element.officialName.contains("群"))
            .toList();
        dataList2 = list
            .where((element) => element.officialName.contains("商务"))
            .toList();
        requestController?.requestSuccess();
      } else {
        requestController?.requestDataEmpty();
      }
      setState(() {});
    } catch (e) {
      requestController?.requestFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: "加群开车"),
        body: BaseRequestView(
          controller: requestController,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildTitle("官方用户交流社群", "一起看片一起分享心得"),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: const Color.fromRGBO(22, 21, 42, 1)),
                child: Column(
                  children: dataList1
                      .map((e) => _buildContent(
                              e.officialName, e.officialDesc, e.officialImg,
                              () {
                            launchUrl(e?.officialUrl);
                          }))
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              _buildTitle("商务合作", "代理合作/商务合作"),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: const Color.fromRGBO(22, 21, 42, 1)),
                child: Column(
                  children: dataList2
                      .map((e) => _buildContent(
                              e.officialName, e.officialDesc, e.officialImg,
                              () {
                            launchUrl(e?.officialUrl);
                          }))
                      .toList(),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, String desc) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
                fontSize: 20.0),
          ),
          SizedBox(height: 10),
          Text(
            "一起看片一起分享心得",
            style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
                color: Color.fromRGBO(102, 102, 102, 1)),
          )
        ],
      ),
    );
  }

  Widget _buildContent(
      String title, String desc, String imgUrl, Function callClick) {
    return Container(
        height: 100,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CustomNetworkImage(
                    imageUrl: imgUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.fill,
                    borderRadius: 32,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0),
                    ),
                    SizedBox(height: 5),
                    Text(
                      desc,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                          color: Color(0xffacbabf)),
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: callClick,
              child: Container(
                width: 116,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    gradient: LinearGradient(colors: [
                      const Color.fromRGBO(100, 255, 239, 1),
                      const Color.fromRGBO(0, 214, 190, 1)
                    ])),
                child: Center(
                  child: Text(
                    "立即加入",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
