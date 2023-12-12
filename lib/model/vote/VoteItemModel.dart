import 'Options.dart';

class VoteItemModel {
  VoteItemModel({
      this.id, 
      this.title, 
      this.isMulCheck, 
      this.beginTime, 
      this.endTime, 
      this.voteCount, 
      this.showResult, 
      this.weight, 
      this.hasVoted, 
      this.options,});

  VoteItemModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isMulCheck = json['isMulCheck'];
    beginTime = json['beginTime'];
    endTime = json['endTime'];
    voteCount = json['voteCount'];
    showResult = json['showResult'];
    weight = json['weight'];
    hasVoted = json['hasVoted'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options.add(Options.fromJson(v));
      });
    }
  }
  String id;
  String title;
  bool isMulCheck;
  String beginTime;
  String endTime;
  int voteCount;
  bool showResult;
  int weight;
  bool hasVoted;
  List<Options> options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['isMulCheck'] = isMulCheck;
    map['beginTime'] = beginTime;
    map['endTime'] = endTime;
    map['voteCount'] = voteCount;
    map['showResult'] = showResult;
    map['weight'] = weight;
    map['hasVoted'] = hasVoted;
    if (options != null) {
      map['options'] = options.map((v) => v.toJson()).toList();
    }
    return map;
  }

}