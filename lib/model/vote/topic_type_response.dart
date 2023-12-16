class TopicTypeResponse {

  bool hasNext;
  List<TopicTypeModel> list;

  TopicTypeResponse();

  TopicTypeResponse.fromJson(dynamic json) {
    hasNext = json['hasNext'];
    if (json['list'] is List) {
      list = [];
      json['list'].forEach((v) {
        list.add(TopicTypeModel.fromJson(v));
      });
    }
  }
}


class TopicTypeModel {

  String id;
  String title;
  String img;
  String createAt;
  String updateAt;
  String desc;

  TopicTypeModel();

  TopicTypeModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    img = json['img'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
    desc = json['desc'];
  }

}