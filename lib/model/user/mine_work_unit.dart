
class MineWorkUnit {
  bool hasNext = false;
  List<WorkUnitModel> list;
  int total = 0;
  static MineWorkUnit fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    MineWorkUnit mineVideoBean = MineWorkUnit();
    mineVideoBean.hasNext = map['hasNext'] ?? false;
    mineVideoBean.total = map['total'] ?? 0;
    mineVideoBean.list = List()..addAll(
        (map['list'] as List ?? []).map((o) => WorkUnitModel.fromJson(o))
    );
    return mineVideoBean;
  }

  Map toJson() => {
    "hasNext": hasNext,
    "list": list,
    'total': total,
  };
}

class WorkUnitModel {
  String id;
  String name;
  int publisherID;
  String portrait;
  String collectionName;
  String collectionDesc;
  String coverImg;
  String description;
  int sortCode;
  int vPlayCount;
  int tPlayCount;
  int fakePlayCount;
  int playRating;
  int collCount;
  int likeCount;
  int fakeCollCount;
  bool isActive;
  int status;
  int totalCount;
  String updateTime;
  String createTime;
  bool isSelect;

  static WorkUnitModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    WorkUnitModel mineVideoBean = WorkUnitModel();
    mineVideoBean.id = map['id'];
    mineVideoBean.name = map['name'];
    mineVideoBean.publisherID = map['publisherID'];
    mineVideoBean.portrait = map['portrait'];
    mineVideoBean.collectionName = map['collectionName'];
    mineVideoBean.collectionDesc = map['collectionDesc'];
    mineVideoBean.coverImg = map['coverImg'];
    mineVideoBean.description = map['description'];
    mineVideoBean.sortCode = map['sortCode'];
    mineVideoBean.vPlayCount = map['vPlayCount'];
    mineVideoBean.tPlayCount = map['tPlayCount'];
    mineVideoBean.fakePlayCount = map['fakePlayCount'];
    mineVideoBean.playRating = map['playRating'];
    mineVideoBean.collCount = map['collCount'];
    mineVideoBean.likeCount = map['likeCount'];
    mineVideoBean.fakeCollCount = map['fakeCollCount'];
    mineVideoBean.isActive = map['isActive'];
    mineVideoBean.status = map['status'];
    mineVideoBean.totalCount = map['totalCount'];
    mineVideoBean.updateTime = map['updateTime'];
    mineVideoBean.createTime = map['createTime'];

    return mineVideoBean;
  }
}