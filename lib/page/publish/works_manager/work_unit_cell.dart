import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/utils/asset_util.dart';

class WorkUnitCell extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final String imageUrl;
  final String title;
  final String descText;
  final TextStyle textStyle;
  final bool isChecked;

  const WorkUnitCell({
    Key key,
    this.imageWidth,
    this.imageHeight,
    this.imageUrl,
    this.title,
    this.descText,
    this.textStyle,
    this.isChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageHeight,
      child: Row(
        children: [
          Container(
            width: imageWidth,
            height: imageHeight,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CustomNetworkImage(
                  imageUrl: imageUrl,
                  width: imageWidth,
                  height: imageHeight,
                  borderRadius: 2,
                ),
                if (isChecked == true)
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                    decoration: BoxDecoration(
                      color: Color(0xffe98a3c),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      "审核中",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle ??
                      TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
                SizedBox(height: 20),
                Text(
                  descText,
                  style: TextStyle(
                    color: Color(0xffbababa),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkUnitDetailHeaderView extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final WorkUnitModel model;

  const WorkUnitDetailHeaderView({
    Key key,
    this.imageWidth,
    this.imageHeight,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageHeight,
      child: Row(
        children: [
          CustomNetworkImage(
            imageUrl: model.coverImg,
            width: imageWidth,
            height: imageHeight,
            placeholder: assetsImg(
              AssetsImages.IC_DEFAULT_IMG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image(
                      image: AssetImage("assets/images/unit_book.png"),
                      width: 18,
                      height: 18),
                  SizedBox(width: 4),
                  Text(
                    model.collectionName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                model.name?.isNotEmpty == true ? "@${model.name ?? ""}" : "",
                style: TextStyle(
                  color: Color(0xffbababa),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "视频数量：${model.totalCount ?? 0}部",
                style: TextStyle(
                  color: Color(0xffbababa),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
