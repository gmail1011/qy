import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'activity_entity.dart';

class ActivityDetailPage extends StatefulWidget {
  final ActivityDataList activityDataList;

  ActivityDetailPage(this.activityDataList);

  @override
  State<StatefulWidget> createState() {
    return ActivityDetailPageState();
  }
}

class ActivityDetailPageState extends State<ActivityDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar(widget.activityDataList?.title ?? ""),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 25.w, left: 16.w, right: 16.w),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CustomNetworkImage(
                  imageUrl: widget.activityDataList.cover,
                  width: screen.screenWidth,
                  height: 208.w,
                ),
              ),
              SizedBox(
                height: 15.w,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 2.w, right: 2.w),
                child: Text(
                  widget.activityDataList?.content ?? "",
                  textAlign: TextAlign.start,
                  style:
                      TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
