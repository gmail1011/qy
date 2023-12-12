
class FictionModel {
  List<String> fictionType;

  FictionModel({this.fictionType});

  FictionModel.fromJson(Map<String, dynamic> json) {
    fictionType = (json['fictionType']??[]).cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fictionType'] = this.fictionType;
    return data;
  }
}