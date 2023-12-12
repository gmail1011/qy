

import 'package:flutter_app/model/video_model.dart';

import '../comment_model.dart';


class MyMsgResponse{
  List<MyMsgModel> list;
  bool hasNext;
  MyMsgResponse();
  MyMsgResponse.fromJson(Map<String, dynamic> json) {
    json ??= {};
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list =  [];
      json['list'].forEach((v) {
        list?.add(MyMsgModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['hasNext'] = hasNext;
    if (list != null) {
      data['list'] = list?.map((v) => v.toJson())?.toList();
    }
    return data;
  }
}

class MyMsgModel{


  String desc;

  CommentModel detail;
  VideoModel videoInfo;
  bool hasFollowed;
  String typeSender;
  int coins;


  MyMsgModel();
  int sendUid;
  String sendName;
  String createdAt;

  String id;
  String msgType;
  String content;
  List imgUrl;
  String sendAvatar;
  bool isRead;
  String objId;
  String objName;
  String vipExpireDate;
  int vipLevel;
  MyMsgModel.fromJson(Map<String, dynamic> json) {
    json ??= {};
    id = json['id'];
    msgType = json['msgType'];
    content = json['content'];
    imgUrl = json['imgUrl'];
    sendAvatar = json['sendAvatar'];
    isRead = json['isRead'];
    objId = json['objId'];
    objName = json['objName'];
    vipExpireDate = json['vipExpireDate'];
    vipLevel = json['vipLevel'];



    sendUid = json['sendUid'];
    sendName = json['sendName'];
    sendAvatar = json['senderPortrait'];
    desc = json['desc'];
    createdAt = json['createdAt'];
    hasFollowed = json['hasFollowed'];
    coins = json['coins'];
    detail = CommentModel.fromJson(json['detail']);
    videoInfo = VideoModel.fromJson(json['videoInfo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sendUid'] = sendUid;
    data['sendName'] = sendName;
    data['desc'] = desc;
    data['createdAt'] = createdAt;
    data['hasFollowed'] = hasFollowed;
    data['detail'] = detail?.toJson();
    data['videoInfo'] = videoInfo?.toJson();
    return data;
  }

}