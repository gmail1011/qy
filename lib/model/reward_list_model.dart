class RewardListModel {
  int total;
  bool hasNext;
  List<RewardItem> list;

  RewardListModel({this.total, this.hasNext, this.list});

  RewardListModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      list = new List<RewardItem>();
      json['list'].forEach((v) {
        list.add(new RewardItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['hasNext'] = this.hasNext;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RewardItem {
  int uid;
  String uPortrait;
  String uName;
  String msg;
  String title;
  String videoID;
  String videoCover;
  int reward;
  int tax;
  double publisherIncome;
  String createdAt;

  RewardItem(
      {this.uid,
      this.uPortrait,
      this.uName,
      this.msg,
      this.title,
      this.videoID,
      this.videoCover,
      this.reward,
      this.tax,
      this.publisherIncome,
      this.createdAt});

  RewardItem.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    uPortrait = json['uPortrait'];
    uName = json['uName'];
    msg = json['msg'];
    title = json['title'];
    videoID = json['videoID'];
    videoCover = json['videoCover'];
    reward = json['reward'];
    tax = json['tax'];
    publisherIncome = double.parse(json['publisherIncome'].toString());
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['uPortrait'] = this.uPortrait;
    data['uName'] = this.uName;
    data['msg'] = this.msg;
    data['title'] = this.title;
    data['videoID'] = this.videoID;
    data['videoCover'] = this.videoCover;
    data['reward'] = this.reward;
    data['tax'] = this.tax;
    data['publisherIncome'] = this.publisherIncome;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
