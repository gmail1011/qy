/// dailyTask : [{"id":"64fc46e9a144e7c95bbe6417","title":"每日登录","img":"cf230705/image/1by/13r/25f/13j/ea1f789e1e3e1728d46bc17e06d47a67.jpeg","type":2,"desc":"每日登录","detail":[{"prizes":[{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}],"finishCondition":1,"finishCount":0,"status":0}],"link":""},{"id":"6503dbd64bd53f0d5ec9a24c","title":"每日发帖","img":"cf230705/image/1mk/4h/14f/m3/b05f3caefa7f84d2342f1d01f2a5dc76.jpeg","type":4,"desc":"发布高质量帖子并通过审核，即可获得10积分","detail":[{"prizes":[{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}],"finishCondition":1,"finishCount":0,"status":0}],"link":""},{"id":"6503dc064bd53f0d5ec9a24d","title":"每日评论","img":"cf230705/image/10q/p6/1e6/32m/7b28ca7afe8163e799d16d4faf61d4fa.jpeg","type":3,"desc":"每日评论","detail":[{"prizes":[{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}],"finishCondition":3,"finishCount":0,"status":0}],"link":""}]
/// onceTask : [{"id":"6503d2da600038d272fdae6d","title":"海角社区网页版","img":"cf230705/image/1ea/b2/w5/2iq/d68a5d70f95a11c403965b0e3e3fca4e.jpeg","type":2,"prizes":[{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}],"desc":"海角社区网页版","link":"https://hjh5.cestalt.com","status":0},{"id":"6503dabd4bd53f0d5ec9a24a","title":"下海直播","img":"cf230705/image/1by/13r/25f/13j/ea1f789e1e3e1728d46bc17e06d47a67.jpeg","type":2,"prizes":[{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}],"desc":"下载并打开即可获得10积分","link":"https://hjh5.cestalt.com","status":0}]

class TaskCenterData {
  TaskCenterData({
    List<DailyTask> dailyTask,
    List<DailyTask> onceTask,
  }) {
    _dailyTask = dailyTask;
    _onceTask = onceTask;
  }

  TaskCenterData.fromJson(dynamic json) {
    if (json['dailyTask'] != null) {
      _dailyTask = [];
      json['dailyTask'].forEach((v) {
        _dailyTask.add(DailyTask.fromJson(v));
      });
    }
    if (json['onceTask'] != null) {
      _onceTask = [];
      json['onceTask'].forEach((v) {
        _onceTask.add(DailyTask.fromJson(v));
      });
    }
  }

  List<DailyTask> _dailyTask;
  List<DailyTask> _onceTask;

  TaskCenterData copyWith({
    List<DailyTask> dailyTask,
    List<DailyTask> onceTask,
  }) =>
      TaskCenterData(
        dailyTask: dailyTask ?? _dailyTask,
        onceTask: onceTask ?? _onceTask,
      );

  List<DailyTask> get dailyTask => _dailyTask;

  List<DailyTask> get onceTask => _onceTask;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_dailyTask != null) {
      map['dailyTask'] = _dailyTask.map((v) => v.toJson()).toList();
    }
    if (_onceTask != null) {
      map['onceTask'] = _onceTask.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Prizes {
  Prizes({
    String id,
    String activityId,
    String vipCardId,
    String name,
    num type,
    num count,
    num price,
    num sort,
    String desc,
    num value,
    String weights,
    num level,
    bool status,
    num validityTime,
    String image,
    String updateTime,
    String createTimt,
  }) {
    _id = id;
    _activityId = activityId;
    _vipCardId = vipCardId;
    _name = name;
    _type = type;
    _count = count;
    _price = price;
    _sort = sort;
    _desc = desc;
    _value = value;
    _weights = weights;
    _level = level;
    _status = status;
    _validityTime = validityTime;
    _image = image;
    _updateTime = updateTime;
    _createTimt = createTimt;
  }

  Prizes.fromJson(dynamic json) {
    _id = json['id'];
    _activityId = json['activityId'];
    _vipCardId = json['vipCardId'];
    _name = json['name'];
    _type = json['type'];
    _count = json['count'];
    _price = json['price'];
    _sort = json['sort'];
    _desc = json['desc'];
    _value = json['value'];
    _weights = json['weights'];
    _level = json['level'];
    _status = json['status'];
    _validityTime = json['validityTime'];
    _image = json['image'];
    _updateTime = json['updateTime'];
    _createTimt = json['createTimt'];
  }

  String _id;
  String _activityId;
  String _vipCardId;
  String _name;
  num _type;
  num _count;
  num _price;
  num _sort;
  String _desc;
  num _value;
  String _weights;
  num _level;
  bool _status;
  num _validityTime;
  String _image;
  String _updateTime;
  String _createTimt;

  Prizes copyWith({
    String id,
    String activityId,
    String vipCardId,
    String name,
    num type,
    num count,
    num price,
    num sort,
    String desc,
    num value,
    String weights,
    num level,
    bool status,
    num validityTime,
    String image,
    String updateTime,
    String createTimt,
  }) =>
      Prizes(
        id: id ?? _id,
        activityId: activityId ?? _activityId,
        vipCardId: vipCardId ?? _vipCardId,
        name: name ?? _name,
        type: type ?? _type,
        count: count ?? _count,
        price: price ?? _price,
        sort: sort ?? _sort,
        desc: desc ?? _desc,
        value: value ?? _value,
        weights: weights ?? _weights,
        level: level ?? _level,
        status: status ?? _status,
        validityTime: validityTime ?? _validityTime,
        image: image ?? _image,
        updateTime: updateTime ?? _updateTime,
        createTimt: createTimt ?? _createTimt,
      );

  String get id => _id;

  String get activityId => _activityId;

  String get vipCardId => _vipCardId;

  String get name => _name;

  num get type => _type;

  num get count => _count;

  num get price => _price;

  num get sort => _sort;

  String get desc => _desc;

  num get value => _value;

  String get weights => _weights;

  num get level => _level;

  bool get status => _status;

  num get validityTime => _validityTime;

  String get image => _image;

  String get updateTime => _updateTime;

  String get createTimt => _createTimt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['activityId'] = _activityId;
    map['vipCardId'] = _vipCardId;
    map['name'] = _name;
    map['type'] = _type;
    map['count'] = _count;
    map['price'] = _price;
    map['sort'] = _sort;
    map['desc'] = _desc;
    map['value'] = _value;
    map['weights'] = _weights;
    map['level'] = _level;
    map['status'] = _status;
    map['validityTime'] = _validityTime;
    map['image'] = _image;
    map['updateTime'] = _updateTime;
    map['createTimt'] = _createTimt;
    return map;
  }
}

/// id : "64fc46e9a144e7c95bbe6417"
/// title : "每日登录"
/// img : "cf230705/image/1by/13r/25f/13j/ea1f789e1e3e1728d46bc17e06d47a67.jpeg"
/// type : 2
/// desc : "每日登录"
/// detail : [{"prizes":[{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}],"finishCondition":1,"finishCount":0,"status":0}]
/// link : ""

class DailyTask {
  DailyTask({
    String id,
    String title,
    String img,
    num type,
    num status,
    String desc,
    List<Detail> detail,
    List<Prizes> prizes,
    String link,
  }) {
    _id = id;
    _title = title;
    _img = img;
    _type = type;
    _desc = desc;
    _status = status;
    _detail = detail;
    _prizes = prizes;
    _link = link;
  }

  DailyTask.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _img = json['img'];
    _type = json['type'];
    _desc = json['desc'];
    _status = json['status'];
    if (json['detail'] != null) {
      _detail = [];
      json['detail'].forEach((v) {
        _detail.add(Detail.fromJson(v));
      });
    }
    if (json['prizes'] != null) {
      _prizes = [];
      json['prizes'].forEach((v) {
        _prizes.add(Prizes.fromJson(v));
      });
    }
    _link = json['link'];
  }

  String _id;
  String _title;
  String _img;
  num _type;
  num doType;
  String _desc;
  List<Detail> _detail;
  String _link;

  List<Prizes> _prizes;
  num _status;

  DailyTask copyWith({
    String id,
    String title,
    String img,
    num type,
    num status,
    String desc,
    List<Detail> detail,
    List<Prizes> prizes,
    String link,
  }) =>
      DailyTask(
        id: id ?? _id,
        title: title ?? _title,
        img: img ?? _img,
        type: type ?? _type,
        status: status ?? _status,
        desc: desc ?? _desc,
        detail: detail ?? _detail,
        prizes: prizes ?? _prizes,
        link: link ?? _link,
      );

  String get id => _id;

  String get title => _title;

  String get img => _img;

  num get type => _type;

  num get status => _status;

  String get desc => _desc;

  List<Detail> get detail => _detail;

  List<Prizes> get prizes => _prizes;

  String get link => _link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['img'] = _img;
    map['type'] = _type;
    map['desc'] = _desc;
    if (_detail != null) {
      map['detail'] = _detail.map((v) => v.toJson()).toList();
    }
    map['link'] = _link;
    return map;
  }
}

/// prizes : [{"id":"6503d1a3600038d272fdae6c","activityId":"000000000000000000000000","vipCardId":"000000000000000000000000","name":"10积分","type":8,"count":10,"price":10,"sort":1,"desc":"","value":0,"weights":"1","level":1,"status":true,"validityTime":11,"image":"","updateTime":"2023-09-15T11:38:11.488+08:00","createTimt":"2023-09-15T11:38:11.488+08:00"}]
/// finishCondition : 1
/// finishCount : 0
/// status : 0

class Detail {
  Detail({
    List<Prizes> prizes,
    num finishCondition,
    num finishCount,
    num status,
  }) {
    _prizes = prizes;
    _finishCondition = finishCondition;
    _finishCount = finishCount;
    _status = status;
  }

  Detail.fromJson(dynamic json) {
    if (json['prizes'] != null) {
      _prizes = [];
      json['prizes'].forEach((v) {
        _prizes.add(Prizes.fromJson(v));
      });
    }
    _finishCondition = json['finishCondition'];
    _finishCount = json['finishCount'];
    _status = json['status'];
  }

  List<Prizes> _prizes;
  num _finishCondition;
  num _finishCount;
  num _status;

  Detail copyWith({
    List<Prizes> prizes,
    num finishCondition,
    num finishCount,
    num status,
  }) =>
      Detail(
        prizes: prizes ?? _prizes,
        finishCondition: finishCondition ?? _finishCondition,
        finishCount: finishCount ?? _finishCount,
        status: status ?? _status,
      );

  List<Prizes> get prizes => _prizes;

  num get finishCondition => _finishCondition;

  num get finishCount => _finishCount;

  num get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_prizes != null) {
      map['prizes'] = _prizes.map((v) => v.toJson()).toList();
    }
    map['finishCondition'] = _finishCondition;
    map['finishCount'] = _finishCount;
    map['status'] = _status;
    return map;
  }
}
