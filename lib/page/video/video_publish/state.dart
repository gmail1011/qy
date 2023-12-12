import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/publish_tag_model.dart';
import 'package:flutter_app/model/search/PostModuleModel.dart';
import 'package:flutter_app/page/video/video_publish/select_tags/SelecteTagsPage.dart';
import 'package:flutter_app/page/video/video_publish/select_tags/select_tags_view.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

enum UploadType { UPLOAD_IMG, UPLOAD_VIDEO }

class VideoAndPicturePublishState extends GlobalBaseState
    with EagleHelper
    implements Cloneable<VideoAndPicturePublishState> {

  TextEditingController textTitleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  List<PublishTag> tagList = [];

  FocusNode focusNode = FocusNode();

  UploadType uploadType = UploadType.UPLOAD_VIDEO;

  UploadVideoModel uploadModel = UploadVideoModel();

  bool isMoreTag = false;

  bool isSelectedCover = false;

  TextEditingController textEditingController = new TextEditingController();

  TextEditingController textMoneyController = new TextEditingController();

  PostModuleModel postModuleModel;

  int coin;

  int selectedImags;
  String taskID;
  bool isFromCenter;           // 创作中心跳转过来的
  String locationCity;

  bool isSelectedCity = false;

  ScrollController scrollController = new ScrollController();

  String videoCover;

  int pageType;  //0图片 1视频 2图文

  @override
  VideoAndPicturePublishState clone() {
    return VideoAndPicturePublishState()
      ..uploadType = uploadType
      ..textController = textController
      ..tagList = tagList
      ..isMoreTag = isMoreTag
      ..focusNode = focusNode
      ..isSelectedCover = isSelectedCover
      ..textEditingController = textEditingController
      ..textTitleController = textTitleController
      ..textMoneyController = textMoneyController
      ..postModuleModel = postModuleModel
      ..coin = coin
      ..selectedImags = selectedImags
      ..uploadModel = uploadModel
      ..locationCity = locationCity
      ..scrollController = scrollController
      ..isSelectedCity = isSelectedCity
      ..taskID = taskID
      ..pageType = pageType
      ..videoCover = videoCover
      ..isFromCenter = isFromCenter;
  }
}

VideoAndPicturePublishState initState(Map<String, dynamic> args) {
  return VideoAndPicturePublishState()
    ..uploadType = (null != args && args.containsKey('type'))
        ? args['type']
        : UploadType.UPLOAD_VIDEO
    ..taskID = args["taskID"]
    ..pageType = (null != args && args.containsKey('pageType'))
        ? args['pageType']
        : 0
    ..isFromCenter = args['isFromCenter'];
}
