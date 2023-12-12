class OfficeItemData {
  String officialName;
  String officialDesc;
  String officialImg;
  String officialUrl;
  String officialType;
  int position;

  OfficeItemData();

  static List<OfficeItemData> toList(List<dynamic> mapList) {
    List<OfficeItemData> list = new List();
    if (mapList == null) return list;
    Iterator iterator = mapList.iterator;
    while (iterator.moveNext()) {
      Map<String, dynamic> current = iterator.current;
      list.add(fromMap(current));
    }
    return list;
  }

  static OfficeItemData fromMap(Map<String, dynamic> json) {
    if (json == null) return null;
    OfficeItemData officeItemData = OfficeItemData();
    officeItemData.officialName = json['officialName'];
    officeItemData.officialDesc = json['officialDesc'];
    officeItemData.officialImg = json['officialImg'];
    officeItemData.officialType = json['officialType'];
    officeItemData.officialUrl = json['officialUrl'];
    officeItemData.position = json['position'];
    return officeItemData;
  }
}
