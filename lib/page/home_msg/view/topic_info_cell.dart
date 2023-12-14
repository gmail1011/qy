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
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/time_helper.dart';

class TopicInfoCell extends StatefulWidget {
  final VideoModel videoModel;


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

  VideoModel get realModel {
    VideoModel realModel;
    if (widget.videoModel != null) {
      realModel = widget.videoModel;
    }
    realModel ??= VideoModel();
    return realModel;
  }

  String get tagDesc {
    String tagText = "";
    for (int i = 0; i < (realModel.tags.length ?? 0) && i < 3; i++) {
      if (i == 0) {
        tagText = realModel.tags[i].name;
      } else {
        tagText += "、" + realModel.tags[i].name;
      }
    }
    return tagText;
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight =  90;
    double imageWidth =  160;
    return Container(
      color: Colors.white.withOpacity(0.8),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(
            width: imageWidth,
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
                          imageUrl: realModel.cover ?? "",
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
                        realModel?.title ?? "-----",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff333333),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        "@${realModel.publisher?.name}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Color(0xff666666), fontSize: 12),
                      ),
                      Row(
                        children: [
                          _buildCountItem(realModel.playCountDescFive, "assets/images/"),
                          SizedBox(width: 18),
                          _buildCountItem(realModel.commentCountDesc, "assets/images/"),
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
            color: AppColors.primaryTextColor.withOpacity(0.2),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "----------",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0xff333333), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomData(VideoModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.6),
      ),
      child: Text(
        TimeHelper.getTimeText(model?.playTime?.toDouble() ?? 0),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
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
