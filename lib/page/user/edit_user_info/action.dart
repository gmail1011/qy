import 'package:fish_redux/fish_redux.dart';

enum EditUserInfoAction {
  refresh,
  onEditName,
  onEditSummary,
  onEditGender,
  onEditBirthday,
  onEditCity,
  onEditAvatar,
  changePhoto,
  clearCacheData,
}

class EditUserInfoActionCreator {
  static Action onRefresh() {
    return const Action(EditUserInfoAction.refresh);
  }

  static Action onEditName(String name) {
    return Action(EditUserInfoAction.onEditName, payload: name);
  }

  static Action onEditSummary(String summary) {
    return Action(EditUserInfoAction.onEditSummary, payload: summary);
  }

  static Action onEditGender(String gender) {
    return Action(EditUserInfoAction.onEditGender, payload: gender);
  }

  static Action onEditBirthday(String birthday) {
    return Action(EditUserInfoAction.onEditBirthday, payload: birthday);
  }

  static Action onEditCity(String city) {
    return Action(EditUserInfoAction.onEditCity, payload: city);
  }

  static Action onEditAvatar(String localPath) {
    return Action(EditUserInfoAction.onEditAvatar, payload: localPath);
  }

  static Action onChangePhoto(String localPath) {
    return Action(EditUserInfoAction.changePhoto, payload: localPath);
  }

  static Action onClearCacheData() {
    return const Action(EditUserInfoAction.clearCacheData);
  }
}
