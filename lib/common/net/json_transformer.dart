import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

parseJSON(String string) => json.decode(string);

Future _computeJSON(String source) {
  return compute(parseJSON, source);
}

class JSONTransformer extends DefaultTransformer {
  JSONTransformer() : super(jsonDecodeCallback: _computeJSON);
}
