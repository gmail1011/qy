import 'package:flutter_app/model/announcement_entity.dart';

announcementEntityFromJson(AnnouncementEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id'].toString();
	}
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['location'] != null) {
		data.location = json['location'] is String
				? int.tryParse(json['location'])
				: json['location'].toInt();
	}
	if (json['content'] != null) {
		data.content = json['content'].toString();
	}
	if (json['isActive'] != null) {
		data.isActive = json['isActive'];
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt'].toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt'].toString();
	}
	return data;
}

Map<String, dynamic> announcementEntityToJson(AnnouncementEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['type'] = entity.type;
	data['location'] = entity.location;
	data['content'] = entity.content;
	data['isActive'] = entity.isActive;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}