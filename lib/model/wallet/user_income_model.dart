class UserIncomeModel {
  String totalAmount; // 可提现收益
  String totalIncomeAmount; // 累计收益总额
  String totalPayUserCount; // 累计付费用户
  String totalInviteUserCount; // 累计推广用户
  String todayInviteUserCount; // 今日推广用户
  String monthInviteUserCount; // 当月推广用户
  String monthIncomeAmount; // 当月推广收益金币
  String todayIncomeAmount; // 今日推广收益金币

  UserIncomeModel({
    this.totalAmount,
    this.totalIncomeAmount,
    this.totalPayUserCount,
    this.totalInviteUserCount,
    this.todayInviteUserCount,
    this.todayIncomeAmount,
    this.monthInviteUserCount,
    this.monthIncomeAmount,
  });

  UserIncomeModel.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalIncomeAmount = json['totalIncomeAmount'];
    totalPayUserCount = json['totalPayUserCount'];
    totalInviteUserCount = json['totalInviteUserCount'];
    todayInviteUserCount = json['todayInviteUserCount'];
    todayIncomeAmount = json['todayIncomeAmount'];
    monthInviteUserCount = json['monthInviteUserCount'];
    monthIncomeAmount = json['monthIncomeAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    data['totalIncomeAmount'] = this.totalIncomeAmount;
    data['totalPayUserCount'] = this.totalPayUserCount;
    data['totalInviteUserCount'] = this.totalInviteUserCount;
    data['todayInviteUserCount'] = this.todayInviteUserCount;
    data['todayIncomeAmount'] = this.todayIncomeAmount;
    data['monthInviteUserCount'] = this.monthInviteUserCount;
    data['monthIncomeAmount'] = this.monthIncomeAmount;
    return data;
  }
}
