/// 批量上传图片后返回的模型
class MultiImageModel {
  List<String> filePath;
  int success;

  MultiImageModel({this.filePath, this.success});

  MultiImageModel.fromJson(Map<String, dynamic> json) {
    filePath = json['filePath']?.cast<String>();
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filePath'] = this.filePath;
    data['success'] = this.success;
    return data;
  }
}
