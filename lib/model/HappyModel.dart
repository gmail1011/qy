import 'ShuApp.dart';
import 'Adv.dart';

class HappyModel {
  HappyModel({
      this.shuApp, 
      this.adv,});

  HappyModel.fromJson(dynamic json) {
    if (json['shuApp'] != null) {
      shuApp = [];
      json['shuApp'].forEach((v) {
        shuApp?.add(ShuApp.fromJson(v));
      });
    }
    if (json['hengApp'] != null) {
      hengApp = [];
      json['hengApp'].forEach((v) {
        hengApp?.add(ShuApp.fromJson(v));
      });
    }
    if (json['adv'] != null) {
      adv = [];
      json['adv'].forEach((v) {
        adv?.add(Adv.fromJson(v));
      });
    }
  }
  List<ShuApp> shuApp;
  List<ShuApp> hengApp;
  List<Adv> adv;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (shuApp != null) {
      map['shuApp'] = shuApp?.map((v) => v.toJson()).toList();
    }
    if (adv != null) {
      map['adv'] = adv?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}