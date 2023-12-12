import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/reply_model.dart';

import 'awards_model.dart';

class CommentModel {
  String id;
  String objID;
  int userID;
  String userName;
  String userPortrait;
  String content;
  int likeCount;
  int commCount;
  String linkStr;
  int get realCommentCount {
    int result = commCount ?? 0;
    if(haveMoreData == false){
      result = (info?.length ?? 0) - 1;
    }else {
      result = commCount - (info?.length ?? 0) + 1;
    }
    if(result < 0){
      result = 0;
    }
    return result;
  }
  bool isAuthor;
  bool isLike;
  bool isFollow;
  bool isDelete;
  String gender;
  int status;
  String city;
  String createdAt;
  bool haveMoreData = false;// true 可加载下一页回复
  int replyPageIndex = 1;
  List<ReplyModel> info = [];
  List<ReplyModel> get replyList{
    if(info?.isNotEmpty == true) {
      if (haveMoreData || !isShowReply) {
        return info ?? [];
      }
      List<ReplyModel> tmp = info.sublist(0, 1);
      return tmp;
    }
    return [];
  }
  bool isShowReply = true; // true展开回复， false 收起回复
  bool get hasMoreReply{ // 有多条回复
    return (haveMoreData || (info?.length ?? 0) > 1) && info?.isNotEmpty == true;
  }
  int age;
  int level;
  int vipLevel;
  bool isAdoption;
  String vipExpireDate;

  bool isRequestReply = false; //是否正在请求更多回复中

  List<int> awards = [];
  List<String> awardsImage = [];
  List<AwardsExpire> awardsExpire = [];

  bool superUser;
  int merchantUser;
  bool isGodComment;

  static CommentModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    CommentModel commentModelBean = CommentModel();
    commentModelBean.isGodComment = map['isGodComment'];
    commentModelBean.id = map['id'];
    commentModelBean.objID = map['objID'];
    commentModelBean.userID = map['userID'];
    commentModelBean.userName = map['userName'];
    commentModelBean.userPortrait = map['userPortrait'];
    commentModelBean.content = map['content'];
    commentModelBean.likeCount = map['likeCount'];
    commentModelBean.commCount = map['commCount'];
    commentModelBean.isAuthor = map['isAuthor'];
    commentModelBean.isLike = map['isLike'];
    commentModelBean.isFollow = map['isFollow'];
    commentModelBean.isDelete = map['isDelete'];
    commentModelBean.gender = map['gender'];
    commentModelBean.status = map['status'];
    commentModelBean.city = map['city'];
    commentModelBean.createdAt = map['createdAt'];
    commentModelBean.age = map['age'];
    commentModelBean.level = map['level'];
    commentModelBean.vipLevel = map['vipLevel'];
    commentModelBean.linkStr = map['linkStr'];
    commentModelBean.info = List()
      ..addAll((map['Info'] as List ?? []).map((o) => ReplyModel.fromJson(o)));

    commentModelBean.awards = List()
      ..addAll((map['awards'] as List ?? []).map((o) => o));
    // commentModelBean.awardsExpire = map['awardsExpire'] == null ? [] : List()
    //   ..addAll((map['awardsExpire'] as List ?? []).map((o) => o));
    commentModelBean.superUser = map['superUser'];
    commentModelBean.merchantUser = map['merchantUser'];
    commentModelBean.vipExpireDate = map['vipExpireDate'];

    commentModelBean.awards?.forEach((element) {
      Config.userAwards?.forEach((element1) {
        if (element == element1?.number) {
          commentModelBean.awardsImage.add(element1?.imgUrl);
        }
      });
    });

    commentModelBean.awardsExpire = map["awardsExpire"] == null
        ? []
        : List<AwardsExpire>.from(
            map["awardsExpire"].map((x) => AwardsExpire.fromJson(x)));

    (commentModelBean?.awardsExpire ?? []).forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element.number == element1.number) {
          element.imageUrl = element1.imgUrl;
        }
      });
    });

    return commentModelBean;
  }

  Map toJson() => {
        "id": id,
        "objID": objID,
        "userID": userID,
        "userName": userName,
        "userPortrait": userPortrait,
        "content": content,
        "likeCount": likeCount,
        "commCount": commCount,
        "isAuthor": isAuthor,
        "isLike": isLike,
        "isFollow": isFollow,
        "isDelete": isDelete,
        "gender": gender,
        "status": status,
        "city": city,
        "createdAt": createdAt,
        "Info": info,
        "level": level,
        "vipLevel": vipLevel,
        "age": age,
        "awards": awards,
        "awardsImage": awardsImage,
        "awardsExpire": awardsExpire,
        "superUser": superUser,
        "vipExpireDate": vipExpireDate,
        "merchantUser": merchantUser,
      };
}

// class AwardsExpire {
//   AwardsExpire({
//     this.number,
//     this.isExpire,
//     this.imageUrl,
//   });
//
//   int number;
//   bool isExpire;
//   String imageUrl;
//
//   factory AwardsExpire.fromJson(Map<String, dynamic> json) => AwardsExpire(
//         number: json["number"] == null ? null : json["number"],
//         isExpire: json["isExpire"] == null ? null : json["isExpire"],
//         imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "number": number == null ? null : number,
//         "isExpire": isExpire == null ? null : isExpire,
//         "imgUrl": imageUrl == null ? null : imageUrl,
//       };
// }
