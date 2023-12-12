import 'package:flutter_app/model/domain_source_model.dart';

class ListAnnounInfo {
  List<AnnounceInfoBean> list;

  ListAnnounInfo({this.list});

  ListAnnounInfo.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<AnnounceInfoBean>();
      json['list'].forEach((v) {
        list.add(AnnounceInfoBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
