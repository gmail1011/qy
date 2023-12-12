import '../tabs_tag_entity.dart';

class TagsListModel {
  TagsListModel();

  TagsListModel.fromJson(dynamic json) {
    if (json['homePage'] != null) {
      homePage = [];
      json['homePage'].forEach((v) {
        homePage.add(TabsTagData().fromJson(v));
      });
    }
    if (json['community'] != null) {
      community = [];
      json['community'].forEach((v) {
        community.add(TabsTagData().fromJson(v));
      });
    }
    if (json['deepWeb'] != null) {
      deepWeb = [];
      json['deepWeb'].forEach((v) {
        deepWeb.add(TabsTagData().fromJson(v));
      });
    }
  }
  List<TabsTagData> homePage;
  List<TabsTagData> community;
  List<TabsTagData> deepWeb;

}