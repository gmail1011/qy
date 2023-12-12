import 'package:fish_redux/fish_redux.dart';

enum H5PluginAction {
  returnAction,
  backAction,
  loadH5PluginAction,
  onOpenPermission,
  savePhotoAlbum,
  updateTitle
}

class H5PluginActionCreator {
  static Action onReturnAction() {
    return const Action(H5PluginAction.returnAction);
  }

  /// 保存图片到相册
  static Action savePhotoAlbum(String url) {
    return Action(H5PluginAction.savePhotoAlbum, payload: url);
  }

  static Action onBackAction() {
    return const Action(H5PluginAction.backAction);
  }

  static Action onOpenPermission() {
    return const Action(H5PluginAction.onOpenPermission);
  }

  static Action updateTitle(String titleName) {
    return Action(H5PluginAction.updateTitle, payload: titleName);
  }
}
