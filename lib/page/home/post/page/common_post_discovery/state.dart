import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommonPostState extends MutableSource
    with EagleHelper
    implements Cloneable<CommonPostState> {
  int pageNumber = 1;
  int pageSize = 20;
  String type;
  String subType;

  List<PostItemState> dayItems = []; //保存item的state

  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();

  String reqDate;

  bool showToTopBtn = false;


  List<AdsInfoBean> adsList = [];


  List<ListBeanSp> list = List();


  TagsLiaoBaData tags = new TagsLiaoBaData();

  int tagIndex = 0;

  List<TagBean> tagDetailList = [];

  TagBean tageBean = new TagBean();


  //TagsLiaoBaDataTags tageBean = TagsLiaoBaDataTags();

  // 初始化标签数据
  List<VideoModel> initList;
  @override
  CommonPostState clone() {
    return CommonPostState()
      ..dayItems = dayItems
      ..baseRequestController = baseRequestController
      ..refreshController = refreshController
      ..initList = initList
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..type = type
      ..subType = subType
      ..reqDate = reqDate
      ..adsList = adsList
      ..list = list
      ..tags = tags
      ..tagIndex = tagIndex
      ..tageBean = tageBean
      ..tagDetailList = tagDetailList
      ..showToTopBtn = showToTopBtn;
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

CommonPostState initState(Map<String, dynamic> args) {
  var type = args["type"];
  var subType = args["subType"];
  assert(type != null);
  return CommonPostState()
    ..type = type
    ..initList = args['initList']
    ..adsList = args['adsList']
    ..subType = subType;
}
