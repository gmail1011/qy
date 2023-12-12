import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'SelectedTagsBean.dart';

class CommonPostDetailState implements Cloneable<CommonPostDetailState> {

  String selectedType = "全部类型";
  List<String> typeOptions = [
    '全部类型',
    '长视频',
    '短视频',
  ];


  String selectedSort  = "最新上架";
  List<String> sortOptions = [
    '最新上架',
    '最多播放',
    '点赞最多',
    '热门推荐',
  ];



  String selectedTags = "全部标签";
  List<String> tagsOptions = [];


  String selectedVipGold = "付费类型";
  List<String> vipGoldOptions = [
    '付费类型',
    'VIP',
    '金币',
  ];


  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();


  TagsLiaoBaData specialModel;

  int pageNumber = 1;

  int pageSize = 10;

  SelectedTagsData selectedTagsData;


  SelectedTagsBean selectedTagsBean = new SelectedTagsBean();

  bool selectedTagsEmpty = false;

  bool isLoading = false;


  @override
  CommonPostDetailState clone() {
    return CommonPostDetailState()
      ..selectedType = selectedType
      ..typeOptions = typeOptions
      ..selectedSort = selectedSort
      ..sortOptions = sortOptions
      ..selectedTags = selectedTags
      ..tagsOptions = tagsOptions
      ..selectedVipGold = selectedVipGold
      ..vipGoldOptions = vipGoldOptions
      ..refreshController = refreshController
      ..baseRequestController = baseRequestController
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..isLoading = isLoading
      ..specialModel = specialModel
      ..selectedTagsData = selectedTagsData
      ..selectedTagsBean = selectedTagsBean
      ..selectedTagsEmpty = selectedTagsEmpty
    ;
  }
}

CommonPostDetailState initState(Map<String, dynamic> args) {
  return CommonPostDetailState();
}
