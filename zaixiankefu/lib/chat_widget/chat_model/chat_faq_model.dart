/// code : 200
/// data : [{"questName":"绑定问题","questType":1005},{"questName":"IOS掉签","questType":1004},{"questName":"分享问题","questType":1002},{"questName":"支付问题","questType":1001},{"questName":"观影问题","questType":1003}]
/// msg : "SUCCESS"
///
///
///问题分类
class ChatFaqModel {
  int code;
  List<ChatDataBean> data;
  String msg;

  static ChatFaqModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ChatFaqModel chatFaqModelBean = ChatFaqModel();
    chatFaqModelBean.code = map['code'];
    chatFaqModelBean.data = List()..addAll(
      (map['data'] as List ?? []).map((o) => ChatDataBean.fromMap(o))
    );
    chatFaqModelBean.msg = map['msg'];
    return chatFaqModelBean;
  }

  Map toJson() => {
    "code": code,
    "data": data,
    "msg": msg,
  };
}

/// questName : "绑定问题"
/// questType : 1005

class ChatDataBean {
  String questName;
  int questType;

  static ChatDataBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ChatDataBean dataBean = ChatDataBean();
    dataBean.questName = map['questName'];
    dataBean.questType = map['questType'];
    return dataBean;
  }

  Map toJson() => {
    "questName": questName,
    "questType": questType,
  };
}


/// code : 200
/// data : [{"questTitle":"手机绑定登录","questAnswer":"您好，登录产品后“我的”界面-右上角登入-输入您的手机号-获取验证码登录即可"},{"questTitle":"怎么解绑","questAnswer":"现在还没有开启这个功能"},{"questTitle":"更新后双id找回旧账号","questAnswer":"1.让用户提供旧帐号信息(推广码、id、注册日期、邀请人数）\n2.查询新、旧id的ip地址是否一致，用户反馈和后台查询结果一致便可找回。\n3.后台-用户列表-编辑（新的id绑定手机号改1位错误数字，把正确手机号编辑到旧id上，让用户点击“我”界面-账号与安全-手机号登录即可"}]
/// msg : "SUCCESS"
///  问题分类下的对应的答案 

class ChatAnwserModel {
  int code;
  List<ChatAnwserDataBean> data;
  String msg;

  static ChatAnwserModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ChatAnwserModel chatAnwserModelBean = ChatAnwserModel();
    chatAnwserModelBean.code = map['code'];
    chatAnwserModelBean.data = List()..addAll(
      (map['data'] as List ?? []).map((o) => ChatAnwserDataBean.fromMap(o))
    );
    chatAnwserModelBean.msg = map['msg'];
    return chatAnwserModelBean;
  }

  Map toJson() => {
    "code": code,
    "data": data,
    "msg": msg,
  };
}

/// questTitle : "手机绑定登录"
/// questAnswer : "您好，登录产品后“我的”界面-右上角登入-输入您的手机号-获取验证码登录即可"

class ChatAnwserDataBean {
  String questTitle;
  String questAnswer;

  static ChatAnwserDataBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ChatAnwserDataBean dataBean = ChatAnwserDataBean();
    dataBean.questTitle = map['questTitle'];
    dataBean.questAnswer = map['questAnswer'];
    return dataBean;
  }

  Map toJson() => {
    "questTitle": questTitle,
    "questAnswer": questAnswer,
  };
}


//=============================faq答案展示================================================
/// questTitle : "更新后双id找回旧账号"
/// questAnswer : "1.让用户提供旧帐号信息(推广码、id、注册日期、邀请人数）2.查询新旧id的ip地址是否一致，用户反馈和后台查询结果一致便可找回。3.后台-用户列表-编辑（新的id绑定手机号改1位错误数字，把正确手机号编辑到旧id上，让用户点击“我”界面-账号与安全-手机号登录即可"
/// data : [{"questTitle":"手机绑定登录","questAnswer":"您好，登录产品后“我的”界面-右上角登入-输入您的手机号-获取验证码登录即可"},{"questTitle":"怎么解绑","questAnswer":"现在还没有开启这个功能"}]

class ChatResultModel {
  String questTitle;
  String questAnswer;
  List<ChatAnwserDataBean> data;

  static ChatResultModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ChatResultModel chatResultModelBean = ChatResultModel();
    chatResultModelBean.questTitle = map['questTitle'];
    chatResultModelBean.questAnswer = map['questAnswer'];
    chatResultModelBean.data = List()..addAll(
      (map['data'] as List ?? []).map((o) => ChatAnwserDataBean.fromMap(o))
    );
    return chatResultModelBean;
  }

  Map toJson() => {
    "questTitle": questTitle,
    "questAnswer": questAnswer,
    "data": data,
  };
}

