import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';

class PopularityObj {
  UserIncomeRank userIncomeRank;
  UserIncomeRank userInviteRank;
  UserIncomeRank userUploadRank;

  PopularityObj(
      {this.userIncomeRank, this.userInviteRank, this.userUploadRank});

  PopularityObj.fromJson(Map<String, dynamic> json) {
    userIncomeRank = json['userIncomeRank'] != null
        ? new UserIncomeRank.fromJson(json['userIncomeRank'])
        : null;
    userInviteRank = json['userInviteRank'] != null
        ? new UserIncomeRank.fromJson(json['userInviteRank'])
        : null;
    userUploadRank = json['userUploadRank'] != null
        ? new UserIncomeRank.fromJson(json['userUploadRank'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userIncomeRank != null) {
      data['userIncomeRank'] = this.userIncomeRank.toJson();
    }
    if (this.userInviteRank != null) {
      data['userInviteRank'] = this.userInviteRank.toJson();
    }
    if (this.userUploadRank != null) {
      data['userUploadRank'] = this.userUploadRank.toJson();
    }
    return data;
  }
}

class UserIncomeRank {
  List<PopularityModel> itemList;
  int sort;
  String background;
  String updatedAt;

  UserIncomeRank({this.itemList, this.sort, this.background, this.updatedAt});

  UserIncomeRank.fromJson(Map<String, dynamic> json) {
    if (json['itemList'] != null) {
      itemList = new List<PopularityModel>();
      json['itemList'].forEach((v) {
        itemList.add(PopularityModel.fromJson(v));
      });
    }
    sort = json['sort'];
    background = json['background'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.itemList != null) {
      data['itemList'] = this.itemList.map((v) => v.toJson()).toList();
    }
    data['sort'] = this.sort;
    data['background'] = this.background;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
