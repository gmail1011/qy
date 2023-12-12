import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/model/new_video_model_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:uuid/uuid.dart';

import 'post_item_widget.dart';

class PostItemState implements Cloneable<PostItemState> {
  ///uniqueId
  String uniqueId;
  VideoModel videoModel;
  List<VideoModel> newVideoModel;
  PostFrom postFrom;
  String type;

  PostItemState(
      {this.videoModel, this.postFrom, this.type, this.newVideoModel}) {
    uniqueId ??= Uuid().v1();
  }

  ///头像是否可以点击 默认可以点击
  bool isHeadTapEnabled = true;

  ///是否显示关注按钮 默认显示
  bool isShowFollowBtn = true;

  ///是否默认显示下拉菜单的取消关注按钮 默认不显示
  bool isShowPopoverUnFollowBtn = false;

  ///帖子内容默认最大显示字数
  int maxLength = 36;

  /// 是否显示全文按钮
  bool isShowFullButton = false;
  bool isDidFullButton = false;

  ///全文点击手势
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

  ///是否显示弹出菜单
  bool isShowMenuList = false;

  @override
  PostItemState clone() {
    return PostItemState()
      ..uniqueId = uniqueId
      ..videoModel = videoModel
      ..isShowFullButton = isShowFullButton
      ..isDidFullButton = isDidFullButton
      ..isShowFollowBtn = isShowFollowBtn
      ..postFrom = postFrom
      ..isShowMenuList = false
      ..tapGestureRecognizer = tapGestureRecognizer
      ..maxLength = maxLength
      ..type = type
      ..newVideoModel = newVideoModel;
  }
}

PostItemState initState(Map<String, dynamic> args) {
  return PostItemState();
}
