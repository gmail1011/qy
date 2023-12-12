//	"id": "5db9412c2b4f29967defd7e2",
// 	"city": "深圳",
// 	"hot": 4,
// 	"visit": 0
///热门城市
class NewHotCity {
  String id;
  String city;
  String province;
  int hot;
  int visit;

  NewHotCity({this.id, this.city, this.province, this.hot, this.visit});

  NewHotCity.fromJson(Map<String, dynamic> map) {
    this.id = map['id'] ?? "";
    this.city = map['city'] ?? "";
    this.province = map['province'] ?? "";
    this.hot = map['hot'] ?? 0;
    this.visit = map['visit'] ?? 0;
  }

  @override
  String toString() {
    return '{$id, $city, $province, $hot, $visit}';
  }
}
