
class SearchTalkModel {
  String id;
  String name;
  String coverImg;
  String description;
  int playCount;
  bool hasCollected;

  static SearchTalkModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    SearchTalkModel model = SearchTalkModel();
    model.id = map['id'];
    model.name = map['name'];
    model.coverImg = map['coverImg'];
    model.description = map['description'];
    model.playCount = map['playCount'];
    model.hasCollected = map['hasCollected'];
    return model;
  }

  Map toJson() => {
        "id": id,
        "name": name,
        "coverImg": coverImg,
        "description": description,
        "playCount": playCount,
        "hasCollected": hasCollected,
      };
}
