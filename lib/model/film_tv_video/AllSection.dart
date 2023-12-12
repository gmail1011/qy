import 'AllTags.dart';

class AllSection {
  AllSection({
      this.sectionID, 
      this.sectionName, 
      this.allTags,});

  AllSection.fromJson(dynamic json) {
    sectionID = json['sectionID'];
    sectionName = json['sectionName'];
    if (json['allTags'] != null) {
      allTags = [];
      json['allTags'].forEach((v) {
        allTags.add(AllTags.fromJson(v));
      });
    }
  }
  String sectionID;
  String sectionName;
  List<AllTags> allTags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sectionID'] = sectionID;
    map['sectionName'] = sectionName;
    if (allTags != null) {
      map['allTags'] = allTags.map((v) => v.toJson()).toList();
    }
    return map;
  }

}