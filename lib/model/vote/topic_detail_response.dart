
class TopicDetailResponse {

  String id;
  String title;
  String img;
  String desc;
  List<TopicDetailModel> list;

  TopicDetailResponse();

  TopicDetailResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    img = json['img'];
    desc = json['desc'];
    if (json['list'] is List) {
      list = [];
      json['list'].forEach((v) {
        list.add(TopicDetailModel.fromJson(v));
      });
    }
  }
}

class TopicDetailModel {

  String id;
  String title;
  bool isMulCheck;
  String desc;
  List<TopicSelectInfo> options;
  bool hasVoted;

  TopicDetailModel();

  TopicDetailModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    isMulCheck = json['isMulCheck'];
    desc = json['desc'];
    hasVoted = json['hasVoted'];
    if (json['options'] is List) {
      options = [];
      json['options'].forEach((v) {
        options.add(TopicSelectInfo.fromJson(v));
      });
    }
  }
}



class TopicSelectInfo{

  String id;
  String voteID;
  String option;
  bool showValue;
  bool hasVoted;

  TopicSelectInfo();

  TopicSelectInfo.fromJson(dynamic json) {
    id = json['id'];
    voteID = json['voteID'];
    option = json['option'];
    showValue = json['showValue'];
    hasVoted = json['hasVoted'];
  }
}