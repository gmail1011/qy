import 'package:flutter_app/common/config/config.dart';

import 'awards_model.dart';

class ReplyModel {
  String id;
  String objID;
  String cid;
  int userID;
  String userName;
  String userPortrait;
  int toUserID;
  String toUserName;
  bool get isShowToName {
    return  toUserName?.isNotEmpty == true && level == 2;
  }
  String content;
  int likeCount;
  bool isLike;
  bool isAuthor;
  bool isFollow;
  bool isDelete;
  String gender;
  int status;
  String city;
  String createdAt;
  int age;
  int level;
  String vipExpireDate;
  bool imgLoadSuccess = false;
  List<int> awards = [];
  List<String> awardsImage = [];
  List<AwardsExpire> awardsExpire = [];
  bool superUser;
  int vipLevel;
  int merchantUser;
  String linkStr;

  static ReplyModel fromJson(Map<String, dynamic> map) {
    if (map == null) return null;
    ReplyModel replyModelBean = ReplyModel();
    replyModelBean.id = map['id'];
    replyModelBean.objID = map['objID'];
    replyModelBean.cid = map['cid'];
    replyModelBean.userID = map['userID'];
    replyModelBean.userName = map['userName'];
    replyModelBean.userPortrait = map['userPortrait'];
    replyModelBean.toUserID = map['toUserID'];
    replyModelBean.toUserName = map['toUserName'];
    replyModelBean.content = map['content'];
    replyModelBean.likeCount = map['likeCount'];
    replyModelBean.isLike = map['isLike'];
    replyModelBean.isAuthor = map['isAuthor'];
    replyModelBean.isFollow = map['isFollow'];
    replyModelBean.isDelete = map['isDelete'];
    replyModelBean.gender = map['gender'];
    replyModelBean.status = map['status'];
    replyModelBean.city = map['city'];
    replyModelBean.createdAt = map['createdAt'];
    replyModelBean.age = map['age'];
    replyModelBean.level = map['level'];
    replyModelBean.superUser = map['superUser'];
    replyModelBean.vipLevel = map['vipLevel'];
    replyModelBean.merchantUser = map['merchantUser'];
    replyModelBean.linkStr = map['linkStr'];
    replyModelBean.vipExpireDate = map['vipExpireDate'];
    replyModelBean.awards = List()
      ..addAll((map['awards'] as List ?? []).map((o) => o));

    replyModelBean.awards?.forEach((element) {
      Config.userAwards?.forEach((element1) {
        if (element == element1?.number) {
          replyModelBean.awardsImage.add(element1?.imgUrl);
        }
      });
    });

    replyModelBean.awardsExpire = map["awardsExpire"] == null
        ? []
        : List<AwardsExpire>.from(
            map["awardsExpire"].map((x) => AwardsExpire.fromJson(x)));

    (replyModelBean?.awardsExpire ?? []).forEach((element) {
      Config.userAwards.forEach((element1) {
        if (element.number == element1.number) {
          element.imageUrl = element1.imgUrl;
        }
      });
    });
    return replyModelBean;
  }

  Map toJson() => {
        "id": id,
        "objID": objID,
        "cid": cid,
        "userID": userID,
        "userName": userName,
        "userPortrait": userPortrait,
        "toUserID": toUserID,
        "toUserName": toUserName,
        "content": content,
        "likeCount": likeCount,
        "isLike": isLike,
        "isAuthor": isAuthor,
        "isFollow": isFollow,
        "isDelete": isDelete,
        "gender": gender,
        "status": status,
        "city": city,
        "createdAt": createdAt,
        "level": level,
        "age": age,
        "awards": awards,
        "awardsExpire": awardsExpire,
        "superUser": superUser,
        "vipExpireDate": vipExpireDate,
        "vipLevel": vipLevel,
        "merchantUser": merchantUser,
      'linkStr': linkStr,
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
