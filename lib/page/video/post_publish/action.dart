import 'package:fish_redux/fish_redux.dart';

enum PostPublishAction {
  onConfigCity,
  onConfigPrice,
  onInitTags,
  onAddTag,
  onCameraVideo,
  onPublishPost,
  onBack,
  refreshUI,
}

class PostPublishActionCreator {
  ///添加标签
  static Action onAddPost() {
    return const Action(PostPublishAction.onAddTag);
  }

  ///获取标签列表（本地+网络）
  static Action onInitTags() {
    return const Action(PostPublishAction.onInitTags);
  }

  ///选择城市
  static Action onConfigCity() {
    return const Action(PostPublishAction.onConfigCity);
  }

  ///配置价格和免费时长
  static Action onConfigPrice() {
    return const Action(PostPublishAction.onConfigPrice);
  }

  ///进入拍摄界面
  static Action onCameraVideo() {
    return const Action(PostPublishAction.onCameraVideo);
  }

  ///发布贴子
  static Action onPublishPost() {
    return const Action(PostPublishAction.onPublishPost);
  }

  ///退出界面
  static Action onBack() {
    return const Action(PostPublishAction.onBack);
  }

  static Action refreshUI() {
    return const Action(PostPublishAction.refreshUI);
  }
}
