import 'package:flutter_app/model/comment_model.dart';


///评论列表返回信息
class CommentListRes {
  int lfCount;
  List<CommentModel> list;
  int total;
  bool hasNext = false;

  static CommentListRes fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentListRes commentListResBean = CommentListRes();
    commentListResBean.lfCount = map['lfCount'];
    commentListResBean.list = List()..addAll((map['list'] as List ?? []).map((o) => CommentModel.fromJson(o)));
    commentListResBean.total = map['total'];
    commentListResBean.hasNext = map['hasNext'];
    return commentListResBean;
  }

  Map toJson() => {
        "lfCount": lfCount,
        "list": list,
        "total": total,
        "hasNext": hasNext,
      };
}
