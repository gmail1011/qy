import 'package:flutter_app/model/reply_model.dart';


class ReplyListRes {
  List<ReplyModel> list;
  bool hasNext = false;

  static ReplyListRes fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    ReplyListRes replyListResBean = ReplyListRes();
    replyListResBean.list = List()..addAll((map['list'] as List ?? []).map((o) => ReplyModel.fromJson(o)));
    replyListResBean.hasNext = map['hasNext'];
    return replyListResBean;
  }

  Map toJson() => {
        "list": list,
        "hasNext": hasNext,
      };
}
