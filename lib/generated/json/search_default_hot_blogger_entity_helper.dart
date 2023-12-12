import 'package:flutter_app/model/search_default_hot_blogger_entity.dart';

searchDefaultHotBloggerEntityFromJson(SearchDefaultHotBloggerEntity data, Map<String, dynamic> json) {
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['data'] != null) {
		data.data = SearchDefaultHotBloggerData().fromJson(json['data']);
	}
	if (json['hash'] != null) {
		data.hash = json['hash'];
	}
	if (json['msg'] != null) {
		data.msg = json['msg'].toString();
	}
	if (json['time'] != null) {
		data.time = json['time'].toString();
	}
	if (json['tip'] != null) {
		data.tip = json['tip'].toString();
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerEntityToJson(SearchDefaultHotBloggerEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['code'] = entity.code;
	data['data'] = entity.data?.toJson();
	data['hash'] = entity.hash;
	data['msg'] = entity.msg;
	data['time'] = entity.time;
	data['tip'] = entity.tip;
	return data;
}

searchDefaultHotBloggerDataFromJson(SearchDefaultHotBloggerData data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => SearchDefaultHotBloggerDataList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataToJson(SearchDefaultHotBloggerData entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

searchDefaultHotBloggerDataListFromJson(SearchDefaultHotBloggerDataList data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'].toString();
	}
	if (json['portrait'] != null) {
		data.portrait = json['portrait'].toString();
	}
	if (json['hasLocked'] != null) {
		data.hasLocked = json['hasLocked'];
	}
	if (json['hasBanned'] != null) {
		data.hasBanned = json['hasBanned'];
	}
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => SearchDefaultHotBloggerDataListList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListToJson(SearchDefaultHotBloggerDataList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['gender'] = entity.gender;
	data['portrait'] = entity.portrait;
	data['hasLocked'] = entity.hasLocked;
	data['hasBanned'] = entity.hasBanned;
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

searchDefaultHotBloggerDataListListFromJson(SearchDefaultHotBloggerDataListList data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['newsType'] != null) {
		data.newsType = json['newsType'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['tags'] != null) {
		data.tags = (json['tags'] as List).map((v) => SearchDefaultHotBloggerDataListListTags().fromJson(v)).toList();
	}
	if (json['sourceURL'] != null) {
		data.sourceURL = json['sourceURL'].toString();
	}
	if (json['playTime'] != null) {
		data.playTime = json['playTime'] is String
				? int.tryParse(json['playTime'])
				: json['playTime'].toInt();
	}
	if (json['cover'] != null) {
		data.cover = json['cover'].toString();
	}
	if (json['coverThumb'] != null) {
		data.coverThumb = json['coverThumb'].toString();
	}
	if (json['seriesCover'] != null) {
		data.seriesCover = (json['seriesCover'] as List).map((v) => v.toString()).toList().cast<String>();
	}
	if (json['playCount'] != null) {
		data.playCount = json['playCount'] is String
				? int.tryParse(json['playCount'])
				: json['playCount'].toInt();
	}
	if (json['purchaseCount'] != null) {
		data.purchaseCount = json['purchaseCount'] is String
				? int.tryParse(json['purchaseCount'])
				: json['purchaseCount'].toInt();
	}
	if (json['likeCount'] != null) {
		data.likeCount = json['likeCount'] is String
				? int.tryParse(json['likeCount'])
				: json['likeCount'].toInt();
	}
	if (json['commentCount'] != null) {
		data.commentCount = json['commentCount'] is String
				? int.tryParse(json['commentCount'])
				: json['commentCount'].toInt();
	}
	if (json['shareCount'] != null) {
		data.shareCount = json['shareCount'] is String
				? int.tryParse(json['shareCount'])
				: json['shareCount'].toInt();
	}
	if (json['coins'] != null) {
		data.coins = json['coins'] is String
				? int.tryParse(json['coins'])
				: json['coins'].toInt();
	}
	if (json['size'] != null) {
		data.size = json['size'] is String
				? int.tryParse(json['size'])
				: json['size'].toInt();
	}
	if (json['resolution'] != null) {
		data.resolution = json['resolution'].toString();
	}
	if (json['ratio'] != null) {
		data.ratio = json['ratio'] is String
				? double.tryParse(json['ratio'])
				: json['ratio'].toDouble();
	}
	if (json['status'] != null) {
		data.status = json['status'] is String
				? int.tryParse(json['status'])
				: json['status'].toInt();
	}
	if (json['reason'] != null) {
		data.reason = json['reason'].toString();
	}
	if (json['freeTime'] != null) {
		data.freeTime = json['freeTime'] is String
				? int.tryParse(json['freeTime'])
				: json['freeTime'].toInt();
	}
	if (json['isHideLocation'] != null) {
		data.isHideLocation = json['isHideLocation'];
	}
	if (json['freeArea'] != null) {
		data.freeArea = json['freeArea'];
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['reviewAt'] != null) {
		data.reviewAt = json['reviewAt'].toString();
	}
	if (json['isTopping'] != null) {
		data.isTopping = json['isTopping'];
	}
	if (json['isRecommend'] != null) {
		data.isRecommend = json['isRecommend'];
	}
	if (json['isChoosen'] != null) {
		data.isChoosen = json['isChoosen'];
	}
	if (json['rewarded'] != null) {
		data.rewarded = json['rewarded'].toString();
	}
	if (json['originCoins'] != null) {
		data.originCoins = json['originCoins'] is String
				? int.tryParse(json['originCoins'])
				: json['originCoins'].toInt();
	}
	if (json['publisher'] != null) {
		data.publisher = SearchDefaultHotBloggerDataListListPublisher().fromJson(json['publisher']);
	}
	if (json['location'] != null) {
		data.location = SearchDefaultHotBloggerDataListListLocation().fromJson(json['location']);
	}
	if (json['vidStatus'] != null) {
		data.vidStatus = SearchDefaultHotBloggerDataListListVidStatus().fromJson(json['vidStatus']);
	}
	if (json['comment'] != null) {
		data.comment = SearchDefaultHotBloggerDataListListComment().fromJson(json['comment']);
	}
	if (json['watch'] != null) {
		data.watch = SearchDefaultHotBloggerDataListListWatch().fromJson(json['watch']);
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListToJson(SearchDefaultHotBloggerDataListList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['newsType'] = entity.newsType;
	data['title'] = entity.title;
	data['tags'] =  entity.tags?.map((v) => v.toJson())?.toList();
	data['sourceURL'] = entity.sourceURL;
	data['playTime'] = entity.playTime;
	data['cover'] = entity.cover;
	data['coverThumb'] = entity.coverThumb;
	data['seriesCover'] = entity.seriesCover;
	data['playCount'] = entity.playCount;
	data['purchaseCount'] = entity.purchaseCount;
	data['likeCount'] = entity.likeCount;
	data['commentCount'] = entity.commentCount;
	data['shareCount'] = entity.shareCount;
	data['coins'] = entity.coins;
	data['size'] = entity.size;
	data['resolution'] = entity.resolution;
	data['ratio'] = entity.ratio;
	data['status'] = entity.status;
	data['reason'] = entity.reason;
	data['freeTime'] = entity.freeTime;
	data['isHideLocation'] = entity.isHideLocation;
	data['freeArea'] = entity.freeArea;
	data['createdAt'] = entity.createdAt;
	data['reviewAt'] = entity.reviewAt;
	data['isTopping'] = entity.isTopping;
	data['isRecommend'] = entity.isRecommend;
	data['isChoosen'] = entity.isChoosen;
	data['rewarded'] = entity.rewarded;
	data['originCoins'] = entity.originCoins;
	data['publisher'] = entity.publisher?.toJson();
	data['location'] = entity.location?.toJson();
	data['vidStatus'] = entity.vidStatus?.toJson();
	data['comment'] = entity.comment?.toJson();
	data['watch'] = entity.watch?.toJson();
	return data;
}

searchDefaultHotBloggerDataListListTagsFromJson(SearchDefaultHotBloggerDataListListTags data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['coverImg'] != null) {
		data.coverImg = json['coverImg'].toString();
	}
	if (json['description'] != null) {
		data.description = json['description'].toString();
	}
	if (json['playCount'] != null) {
		data.playCount = json['playCount'] is String
				? int.tryParse(json['playCount'])
				: json['playCount'].toInt();
	}
	if (json['hasCollected'] != null) {
		data.hasCollected = json['hasCollected'];
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListTagsToJson(SearchDefaultHotBloggerDataListListTags entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['coverImg'] = entity.coverImg;
	data['description'] = entity.description;
	data['playCount'] = entity.playCount;
	data['hasCollected'] = entity.hasCollected;
	return data;
}

searchDefaultHotBloggerDataListListPublisherFromJson(SearchDefaultHotBloggerDataListListPublisher data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['gender'] != null) {
		data.gender = json['gender'].toString();
	}
	if (json['portrait'] != null) {
		data.portrait = json['portrait'].toString();
	}
	if (json['hasLocked'] != null) {
		data.hasLocked = json['hasLocked'];
	}
	if (json['hasBanned'] != null) {
		data.hasBanned = json['hasBanned'];
	}
	if (json['vipLevel'] != null) {
		data.vipLevel = json['vipLevel'] is String
				? int.tryParse(json['vipLevel'])
				: json['vipLevel'].toInt();
	}
	if (json['isVip'] != null) {
		data.isVip = json['isVip'];
	}
	if (json['rechargeLevel'] != null) {
		data.rechargeLevel = json['rechargeLevel'] is String
				? int.tryParse(json['rechargeLevel'])
				: json['rechargeLevel'].toInt();
	}
	if (json['superUser'] != null) {
		data.superUser = json['superUser'] is String
				? int.tryParse(json['superUser'])
				: json['superUser'];
	}
	if (json['activeValue'] != null) {
		data.activeValue = json['activeValue'] is String
				? int.tryParse(json['activeValue'])
				: json['activeValue'].toInt();
	}
	if (json['officialCert'] != null) {
		data.officialCert = json['officialCert'];
	}
	if (json['age'] != null) {
		data.age = json['age'] is String
				? int.tryParse(json['age'])
				: json['age'].toInt();
	}
	if (json['follows'] != null) {
		data.follows = json['follows'] is String
				? int.tryParse(json['follows'])
				: json['follows'].toInt();
	}
	if (json['fans'] != null) {
		data.fans = json['fans'] is String
				? int.tryParse(json['fans'])
				: json['fans'].toInt();
	}
	if (json['summary'] != null) {
		data.summary = json['summary'].toString();
	}
	if (json['hasFollowed'] != null) {
		data.hasFollowed = json['hasFollowed'];
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListPublisherToJson(SearchDefaultHotBloggerDataListListPublisher entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['gender'] = entity.gender;
	data['portrait'] = entity.portrait;
	data['hasLocked'] = entity.hasLocked;
	data['hasBanned'] = entity.hasBanned;
	data['vipLevel'] = entity.vipLevel;
	data['isVip'] = entity.isVip;
	data['rechargeLevel'] = entity.rechargeLevel;
	data['superUser'] = entity.superUser;
	data['activeValue'] = entity.activeValue;
	data['officialCert'] = entity.officialCert;
	data['age'] = entity.age;
	data['follows'] = entity.follows;
	data['fans'] = entity.fans;
	data['summary'] = entity.summary;
	data['hasFollowed'] = entity.hasFollowed;
	return data;
}

searchDefaultHotBloggerDataListListLocationFromJson(SearchDefaultHotBloggerDataListListLocation data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['cover'] != null) {
		data.cover = json['cover'].toString();
	}
	if (json['visit'] != null) {
		data.visit = json['visit'] is String
				? int.tryParse(json['visit'])
				: json['visit'].toInt();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListLocationToJson(SearchDefaultHotBloggerDataListListLocation entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['city'] = entity.city;
	data['cover'] = entity.cover;
	data['visit'] = entity.visit;
	data['createdAt'] = entity.createdAt;
	return data;
}

searchDefaultHotBloggerDataListListVidStatusFromJson(SearchDefaultHotBloggerDataListListVidStatus data, Map<String, dynamic> json) {
	if (json['hasLiked'] != null) {
		data.hasLiked = json['hasLiked'];
	}
	if (json['hasPaid'] != null) {
		data.hasPaid = json['hasPaid'];
	}
	if (json['hasCollected'] != null) {
		data.hasCollected = json['hasCollected'];
	}
	if (json['todayRank'] != null) {
		data.todayRank = json['todayRank'] is String
				? int.tryParse(json['todayRank'])
				: json['todayRank'].toInt();
	}
	if (json['todayPlayCnt'] != null) {
		data.todayPlayCnt = json['todayPlayCnt'] is String
				? int.tryParse(json['todayPlayCnt'])
				: json['todayPlayCnt'].toInt();
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListVidStatusToJson(SearchDefaultHotBloggerDataListListVidStatus entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['hasLiked'] = entity.hasLiked;
	data['hasPaid'] = entity.hasPaid;
	data['hasCollected'] = entity.hasCollected;
	data['todayRank'] = entity.todayRank;
	data['todayPlayCnt'] = entity.todayPlayCnt;
	return data;
}

searchDefaultHotBloggerDataListListCommentFromJson(SearchDefaultHotBloggerDataListListComment data, Map<String, dynamic> json) {
	if (json['uid'] != null) {
		data.uid = json['uid'] is String
				? int.tryParse(json['uid'])
				: json['uid'].toInt();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['portrait'] != null) {
		data.portrait = json['portrait'].toString();
	}
	if (json['cid'] != null) {
		data.cid = json['cid'].toString();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['likeCount'] != null) {
		data.likeCount = json['likeCount'] is String
				? int.tryParse(json['likeCount'])
				: json['likeCount'].toInt();
	}
	if (json['isAuthor'] != null) {
		data.isAuthor = json['isAuthor'];
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListCommentToJson(SearchDefaultHotBloggerDataListListComment entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['uid'] = entity.uid;
	data['name'] = entity.name;
	data['portrait'] = entity.portrait;
	data['cid'] = entity.cid;
	data['content'] = entity.content;
	data['likeCount'] = entity.likeCount;
	data['isAuthor'] = entity.isAuthor;
	data['createdAt'] = entity.createdAt;
	return data;
}

searchDefaultHotBloggerDataListListWatchFromJson(SearchDefaultHotBloggerDataListListWatch data, Map<String, dynamic> json) {
	if (json['watchCount'] != null) {
		data.watchCount = json['watchCount'] is String
				? int.tryParse(json['watchCount'])
				: json['watchCount'].toInt();
	}
	if (json['isWatch'] != null) {
		data.isWatch = json['isWatch'];
	}
	if (json['isFreeWatch'] != null) {
		data.isFreeWatch = json['isFreeWatch'];
	}
	return data;
}

Map<String, dynamic> searchDefaultHotBloggerDataListListWatchToJson(SearchDefaultHotBloggerDataListListWatch entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['watchCount'] = entity.watchCount;
	data['isWatch'] = entity.isWatch;
	data['isFreeWatch'] = entity.isFreeWatch;
	return data;
}