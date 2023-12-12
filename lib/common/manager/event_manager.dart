/// 初始加载调用通知
class LoadOriginEvent {
  ///  1:首页点击刷新  2: 刷新完成，关闭首页动画、 3 暂停推荐播放器 4、打开推荐播放器  5 刷新后延迟发送 初始化播放
  final int type;
  final String videoID;
  LoadOriginEvent(this.type, {this.videoID});
}

/// 聊吧加载调用通知
class PostLoadOriginEvent {
  ///  1:首页点击刷新  2: 刷新完成，关闭首页动画、
  final int type;
  PostLoadOriginEvent(this.type);
}

/// 首页底部tab切换
class HomeBottomTagChange {
  final int index;
  HomeBottomTagChange(this.index);
}

/// 首页底部我的小红点
class HomeMineUnReadChange {}
