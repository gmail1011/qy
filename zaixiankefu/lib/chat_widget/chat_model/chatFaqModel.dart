class FaqModel {
  String id;
  String appId;
  List<QuestBean> quest;
  String createAt;
  String updateAt;

  static FaqModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    FaqModel faqModelBean = FaqModel();
    faqModelBean.id = map['_id'];
    faqModelBean.appId = map['appId'];
    faqModelBean.quest = List()..addAll(
      (map['quest'] as List ?? []).map((o) => QuestBean.fromMap(o))
    );
    faqModelBean.createAt = map['createAt'];
    faqModelBean.updateAt = map['updateAt'];
    return faqModelBean;
  }

  Map toJson() => {
    "_id": id,
    "appId": appId,
    "quest": quest,
    "createAt": createAt,
    "updateAt": updateAt,
  };
}

/// questType : 1
/// questName : "登陆问题"
/// questTitle : [{"name":"账号问题?","value":"重新注册一个把,没救了!"},{"name":"密码问题?","value":"重新注册一个把,没救了!"},{"name":"网络问题?","value":"重新注册一个把,没救了!"},{"name":"链接超时?","value":"重新注册一个把,没救了!"},{"name":"注册失败?","value":"重新注册一个把,没救了!"}]

class QuestBean {
  int questType;
  String questName;
  String value;
  List<QuestTitleBean> questTitle;

  static QuestBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    QuestBean questBean = QuestBean();
    questBean.questType = map['questType'] ?? 0;
    questBean.value = map['value'] ?? '';
    questBean.questName = map['questName'];
    questBean.questTitle = List()..addAll(
      (map['questTitle'] as List ?? []).map((o) => QuestTitleBean.fromMap(o))
    );
    return questBean;
  }

  Map toJson() => {
    "questType": questType,
    "questName": questName,
    "questTitle": questTitle,
    "value":value
  };
}

/// name : "账号问题?"
/// value : "重新注册一个把,没救了!"

class QuestTitleBean {
  String name;
  String value;

  static QuestTitleBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    QuestTitleBean questTitleBean = QuestTitleBean();
    questTitleBean.name = map['name'];
    questTitleBean.value = map['value'];
    return questTitleBean;
  }

  Map toJson() => {
    "name": name,
    "value": value,
  };
}

class TimeDownBean {
  int time = 10;
  int type = 0;//保存定时器状态 0 取消 1 存在
}
