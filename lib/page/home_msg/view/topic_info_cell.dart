import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/activity_response.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home_msg/activity_detail_page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/time_helper.dart';

class TopicInfoCell extends StatefulWidget {
  final ActivityModel videoModel;

  TopicInfoCell({
    Key key,
    this.videoModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicInfoCellState();
  }
}

class _TopicInfoCellState extends State<TopicInfoCell> {
  @override
  void initState() {
    super.initState();
  }

  ActivityModel get realModel {
    ActivityModel realModel;
    if (widget.videoModel != null) {
      realModel = widget.videoModel;
    }
    realModel ??= ActivityModel();
    return realModel;
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = 90;
    double imageWidth = 160;
    return InkWell(
      onTap: (){
        pushToPage(ActivityDetailPage(id: realModel.id,));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(
              height: imageHeight,
              child: Row(
                children: [
                  SizedBox(
                    width: imageWidth,
                    height: imageHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          child: CustomNetworkImageNew(
                            imageUrl: realModel.img ?? "",
                            fit: BoxFit.cover,
                            width: imageHeight,
                            height: imageHeight,
                          ),
                        ),
                        Positioned(
                          bottom: 9,
                          right: 9,
                          child: _buildBottomData(realModel),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          realModel?.title ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                            height: 1.2,
                          ),
                        ),
                        Text(
                          "@${realModel.desc}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Color(0xff666666), fontSize: 12),
                        ),
                        Row(
                          children: [
                            _buildCountItem(realModel.playCountDesc, "assets/images/play_grey.png"),
                            SizedBox(width: 18),
                            _buildCountItem(realModel.commentDesc, "assets/images/comment_grey.png"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 28,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryTextColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/blue_char.png",
                    width: 14,
                    height: 14,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      realModel.commentDesc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 12,
                      ),
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

  Widget _buildBottomData(ActivityModel model) {
    return SizedBox();
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(16),
    //     color: Colors.black.withOpacity(0.6),
    //   ),
    //   child: Text(
    //     TimeHelper.getTimeText(model?.playTime?.toDouble() ?? 0),
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 10,
    //     ),
    //   ),
    // );
  }

  Widget _buildCountItem(String text, String imagePath) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 16,
          height: 16,
        ),
        SizedBox(width: 6),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xff666666),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
