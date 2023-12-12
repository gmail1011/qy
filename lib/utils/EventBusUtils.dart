import 'dart:async';

typedef void EventCallback(arg);

class EventBusUtils {

  static final String reFreshUrl = "reFreshUrl";
  static final String reloadUrl = "reloadUrl";
  static final String isClose = "isClose";
  static final String showFloating = "showFloating";
  static final String closeFloating = "closeFloating";


  static final String showActivityFloating = "showActivityFloating";
  static final String closeActivityFloating = "closeActivityFloating";

  static final String startEditLikeCollectList = "startEditLikeCollectList";

  static final String avCommentary = "av_commentaryPage";
  static final String gamePage = "gamePage";
  static final String louFengPage = "louFengPage";
  static final String souye = "SouYe";
  static final String sheQu = "sheQu";
  static final String flPage1 = "fuli_page1";
  static final String avCommentaryInsufficientBalance = "avCommentaryInsufficientBalance";


  static final String memberlongvideo = "memberlongvideo";



  static final String openDrawer = "openDrawer";

  static final String resetNakeChat = "resetNakeChat";
  static final String queryNakeChat = "queryNakeChat";

  static final String jumpWalletFromNakeChat = "jumpWalletFromNakeChat";

  static final String hideAudioBook = "hideAudioBook";

  static final String refreshComeent = "refreshComeent";

  static final String refreshComeentFinishNoData = "refreshComeentFinishNoData";

  static final String refreshComeentFinish = "refreshComeentFinish";

  static final String refreshCommunity = "refreshCommunity";

  static final String buySuccess = "buySuccess";

  static final String refreshFollowStatus = "refreshFollowStatus";

  static final String refreshRecommendFollowStatus = "refreshRecommendFollowStatus";


  static final String pausePlayer = "pausePlayer";



  static final String clearUploadData = "clearUploadData";

  static final String showCommentInput = "showCommentInput";

  static final String changeHotListTab = "changeHotListTab";

  static final String changeAITemple = "changeAITemple";

  static final String changeEditStatus = "changeEditStatus";
  static final String delVideoCache = "delVideoCache";
  static final String delVideoCollect = "delVideoCollect";

  //私有构造函数
  EventBusUtils._internal();

  //保存单例
  static EventBusUtils _singleton = new EventBusUtils._internal();

  //工厂构造函数
  factory EventBusUtils() => _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  var _emap = new Map<Object, List<EventCallback>>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _emap[eventName] ??= new List<EventCallback>();
    _emap[eventName].add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  void clear() {}

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

var bus = new EventBusUtils();
