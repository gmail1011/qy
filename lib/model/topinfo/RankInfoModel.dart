class RankInfoModel {
  RankInfoModel({
      this.rankType, 
      this.ranking, 
      this.serialNo, 
      this.seriesID, 
      this.title, 
      this.year,});

  RankInfoModel.fromJson(dynamic json) {
    rankType = json['rankType'];
    ranking = json['ranking'];
    serialNo = json['serialNo'];
    seriesID = json['seriesID'];
    title = json['title'];
    year = json['year'];
  }
  String rankType;
  int ranking;
  int serialNo;
  String seriesID;
  String title;
  String year;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['rankType'] = rankType;
    map['ranking'] = ranking;
    map['serialNo'] = serialNo;
    map['seriesID'] = seriesID;
    map['title'] = title;
    map['year'] = year;
    return map;
  }

}