import 'dart:io';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/tasks/image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'action.dart';
import 'state.dart';

Effect<EditUserInfoState> buildEffect() {
  return combineEffects(<Object, Effect<EditUserInfoState>>{
    Lifecycle.initState: _initState,
    EditUserInfoAction.onEditSummary: _editSummary,
    EditUserInfoAction.onEditGender: _editGender,
    EditUserInfoAction.onEditBirthday: _editBirthday,
    EditUserInfoAction.onEditCity: _editCity,
    EditUserInfoAction.onEditAvatar: _editAvatar,
    EditUserInfoAction.clearCacheData: _clearCacheData,
  });
}

void _initState(Action action, Context<EditUserInfoState> ctx) async {
  String _size = await loadCache();
  ctx.state.cacheSize = _size;
  ctx.dispatch(EditUserInfoActionCreator.onRefresh());
}

void _editAvatar(Action action, Context<EditUserInfoState> ctx) async {
  var filePathNew = action.payload;

  //先直接本地设置头像
  ctx.dispatch(EditUserInfoActionCreator.onChangePhoto(filePathNew));
  //如果上传资源或者服务器返回有失败在换回原来图片并提示更换失败
  var result = await uploadAvatar(filePathNew, {});
  var result1 = await _setAvatar(action, ctx, result);
  if (result1 == null) {
    // 失败返回原来的头像
    ctx.state.tempPhoto = '';
    ctx.dispatch(EditUserInfoActionCreator.onRefresh());
    // showToast(msg: Lang.headFailed);
  }
}

/// 修改用户头像
_setAvatar(Action action, Context<EditUserInfoState> ctx,
    Map<String, dynamic> params) async {
  Map<String, dynamic> editInfo = {
    'portrait': params['cover'],
  };
  var userInfo = await GlobalStore.updateUserInfo(editInfo);
  if (null != userInfo) {
    showToast(msg: "更新成功");
  }
  return userInfo;
}

/// 修改用户简介
void _editSummary(Action action, Context<EditUserInfoState> ctx) async {
  Map<String, dynamic> editInfo = {
    'summary': action.payload,
  };
  var userInfo = await GlobalStore.updateUserInfo(editInfo);
  if (null != userInfo) {
    showToast(msg: "更新成功");
  }
  ctx.dispatch(EditUserInfoActionCreator.onRefresh());
}

/// 修改用户性别
void _editGender(Action action, Context<EditUserInfoState> ctx) async {
  Map<String, dynamic> editInfo = {
    'gender': action.payload,
  };
  var userInfo = await GlobalStore.updateUserInfo(editInfo);
  if (null != userInfo) {
    showToast(msg: "更新性别成功");
  }
  ctx.dispatch(EditUserInfoActionCreator.onRefresh());
}

/// 修改用户生日
void _editBirthday(Action action, Context<EditUserInfoState> ctx) async {
  Map<String, dynamic> editInfo = {
    'birthday': action.payload,
  };
  var userInfo = await GlobalStore.updateUserInfo(editInfo);
  if (null != userInfo) {
    showToast(msg: "更新成功");
  }
  ctx.dispatch(EditUserInfoActionCreator.onRefresh());
}

/// 修改用户地区
void _editCity(Action action, Context<EditUserInfoState> ctx) async {
  Map<String, dynamic> editInfo = {
    'region': action.payload,
  };
  var userInfo = await GlobalStore.updateUserInfo(editInfo);
  if (null != userInfo) {
    showToast(msg: "更新成功");
  }
  ctx.dispatch(EditUserInfoActionCreator.onRefresh());
}

Future<Map<String, dynamic>> uploadAvatar(
    String localPath, Map<String, dynamic> params) async {
  //压缩图片
  if (!Platform.isAndroid) {
    var file = File(localPath);
    var size = await file.readAsBytes();
    if ((size.length / 1024) > 300) {
      var compressFile = await FlutterNativeImage.compressImage(localPath,
          percentage: 40, quality: 50);
      localPath = compressFile.path;
    }
  }

  var model = await taskManager.addTaskToQueue(ImageUploadTask(localPath));

  if (model != null) {
    params['cover'] = model.coverImg;
    params['coverThumb'] = model.coverImg;
  } else {
    showToast(msg: "上传头像异常了");
  }

  return params;
}

///清除缓存数据
void _clearCacheData(Action action, Context<EditUserInfoState> ctx) async {
  await clearCacheIfNeed(force: true);
  String _size = await loadCache();
  ctx.state.cacheSize = _size;
  ctx.dispatch(EditUserInfoActionCreator.onRefresh());
  showToast(msg: Lang.CLEAN_CACHE_SUCCESS);
}
