import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  
  static SharedPreferences _prefs;

  static setValueByKey(String key, dynamic data) async{
    await _getSharedPreferences();
    switch (data.runtimeType.toString()) {
      case 'String':
        _prefs.setString(key, data);
        break;
      case 'int':
        _prefs.setInt(key, data);
        break;
      case 'bool':
        _prefs.setBool(key, data);
        break;
      case 'double':
        _prefs.setDouble(key, data);
        break;
      case 'List<String>':
        _prefs.setStringList(key, data);
        break;
      default:
        print('数据类型不正确！');
    }
  }

  static Future<SharedPreferences> _getSharedPreferences() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }
}
