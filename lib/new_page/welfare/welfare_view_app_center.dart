import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class WelfareViewAppCenter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelfareViewAppCenterState();
  }
}

class _WelfareViewAppCenterState extends State<WelfareViewAppCenter> with AutomaticKeepAliveClientMixin {
  BaseRequestController requestController = BaseRequestController();
  List<OfficeItemData> dataList1 = [];
  List<OfficeItemData> dataList2 = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getAppData();
  }

  void _getAppData() async {
    try {
      List<OfficeItemData> list = await netManager.client.getOfficeList(1);

      if ((list ?? []).isNotEmpty) {
        dataList1 = list.where((element) => element.position == 1).toList();
        dataList2 = list.where((element) => element.position == 2).toList();
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
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: BaseRequestView(
        controller: requestController,
        retryOnTap: _getAppData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "装机必备",
                style: const TextStyle(
                    color: const Color(0xfffaedca), fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
              SizedBox(height: 10),
              GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 77 / 100),
                  itemCount: dataList1.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildVItem(dataList1[index]);
                  }),
              SizedBox(height: 30),
              Text(
                "华人国产",
                style: const TextStyle(
                    color: const Color(0xfffaedca), fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
              SizedBox(height: 10),
              GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 120 / 60),
                  itemCount: dataList2.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildHItem(dataList2[index]);
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVItem(OfficeItemData item) {
    return InkWell(
      onTap: () => launchUrl(item.officialUrl),
      child: Container(
        height: 100,
        child: Column(
          children: [
            ClipRect(
              child: CustomNetworkImage(
                imageUrl: item.officialImg,
                borderRadius: 13,
                width: 77,
                height: 77,
              ),
            ),
            SizedBox(height: 5),
            Text("${item.officialName}",
                style: const TextStyle(
                    color: const Color(0xffdddfdf), fontWeight: FontWeight.w300, fontSize: 12.0),
                textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }

  Widget _buildHItem(OfficeItemData item) {
    return InkWell(
      onTap: () => launchUrl(item.officialUrl),
      child: Container(
        height: 60,
        child: Row(
          children: [
            ClipOval(
              child: CustomNetworkImage(
                imageUrl: item.officialImg,
                borderRadius: 30,
                width: 60,
                height: 60,
              ),
            ),
            SizedBox(width: 10),
            Text("${item.officialName}",
                style: const TextStyle(
                    color: const Color(0xffdddfdf), fontWeight: FontWeight.w300, fontSize: 12.0),
                textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
