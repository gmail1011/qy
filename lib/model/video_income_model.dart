class VideoIncomeModel {
  String totalVideoAmount;
  String todayTodayAmount;
  String yesterdayAmount;
  String mounthAmount;
  bool hasNext;
  List<VideoIncome> videoIncomeList;

  VideoIncomeModel(
      {this.totalVideoAmount,
      this.todayTodayAmount,
      this.yesterdayAmount,
      this.mounthAmount,
      this.hasNext,
      this.videoIncomeList});

  VideoIncomeModel.fromJson(Map<String, dynamic> json) {
    totalVideoAmount = json['totalVideoAmount'];
    todayTodayAmount = json['todayTodayAmount'];
    yesterdayAmount = json['yesterdayAmount'];
    mounthAmount = json['mounthAmount'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      videoIncomeList = new List<VideoIncome>();
      json['list'].forEach((v) {
        videoIncomeList.add(new VideoIncome.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalVideoAmount'] = this.totalVideoAmount;
    data['todayTodayAmount'] = this.todayTodayAmount;
    data['yesterdayAmount'] = this.yesterdayAmount;
    data['mounthAmount'] = this.mounthAmount;
    data['hasNext'] = this.hasNext;
    if (this.videoIncomeList != null) {
      data['list'] = this.videoIncomeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoIncome {
  String title;
  String incomeAmount;
  int incomeType;
  String incomeTime;

  VideoIncome(
      {this.title, this.incomeAmount, this.incomeType, this.incomeTime});

  VideoIncome.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    incomeAmount = json['incomeAmount'];
    incomeType = json['incomeType'];
    incomeTime = json['incomeTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['incomeAmount'] = this.incomeAmount;
    data['incomeType'] = this.incomeType;
    data['incomeTime'] = this.incomeTime;
    return data;
  }
}
