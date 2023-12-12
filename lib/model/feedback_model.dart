class FeedbackModel {
  int total;
  bool hasNext;
  List<FeedbackItem> feedbacks;

  FeedbackModel({this.total, this.hasNext, this.feedbacks});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    hasNext = json['hasNext'];
    if (json['list'] != null) {
      feedbacks = new List<FeedbackItem>();
      json['list'].forEach((v) {
        feedbacks.add(new FeedbackItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['hasNext'] = this.hasNext;
    if (this.feedbacks != null) {
      data['list'] = this.feedbacks.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedbackItem {
  String id;
  int uid;
  String content;
  String replay;
  String createdAt;
  String updatedAt;

  FeedbackItem(
      {this.id,
      this.uid,
      this.content,
      this.replay,
      this.createdAt,
      this.updatedAt});

  FeedbackItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    content = json['content'];
    replay = json['replay'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['content'] = this.content;
    data['replay'] = this.replay;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
