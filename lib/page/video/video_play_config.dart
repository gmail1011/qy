
///二级播放列表加载更多属性配置类
class VideoPlayConfig {

  /// 同城
  static const int VIDEO_TYPE_NEARBY = 1;

  /// 城市（只播放当前视频，无须请求）
  static const int VIDEO_CITY_PLAY = 9;

  /// 专题 + 标签
  static const int VIDEO_TAG = 2;

  /// 搜索首页【热点】（固定数量显示，无须请求）
  static const int VIDEO_TYPE_HOT = 10;

  /// 搜索首页【今日热门视频】（固定数量显示，无须请求）
  static const int VIDEO_TYPE_TODAY_HOT = 6;

  /// 搜索首页【发现精彩】
  static const int VIDEO_FIND = 12;

  /// 更多搜索【视频】
  static const int VIDEO_MORE_SEARCH = 13;

  /// 搜索首页【今日最热视频榜单】 （注意：分页数据要比实际少1）
  static const int VIDEO_DAY_HOT_RANK = 14;

  ///帖子
  static const int VIDEO_POST = 15;


  ///我（他）的作品
  static const int VIDEO_TYPE_WORKS = 3;

  ///我（他）的购买
  static const int VIDEO_TYPE_BUY = 11;

  ///我（他）的喜欢
  static const int VIDEO_TYPE_ENDORSE = 5;

  ///我（他）的收藏
  static const int VIDEO_TYPE_COLLECT = 4;

  /// 搜索首页【专区】 待定接口还未用对
  static const int VIDEO_TYPE_ZONE = 7;

  //=============热搜榜 begin================
  /// 热搜榜 - 【发现精彩】
  static const int HOT_VIDEO_FIND = 100;
  //============热搜榜 end=================


}