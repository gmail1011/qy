class AudioBookTypeModel {
  List<String> audiobookType;

  AudioBookTypeModel({this.audiobookType});

  AudioBookTypeModel.fromJson(Map<String, dynamic> json) {
    audiobookType = json['audiobookType'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audiobookType'] = this.audiobookType;
    return data;
  }
}
