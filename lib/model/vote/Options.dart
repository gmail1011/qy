class Options {
  Options({
      this.id, 
      this.voteID, 
      this.option, 
      this.voteCount,
      this.hasVoted});

  Options.fromJson(dynamic json) {
    id = json['id'];
    voteID = json['voteID'];
    option = json['option'];
    voteCount = json['voteCount'];
    hasVoted = json['hasVoted'];
  }
  String id;
  String voteID;
  String option;
  int voteCount;
  bool hasVoted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['voteID'] = voteID;
    map['option'] = option;
    map['voteCount'] = voteCount;
    map['hasVoted'] = hasVoted;
    return map;
  }

}