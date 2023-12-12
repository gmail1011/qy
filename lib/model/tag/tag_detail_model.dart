/// name : "自拍"
/// coverImg : "image/ap/by/fn/xl/7636d24bfc9b42a8975cde53140cc27b.jpg"
/// description : ""
/// hasCollected : false
/// playCount : 19771

class TagDetailModel {
  String id;
  String name;
  String coverImg;
  String description;
//  String hotIcon;
  bool hasCollected;
  int playCount;
  int videoCount;
  String desc; //爆 1 荐 热
  // ui ????
  bool isSelected = false;

  static TagDetailModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    TagDetailModel tagDetailModelBean = TagDetailModel();
    tagDetailModelBean.id = map['id'];
    tagDetailModelBean.name = map['name'];
    tagDetailModelBean.coverImg = map['coverImg'];
    tagDetailModelBean.description = map['description'];
    tagDetailModelBean.hasCollected = map['hasCollected'];
    tagDetailModelBean.playCount = map['playCount'];
    tagDetailModelBean.videoCount = map['videoCount'];
    tagDetailModelBean.desc = map['desc'];
    return tagDetailModelBean;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "coverImg": coverImg,
        "description": description,
        "hasCollected": hasCollected,
        "playCount": playCount,
        "videoCount":videoCount,
         "desc": desc,
      };

  static List<TagDetailModel> toList(List<dynamic> mapList) {
    List<TagDetailModel> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromJson(current));
    }
    return list;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagDetailModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id?.hashCode ?? '';


  String get playCountDesc{
    if((playCount ?? 0) > 10000){
      return (formatNum(playCount/10000,1)) + "W";
      // return (playCount/10000).toString() + "W";
    }
    return playCount.toString();
  }

  String get videoCountDesc{
    if((videoCount ?? 0) > 10000){
      return (formatNum(videoCount/10000, 1)) +"W";
      // return (videoCount/10000).toString() + "W";
    }
    return videoCount.toString();
  }


  String formatNum(double num, int location) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) <
        location) {
      //小数点后有几位小数
      return num.toStringAsFixed(location)
          .substring(0, num.toString().lastIndexOf(".") + location + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf(".") + location + 1)
          .toString();
    }
  }
}
