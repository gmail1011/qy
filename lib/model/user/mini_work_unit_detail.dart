import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/model/new_video_model_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'mine_work_unit.dart';

class MineWorkUnitDetail {
  bool hasNext = false;
  WorkUnitModel collection;
  List<VideoModel> list;
  int total = 0;
  static MineWorkUnitDetail fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    MineWorkUnitDetail mineVideoBean = MineWorkUnitDetail();
    mineVideoBean.hasNext = map['hasNext'] ?? false;
    mineVideoBean.total = map['total'] ?? 0;
    mineVideoBean.list = [];
    if(map['list'] is List){
      List arr = map['list'];
      for(int i = 0; i < arr.length; i++){
        var map = arr[i];
        if(map["detail"] != null) {// 推广列表数据
          var videoModel = VideoModel.fromJson(map["detail"]);
          videoModel?.promotionDays = map["promotionDays"] ?? 0;
          videoModel?.superId = map["id"];
          videoModel?.status = map['status'];
          videoModel?.reason = map['reason'];
          mineVideoBean.list.add(videoModel);
        }else {
          var videoModel = VideoModel.fromJson(map);
          mineVideoBean.list.add(videoModel);
          if(map["promotionDays"] != null) { // 推广列表数据
            videoModel.superId = map["id"];
            videoModel.title = map["vidTitle"];
            videoModel.publisher = PublisherBean();
            videoModel.publisher.uid = map["publisherID"];
            videoModel.publisher.name = map["name"];
            videoModel.publisher.portrait = map["portrait"];
            videoModel.id = map["vidId"];
            videoModel.newsType = map["vidType"];
            videoModel.status = map["status"];
            videoModel.type = map["type"];
            videoModel?.promotionDays = map["promotionDays"] ?? 0;
            videoModel.sourceURL = map["sourceURL"];
            videoModel.cover = map["cover"];
            videoModel.reason = map["reason"];
            videoModel.createdAt = map["createdAt"];
          }
        }
      }
    }
    mineVideoBean.collection = WorkUnitModel.fromJson(map['collection']);
    return mineVideoBean;
  }

}
