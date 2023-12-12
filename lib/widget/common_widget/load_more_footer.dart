import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class LoadMoreFooter extends Footer {
  bool hasNext;
  bool isFollow;
  bool isComment;

  LoadMoreFooter(
      {this.hasNext = true, this.isFollow = false, this.isComment = false});

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return hasNext ?? false ? LoadingWidget() : Container();
  }
}
