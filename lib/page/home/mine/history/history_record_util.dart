import 'dart:convert';

import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/model/nove_details_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';


class HistoryRecordUtil {
  static const String historyVideoKey = 'historyVideoKey';
  static const String historyNovelKey = 'historyNovelKey';
  static const String historyNovelTextKey = 'historyNovelTextKey';
  static const String historyPostKey = 'historyPostKey';
  static const int maxLength = 50;

  // type 0 视频，1 帖子
  static insertVideoModel(VideoModel videoModel, {int type = 0}) async {
    if (videoModel.newsType.startsWith("AD") == true) return;
    if (videoModel == null) return;
    try {
      String localKey = historyVideoKey;
      if(type == 1){
        localKey = historyPostKey;
      }
      List<String> recordList = await lightKV.getStringList(localKey) ?? [];
      if (recordList.length > maxLength) {
        recordList.removeRange(maxLength - 1, recordList.length);
      }
      if (ArrayUtil.isNotEmpty(recordList) && TextUtil.isNotEmpty(videoModel.id)) {
        recordList.removeWhere((element) => element.contains(RegExp(videoModel.id)));
      }
      recordList.insert(0, json.encode(videoModel.toJson()));
      await lightKV.setStringList(localKey, recordList);
    } catch (e) {
      debugLog(e);
    }
  }

  static Future<List<VideoModel>> getVideoModelList({int type = 0}) async {
    List<VideoModel> result = [];
    try {
      String localKey = historyVideoKey;
      if(type == 1){
        localKey = historyPostKey;
      }
      List<String> historyList = await lightKV.getStringList(localKey);
      if (ArrayUtil.isNotEmpty(historyList)) {
        historyList.forEach((element) {
          Map<String, dynamic> map = json.decode(element);
          VideoModel videoModel = VideoModel.fromJson(map);
          result.add(videoModel);
        });
      }
    } catch (e) {
      debugLog(e);
    }
    return result;
  }


  static Future deleteVideo(VideoModel model, {int type = 0}) async {
    if(model == null) return;
    List<VideoModel> result = [];
    String localKey = historyVideoKey;
    if(type == 1){
      localKey = historyPostKey;
    }
    try {
      List<String> historyList = await lightKV.getStringList(localKey);
      if (ArrayUtil.isNotEmpty(historyList)) {
        historyList.forEach((element) {
          Map<String, dynamic> map = json.decode(element);
          VideoModel videoModel = VideoModel.fromJson(map);
          result.add(videoModel);
        });
      }
    } catch (e) {
      debugLog(e);
    }
    for(var item in result){
      if(item.id == model.id){
        result.remove(item);
        break;
      }
    }
    List<String> retArr = result.map((e) => jsonEncode(e.toJson())).toList();
    await lightKV.setStringList(localKey, retArr);
  }


  static insertAudioBook(AudioBook audioBook) async {
    if (audioBook == null) return;
    try {
      List<String> recordList = await lightKV.getStringList(historyNovelKey) ?? [];
      if (recordList.length > maxLength) {
        recordList.removeRange(maxLength - 1, recordList.length);
      }
      if (ArrayUtil.isNotEmpty(recordList) && TextUtil.isNotEmpty(audioBook.id)) {
        recordList.removeWhere((element) => element.contains(RegExp(audioBook.id)));
      }
      recordList.insert(0, json.encode(audioBook.toJson()));
      lightKV.setStringList(historyNovelKey, recordList);
    } catch (e) {
      debugLog(e);
    }
  }


  static Future<List<AudioBook>> getAudioBookList() async {
    List<AudioBook> result = [];
    try {
      List<String> historyList = await lightKV.getStringList(historyNovelKey);
      if (ArrayUtil.isNotEmpty(historyList)) {
        historyList.forEach((element) {
          Map<String, dynamic> map = json.decode(element);
          AudioBook novel = AudioBook.fromJson(map);
          result.add(novel);
        });
      }
    } catch (e) {
      debugLog(e);
    }
    return result;
  }

  static Future deleteAudioBook(AudioBook model) async {
    if(model == null) return;
    List<AudioBook> result = [];
    try {
      List<String> historyList = await lightKV.getStringList(historyNovelKey);
      if (ArrayUtil.isNotEmpty(historyList)) {
        historyList.forEach((element) {
          Map<String, dynamic> map = json.decode(element);
          AudioBook novel = AudioBook.fromJson(map);
          result.add(novel);
        });
      }
    } catch (e) {
      debugLog(e);
    }
    for(var item  in result){
      if(item.id == model.id){
        result.remove(item);
        break;
      }
    }
    List<String> retArr = result.map((e) => jsonEncode(e.toJson())).toList();
    await lightKV.setStringList(historyNovelKey, retArr);
  }

  static insertNovelTextBook(NoveDetails audioBook) async {
    if (audioBook == null) return;
    try {
      List<String> recordList = await lightKV.getStringList(historyNovelTextKey) ?? [];
      if (recordList.length > maxLength) {
        recordList.removeRange(maxLength - 1, recordList.length);
      }
      if (ArrayUtil.isNotEmpty(recordList) && TextUtil.isNotEmpty(audioBook.id)) {
        recordList.removeWhere((element) => element.contains(RegExp(audioBook.id)));
      }
      recordList.insert(0, json.encode(audioBook.toJson()));
      lightKV.setStringList(historyNovelTextKey, recordList);
    } catch (e) {
      debugLog(e);
    }
  }

  static Future<List<NoveDetails>> getNovelTextBookList() async {
    List<NoveDetails> result = [];
    try {
      List<String> historyList = await lightKV.getStringList(historyNovelTextKey);
      if (ArrayUtil.isNotEmpty(historyList)) {
        historyList.forEach((element) {
          Map<String, dynamic> map = json.decode(element);
          NoveDetails novel = NoveDetails.fromJson(map);
          result.add(novel);
        });
      }
    } catch (e) {
      debugLog(e);
    }
    return result;
  }

  static Future deleteTextBook(NoveDetails model) async {
    if(model == null) return;
    List<NoveDetails> result = [];
    try {
      List<String> historyList = await lightKV.getStringList(historyNovelTextKey);
      if (ArrayUtil.isNotEmpty(historyList)) {
        historyList.forEach((element) {
          Map<String, dynamic> map = json.decode(element);
          NoveDetails novel = NoveDetails.fromJson(map);
          result.add(novel);
        });
      }
    } catch (e) {
      debugLog(e);
    }
    for(var item  in result){
      if(item.id == model.id){
        result.remove(item);
        break;
      }
    }
    List<String> retArr = result.map((e) => jsonEncode(e.toJson())).toList();
    await lightKV.setStringList(historyNovelTextKey, retArr);
  }
}
