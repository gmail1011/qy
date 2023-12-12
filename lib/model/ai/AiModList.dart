import 'AiUndressMod.dart';
import 'AiChangeFaceVideoMod.dart';
import 'AiChangeFaceMod.dart';

class AiModList {
  AiModList({
      this.aiUndressMod, 
      this.aiChangeFaceVideoMod, 
      this.aiChangeFaceMod,});

  AiModList.fromJson(dynamic json) {
    if (json['aiUndressMod'] != null) {
      aiUndressMod = [];
      json['aiUndressMod'].forEach((v) {
        aiUndressMod.add(AiUndressMod.fromJson(v));
      });
    }
    if (json['aiChangeFaceVideoMod'] != null) {
      aiChangeFaceVideoMod = [];
      json['aiChangeFaceVideoMod'].forEach((v) {
        aiChangeFaceVideoMod.add(AiChangeFaceVideoMod.fromJson(v));
      });
    }
    if (json['aiChangeFaceMod'] != null) {
      aiChangeFaceMod = [];
      json['aiChangeFaceMod'].forEach((v) {
        aiChangeFaceMod.add(AiChangeFaceMod.fromJson(v));
      });
    }
  }
  List<AiUndressMod> aiUndressMod;
  List<AiChangeFaceVideoMod> aiChangeFaceVideoMod;
  List<AiChangeFaceMod> aiChangeFaceMod;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (aiUndressMod != null) {
      map['aiUndressMod'] = aiUndressMod.map((v) => v.toJson()).toList();
    }
    if (aiChangeFaceVideoMod != null) {
      map['aiChangeFaceVideoMod'] = aiChangeFaceVideoMod.map((v) => v.toJson()).toList();
    }
    if (aiChangeFaceMod != null) {
      map['aiChangeFaceMod'] = aiChangeFaceMod.map((v) => v.toJson()).toList();
    }
    return map;
  }

}