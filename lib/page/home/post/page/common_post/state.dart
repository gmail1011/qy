import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/page/common_post/Bean.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommonPostState extends MutableSource
    with EagleHelper
    implements Cloneable<CommonPostState> {
  int pageNumber = 1;
  int pageSize = 40;
  String type;
  String subType;

  List<PostItemState> dayItems = []; //保存item的state

  List<TagsDetailDataSections> specialModels;

  RefreshController refreshController = RefreshController();
  BaseRequestController baseRequestController = BaseRequestController();

  String reqDate;

  bool showToTopBtn = false;

  List<AdsInfoBean> adsList = [];

  List<ListBeanSp> list = List();

  // 初始化标签数据
  List<VideoModel> initList;

  List<Bean> iconLists = [
    Bean("assets/images/liaoba_fuli_icon2.png", "福利"),
    Bean("assets/images/liaoba_chongzhi_icon2.png", "VIP充值"),
    Bean("assets/images/liaoba_game_icon2.png", "游戏"),
    Bean("assets/images/liaoba_lou_feng_icon2.png", "楼凤"),
    Bean("assets/images/liaoba_av_jieshuo_icon2.png", "AV解说"),
    Bean("assets/images/liaoba_can_sai_shiping2.png", "参赛视频"),
    Bean("assets/images/liaoba_luoliao_icon2.png", "裸聊"),
    Bean("assets/images/liaoba_redian_icon2.png", "全民代理"),
  ];

  SelectedTagsData selectedTagsData;

  int dailyDataPageNum = 1;

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
      ..dailyDataPageNum = dailyDataPageNum
      ..iconLists = iconLists
      ..selectedTagsData = selectedTagsData
      ..specialModels = specialModels
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
