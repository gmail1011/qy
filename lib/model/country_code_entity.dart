import 'package:flutter_app/generated/json/base/json_convert_content.dart';
import 'package:flutter_app/generated/json/base/json_field.dart';

class CountryCodeEntity with JsonConvert<CountryCodeEntity> {
  @JSONField(name: "list")
  List<CountryCodeList> xList;
}

class CountryCodeList with JsonConvert<CountryCodeList> {
  String city;
  String code;
}
