import 'package:flutter_app/model/country_code_entity.dart';

countryCodeEntityFromJson(CountryCodeEntity data, Map<String, dynamic> json) {
	if (json['list'] != null) {
		data.xList = (json['list'] as List).map((v) => CountryCodeList().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> countryCodeEntityToJson(CountryCodeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['list'] =  entity.xList?.map((v) => v.toJson())?.toList();
	return data;
}

countryCodeListFromJson(CountryCodeList data, Map<String, dynamic> json) {
	if (json['city'] != null) {
		data.city = json['city'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'].toString();
	}
	return data;
}

Map<String, dynamic> countryCodeListToJson(CountryCodeList entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['city'] = entity.city;
	data['code'] = entity.code;
	return data;
}