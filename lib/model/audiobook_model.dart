
class AudioBookHomeModel {
  List<Anchor> anchor;
  List<AudioBook> newAudioBook;
  List<AudioBook> pushAudioBook;

  AudioBookHomeModel({this.anchor, this.newAudioBook, this.pushAudioBook});

  AudioBookHomeModel.fromJson(Map<String, dynamic> json) {
    if (json['anchor'] != null) {
      anchor = new List<Anchor>();
      json['anchor'].forEach((v) {
        anchor.add(new Anchor.fromJson(v));
      });
    }
    if (json['newAudioBook'] != null) {
      newAudioBook = new List<AudioBook>();
      json['newAudioBook'].forEach((v) {
        newAudioBook.add(new AudioBook.fromJson(v));
      });
    }
    if (json['pushAudioBook'] != null) {
      pushAudioBook = new List<AudioBook>();
      json['pushAudioBook'].forEach((v) {
        pushAudioBook.add(new AudioBook.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.anchor != null) {
      data['anchor'] = this.anchor.map((v) => v.toJson()).toList();
    }
    if (this.newAudioBook != null) {
      data['newAudioBook'] = this.newAudioBook.map((v) => v.toJson()).toList();
    }
    if (this.pushAudioBook != null) {
      data['pushAudioBook'] =
          this.pushAudioBook.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Anchor {
  String id;
  String name;
  String avatar;
  int totalRaido;
  int countCollect;
  bool isCollect;
  String createdAt;
  String updatedAt;

  Anchor(
      {this.id,
      this.name,
      this.avatar,
      this.totalRaido,
      this.countCollect,
      this.isCollect,
      this.createdAt,
      this.updatedAt});

  Anchor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    totalRaido = json['totalRaido'];
    countCollect = json['countCollect'];
    isCollect = json['isCollect'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['totalRaido'] = this.totalRaido;
    data['countCollect'] = this.countCollect;
    data['isCollect'] = this.isCollect;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class AudioBook {
  String id;
  String title;
  //作者全部信息 只有在详情的时候才全部返回
  Anchor anchorInfo;
  String anchor;
  String cover;
  // 原音
  List<EpisodeModel> contentSet;
  // 试听
  List<EpisodeModel> trialSet;
  String fType;
  String summary;
  bool isActive;
  int totalEpisode;
  int countPurchases;
  int countBrowse;
  int countCollect;
  bool isCollect;
  int originalPrice;
  int discountPrice;

  AudioBook(
      {this.id,
      this.title,
      this.anchor,
      this.cover,
      this.contentSet,
      this.trialSet,
      this.fType,
      this.summary,
      this.isActive,
      this.totalEpisode,
      this.countPurchases,
      this.countBrowse,
      this.countCollect,
      this.isCollect,
      this.originalPrice,
      this.discountPrice});

  AudioBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    anchor = json['anchor'];
    anchorInfo =
        null == json['anchorInfo'] ? null : Anchor.fromJson(json['anchorInfo']);
    if (json['contentSet'] != null) {
      contentSet = new List<EpisodeModel>();
      json['contentSet'].forEach((v) {
        contentSet.add(new EpisodeModel.fromJson(v));
      });
    }
    if (json['trialSet'] != null) {
      trialSet = new List<EpisodeModel>();
      json['trialSet'].forEach((v) {
        trialSet.add(new EpisodeModel.fromJson(v));
      });
    }
    fType = json['fType'];
    summary = json['summary'];
    isActive = json['isActive'];
    totalEpisode = json['totalEpisode'];
    countPurchases = json['countPurchases'];
    countBrowse = json['countBrowse'];
    countCollect = json['countCollect'];
    isCollect = json['isCollect'];
    originalPrice = json['originalPrice'];
    discountPrice = json['discountPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['cover'] = this.cover;
    if (this.contentSet != null) {
      data['contentSet'] = this.contentSet.map((v) => v.toJson()).toList();
    }
    if (this.trialSet != null) {
      data['trialSet'] = this.trialSet.map((v) => v.toJson()).toList();
    }
    data['fType'] = this.fType;
    data['summary'] = this.summary;
    data['isActive'] = this.isActive;
    data['totalEpisode'] = this.totalEpisode;
    data['countPurchases'] = this.countPurchases;
    data['countBrowse'] = this.countBrowse;
    data['countCollect'] = this.countCollect;
    data['isCollect'] = this.isCollect;
    data['anchorInfo'] = this.anchorInfo?.toJson();
    data['anchor'] = this.anchor;
    data['originalPrice'] = this.originalPrice;
    data['discountPrice'] = this.discountPrice;
    return data;
  }
}

class EpisodeModel {
  int episodeNumber;
  int listenPermission;
  int price;
  String name;
  String contentUrl;
  int mediaSize;
  bool isBrought;

  EpisodeModel(
      {this.episodeNumber,
      this.listenPermission,
      this.price,
      this.name,
      this.contentUrl,
      this.isBrought,
      this.mediaSize});

  EpisodeModel.fromJson(Map<String, dynamic> json) {
    episodeNumber = json['episodeNumber'];
    listenPermission = json['listenPermission'];
    price = json['price'];
    name = json['name'];
    isBrought = json['isBrought'];
    contentUrl = json['contentUrl'];
    mediaSize = json['mediaSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['episodeNumber'] = this.episodeNumber;
    data['listenPermission'] = this.listenPermission;
    data['price'] = this.price;
    data['name'] = this.name;
    data['contentUrl'] = this.contentUrl;
    data['mediaSize'] = this.mediaSize;
    data['isBrought'] = this.isBrought;
    return data;
  }
}
