import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_app/model/country_code_entity.dart';

///获取城市列表
Future<List<CountryCodeList>> getCountryCodes() async {
  String jsonString =
      await rootBundle.loadString("assets/json/country_code.json");
  Map<String, dynamic> jsonResultList = json.decode(jsonString);
  CountryCodeEntity codeEntity = CountryCodeEntity().fromJson(jsonResultList);
  return codeEntity?.xList ?? [];
}
