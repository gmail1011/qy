import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_detail_entity.dart';

aVCommentaryDetailEntityFromJson(AVCommentaryDetailEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	if (json['desc'] != null) {
		data.desc = json['desc'].toString();
	}
	if (json['videoInfo'] != null) {
		data.videoInfo = json['videoInfo'].toString();
	}
	if (json['period'] != null) {
		data.period = json['period'] is String
				? int.tryParse(json['period'])
				: json['period'].toInt();
	}
	if (json['cover'] != null) {
		data.cover = json['cover'].toString();
	}
	if (json['sourceID'] != null) {
		data.sourceID = json['sourceID'].toString();
	}
	if (json['sourceURL'] != null) {
		data.sourceURL = json['sourceURL'].toString();
	}
	if (json['price'] != null) {
		data.price = json['price'] is String
				? int.tryParse(json['price'])
				: json['price'].toInt();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['graphic'] != null) {
		data.graphic = json['graphic'].toString();
	}
	if (json['isBuy'] != null) {
		data.isBuy = json['isBuy'];
	}
	if (json['isLike'] != null) {
		data.isLike = json['isLike'];
	}
	if (json['isFavorites'] != null) {
		data.isFavorites = json['isFavorites'];
	}
	if (json['readCount'] != null) {
		data.readCount = json['readCount'] is String
				? int.tryParse(json['readCount'])
				: json['readCount'].toInt();
	}
	if (json['likeCount'] != null) {
		data.likeCount = json['likeCount'] is String
				? int.tryParse(json['likeCount'])
				: json['likeCount'].toInt();
	}
	if (json['favoritesCount'] != null) {
		data.favoritesCount = json['favoritesCount'] is String
				? int.tryParse(json['favoritesCount'])
				: json['favoritesCount'].toInt();
	}
	return data;
}

Map<String, dynamic> aVCommentaryDetailEntityToJson(AVCommentaryDetailEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['desc'] = entity.desc;
	data['videoInfo'] = entity.videoInfo;
	data['period'] = entity.period;
	data['cover'] = entity.cover;
	data['sourceID'] = entity.sourceID;
	data['sourceURL'] = entity.sourceURL;
	data['price'] = entity.price;
	data['createdAt'] = entity.createdAt;
	data['graphic'] = entity.graphic;
	data['isBuy'] = entity.isBuy;
	data['isLike'] = entity.isLike;
	data['isFavorites'] = entity.isFavorites;
	data['readCount'] = entity.readCount;
	data['likeCount'] = entity.likeCount;
	data['favoritesCount'] = entity.favoritesCount;
	return data;
}