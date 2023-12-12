class InviteIncomeModel {
  int totalInvites;
  int todayInvites;
  int totalInviteAmount;
  int todayInviteAmount;
  int total;
  bool hasNext;
  List<InviteItem> inviteItemList;

  InviteIncomeModel(
      {this.totalInvites,
      this.todayInvites,
      this.totalInviteAmount,
      this.todayInviteAmount,
      this.total,
      this.hasNext,
      this.inviteItemList});

  InviteIncomeModel.fromJson(Map<String, dynamic> json) {
    totalInvites = json['totalInvites'];
    todayInvites = json['todayInvites'];
    totalInviteAmount = json['totalInviteAmount'];
    todayInviteAmount = json['todayInviteAmount'];
    total = json['total'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      inviteItemList = new List<InviteItem>();
      json['list'].forEach((v) {
        inviteItemList.add(new InviteItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalInvites'] = this.totalInvites;
    data['todayInvites'] = this.todayInvites;
    data['totalInviteAmount'] = this.totalInviteAmount;
    data['todayInviteAmount'] = this.todayInviteAmount;
    data['total'] = this.total;
    data['hasNext'] = this.hasNext;
    if (this.inviteItemList != null) {
      data['list'] = this.inviteItemList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InviteItem {
  int userId;
  String userName;
  int incomeAmount;
  double incomeRate;
  String rechargeAt;

  InviteItem(
      {this.userId,
      this.userName,
      this.incomeAmount,
      this.incomeRate,
      this.rechargeAt});

  InviteItem.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    incomeAmount = json['incomeAmount'];
    incomeRate = json['incomeRate'];
    rechargeAt = json['rechargeAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['incomeAmount'] = this.incomeAmount;
    data['incomeRate'] = this.incomeRate;
    data['rechargeAt'] = this.rechargeAt;
    return data;
  }
}
