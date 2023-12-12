import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';
import 'package:flutter_base/utils/log.dart';

import 'abs_video_list_model.dart';

/// 关注页面共享数据模型，不才用GlobalStore的形式
class FollowListModel extends AbsVideoListModel {
  @override
  Future<RecommendListRes> getNetData(int page) async {
    RecommendListRes resp;
    try {
      resp = await netManager.client.getFollowList(page);
    } catch (e) {
      l.e(tag, "loadMoreRecommendList()...");
    }
    return resp;
  }
}
