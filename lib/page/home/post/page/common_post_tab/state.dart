import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/page/common_post/detail/SelectedBean.dart';
import 'package:flutter_app/page/home/post/page/common_post_detail/SelectedTagsBean.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'SelectedTagsDetailBean.dart';

class CommonPostTagsState extends MutableSource with EagleHelper implements Cloneable<CommonPostTagsState> {
  int pageNumber = 1;
  int pageSize = 20;
  String type;
  String subType;

  List<PostItemState> dayItems = []; //保存item的state

  List<TagsDetailDataSections> tagsDetails = []; //保存item的state

  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();

  String reqDate;

  bool showToTopBtn = false;


  List<AdsInfoBean> adsList = [];


  int index = -1;

  // 初始化标签数据
  List<VideoModel> initList;


  String selectedType = "全部类型";
  List<String> typeOptions = [
    '全部类型',
    '长视频',
    '短视频',
  ];


  String selectedSort  = "热门推荐";
  List<String> sortOptions = [
    '热门推荐',
    '最多播放',
    '收藏最多',
    "最新上架"
  ];

  SelectedTagsDetailBean selectedBean = new SelectedTagsDetailBean();

  SelectedTagsData selectedTagsData;

  bool isLoading = false;



  @override
  CommonPostTagsState clone() {
    return CommonPostTagsState()
      ..tagsDetails = tagsDetails
      ..baseRequestController = baseRequestController
      ..refreshController = refreshController
      ..initList = initList
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..type = type
      ..subType = subType
      ..reqDate = reqDate
      ..adsList = adsList
      ..index = index
      ..showToTopBtn = showToTopBtn

      ..selectedType = selectedType
      ..typeOptions = typeOptions
      ..selectedSort = selectedSort
      ..sortOptions = sortOptions
      ..selectedBean = selectedBean

      ..isLoading = isLoading
      ..selectedTagsData = selectedTagsData
    ;
  }

  @override
  Object getItemData(int index) {
    return dayItems[index];
  }

  @override
  String getItemType(int index) {
    return 'post_item';
  }

  @override
  int get itemCount => dayItems.length;

  @override
  void setItemData(int index, Object data) {
    dayItems[index] = data;
  }

}

CommonPostTagsState initState(Map<String, dynamic> args) {
  var type = args["type"];
  var subType = args["subType"];
  assert(type != null);
  return CommonPostTagsState()
    ..type = type
    ..initList = args['initList']
    ..adsList = args['adsList']
    ..index = args['index']
    ..subType = subType;
}
