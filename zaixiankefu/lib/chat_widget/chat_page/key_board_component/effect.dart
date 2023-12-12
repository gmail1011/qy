import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/sound_helper.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../chat_core/network/connection/connect_util.dart';

import '../../chat_core/pkt/pb.pb.dart';
import '../List_component/action.dart';
import '../action.dart';
import '../utils/util.dart';
import 'package:dio/dio.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:fixnum/fixnum.dart';
import 'action.dart';
import 'state.dart';

Effect<KeyBoardState> buildEffect() {
  return combineEffects(<Object, Effect<KeyBoardState>>{
    KeyBoardAction.action: _onAction,
    KeyBoardAction.upPicAction: _onUpPic,
    KeyBoardAction.sendMsg: _onSendMsg,
    KeyBoardAction.startInput: _onStartInput,
    KeyBoardAction.dontTalk: _onNoTalk,
    Lifecycle.dispose: _dispose,
    KeyBoardAction.recordVoice: _onRecordVoice,
    KeyBoardAction.stopRecord: _stopRecord,
    KeyBoardAction.voiceUp: _onVoiceUp,
  });
}

Future<String> fpath;
int voiceTime = 0;

void _onAction(Action action, Context<KeyBoardState> ctx) {}

void _stopRecord(Action action, Context<KeyBoardState> ctx) {
  sound_helper.stopRecorder();
  if (fpath != null) {
    fpath?.then((path) {
      // FIXME 如果取消该怎么拦截这里的回调
      print('recored end path:$path');
      var uri = Uri.parse(path);
      var absPath = uri.path;
      print("absPath---$absPath");
      fpath = null;
      // MsgInfo mi = MsgInfo();
      // mi.msgType(MessageType.MessageTypeAudio);
      // mi.localPath = absPath;
      // mi.msgContent = sound_helper.recorderTime;
      // // sound_helper.ge
      // ctx.dispatch(ChatPageActionCreator.onSendMsgAction(mi));
      ctx.dispatch(KeyBoardActionCreator.onVoiceUp(absPath));
    });
  }
}

///记录语音
void _onRecordVoice(Action action, Context<KeyBoardState> ctx) async {
  bool permission = await Permission.microphone.isGranted;

  if (!permission) {
    print(">>>>>>>>>>>>>>>>>>_onRecordVoice 开始请求权限");
    var isGranted = await Permission.microphone.request().isGranted;
    if (!isGranted) {
      await openAppSettings();
      return;
    }

    return;
  }

  voiceTime = 0;
  // sound_helper.stopPlayer();
  ctx.dispatch(ChatActionCreator.onRecordUI('松开手指，立即发送'));
  fpath = null;
  fpath = sound_helper.startRecorder((time) {
    if (time >= 60) {
      // sound_helper.stopPlayer();
      voiceTime = 60;
      ctx.dispatch(KeyBoardActionCreator.onStopRecord());
    } else {
      voiceTime = time;
    }
  }, dbPeak: (value) {
    print('--------+++++++++++++$value');
  });
}

// 用户开始输入
void _onStartInput(Action action, Context<KeyBoardState> ctx) async {
  BaseMessage baseMessage = BaseMessage.create();
  baseMessage.action = 1012;
  baseMessage.data = (EnterStatus.create()
        ..senderId = await obtainValueByKey('id') ?? ''
        ..targetId = await obtainValueByKey('servicerId') ?? '')
      .writeToBuffer();
  MsgUtils.sendMessage(baseMessage.writeToBuffer());
}

void _onNoTalk(Action action, Context<KeyBoardState> ctx) {
  FreezePlayer freezePlayer = action.payload;
  ctx.dispatch(KeyBoardActionCreator.onShutUp(freezePlayer));
  if (freezePlayer.type == 1) {
    //禁言
    ServicerInfoFields servicerInfoFields = ServicerInfoFields.create();
    servicerInfoFields.declaration = freezePlayer.reason ?? "你已被禁言";
    ctx.dispatch(ListActionCreator.onShowChatFields(servicerInfoFields));
  } else if (freezePlayer.type == 2) {
    //解除
    ServicerInfoFields servicerInfoFields = ServicerInfoFields.create();
    servicerInfoFields.declaration = freezePlayer.reason ?? "您已解除禁言";
    ctx.dispatch(ListActionCreator.onShowChatFields(servicerInfoFields));
  }
}

//文本消息内容
void _onSendMsg(Action action, Context<KeyBoardState> ctx) async {
  ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  Map<String, dynamic> map = action.payload;
  int nowTime = DateTime.now().millisecondsSinceEpoch;
  // dynamic data = ctx.state.list;
  //判断当前webSocket是否是链接状态 是连接状态就直接聊天  没有链接 如果用户点击消息发送 就显示faq
  if (Instance.isConnect == true) {
    ChatFields chatFields = ChatFields.create()
      ..sessionId = await obtainValueByKey('sessionId') ?? ''
      ..text = map["text"].toString().length > 0 ? map["text"].toString() : ""
      ..time = Int64(nowTime)
      ..username = await obtainValueByKey('username') ?? ''
      ..targetId = await obtainValueByKey('servicerId') ?? ''
      ..type = 1
      ..senderId = await obtainValueByKey('id') ?? ''
      ..messageId = nowTime.toString();

    if (map['pic'] != null) {
      // chatFields.photo
      //     .add("${SocketManager().model.baseUrl}/file/${map["pic"]}");
      chatFields.photo.add("${map["pic"]}");
    }
    BaseMessage baseMessage = BaseMessage.create();
    baseMessage.action = 1003;
    baseMessage.data = chatFields.writeToBuffer();
    MsgUtils.sendMessage(baseMessage.writeToBuffer());
    if (map['pic'] == null)
      // ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));
      ctx.dispatch(ListActionCreator.onShowMsg(chatFields));
  } else {
    if (ctx.state.faqModel != null) {
      ServicerInfoFields servicerInfoFields = ServicerInfoFields.create();
      servicerInfoFields.declaration = '客服妹子正在忙哦～请先查看相关常见问题';
      ctx.dispatch(ListActionCreator.onShowChatFields(servicerInfoFields));
      //展示faq问题组件
      Future.delayed(Duration(seconds: 1), () {
        ctx.dispatch(ListActionCreator.onShowChatFields(ctx.state.faqModel));
      });
    }
  }
}

///发送语音消息到服务器
void _sendVoice(
    String data, Context<KeyBoardState> ctx, String filename) async {
  ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  ChatAudio chatAudio = ChatAudio.create();
  chatAudio.time = Int64(int.parse(filename));
  chatAudio.text = '';
  chatAudio.audio = data;
  chatAudio.targetId = await obtainValueByKey('servicerId') ?? '';
  chatAudio.senderId = await obtainValueByKey('id') ?? '';
  chatAudio.messageId = filename;
  chatAudio.sessionId = await obtainValueByKey('sessionId') ?? '';
  chatAudio.type = 1;
  chatAudio.duration = Int64(voiceTime);
  BaseMessage baseMessage = BaseMessage.create();
  baseMessage.action = 1004;
  baseMessage.data = chatAudio.writeToBuffer();
  MsgUtils.sendMessage(baseMessage.writeToBuffer());
  voiceTime = 0;
}

void _dispose(Action action, Context<KeyBoardState> ctx) {
  ctx?.dispatch(KeyBoardActionCreator.onClearTextField());
}

//语音上传
void _onVoiceUp(Action action, Context<KeyBoardState> ctx) async {
  String path = action.payload;
  String filename = path.split('/').last.split('.').first;
  var name = 'aac_' + ctx.state.appId + filename + '_$voiceTime';
  ChatFields chatFields = ChatFields.create()
    ..sessionId = await obtainValueByKey('sessionId') ?? ''
    ..text = ""
    ..time = Int64(int.parse(filename))
    ..username = await obtainValueByKey('username') ?? ''
    ..targetId = await obtainValueByKey('servicerId') ?? ''
    ..type = 1
    ..senderId = await obtainValueByKey('id') ?? ''
    ..messageId = filename
    ..photo.add("$name");
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));

  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      path,
      filename: name,
    )
  });
  Dio dio = Dio();
  //application/octet-stream
  // dio.options.headers[HttpHeaders.contentTypeHeader] =
  //     "application/json, multipart/form-data";
  dio.options.headers[HttpHeaders.contentTypeHeader] =
      "application/octet-stream, multipart/form-data";
  dio.options.headers["Authorization"] =
      "${await obtainValueByKey('id') ?? ''}&${ctx.state.appId ?? ''}&${await obtainValueByKey('sessionId') ?? ''}";
  String uri = "${SocketManager().model.baseUrl}/audio/$name";
  try {
    var response = await dio.post(uri, data: formData,
        onSendProgress: (int sent, int total) {
      // double t = sent / total;
    });
    print('+++++++++++++++++++++++++${response.data}');

    if (response?.data != null && response?.data['data'] != null) {
      // //=============================文件操作下======================================
      // ///更改文件名字
      // var file = File(path);
      // if(await file.exists()){
      //   var saveData = file.readAsBytesSync();
      //   var newFilename = await fileMgr.getRootPath() + '/' + response?.data['data'] + '.aac';
      //   var file1 = File(newFilename);
      //   if(await file1.exists()){
      //     file1.writeAsBytesSync(saveData);
      //   }else{
      //     file1.create();
      //     file1.writeAsBytes(saveData);
      //   }
      //   file.delete();
      // }
      // //============================文件操作上=======================================
      _sendVoice(response.data['data'], ctx, filename);
    } else {
      voiceTime = 0;
    }
  } catch (e) {
    voiceTime = 0;
  }
}

//图片上传
void _onUpPic(Action action, Context<KeyBoardState> ctx) async {
  String path = action.payload.path;
  List<int> imageBytes = await action.payload.readAsBytes();
  var name = ctx.state.appId + DateTime.now().millisecondsSinceEpoch.toString();
  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(
      path,
      filename: name,
    )
  });
  Dio dio = Dio();
  dio.options.headers[HttpHeaders.contentTypeHeader] =
      "application/json, multipart/form-data";
  var userId = await obtainValueByKey('id') ?? '';
  var appId = ctx.state.appId ?? '';
  var sessionId = await obtainValueByKey('sessionId') ?? '';
  dio.options.headers["Authorization"] = "$userId&$appId&$sessionId";
  print(dio.options.headers);
  //"${Api.baseUrl}/file/$name";
  String uri =
      "${SocketManager().model.baseUrl}/kefu/file/$name"; //"http://183.61.126.215:9090/file/$name";

  Map<String, dynamic> map = Map();
  map['base64'] = base64Encode(imageBytes);
  var username = await obtainValueByKey('username') ?? '';
  //拼接本地图片 直接展示到列表-------下
  int time = DateTime.now().millisecondsSinceEpoch;
  ChatFields chatFields = ChatFields.create()
    ..type = 1
    ..username = username
    ..time = Int64(time);
  chatFields.photo.add("$name^${map['base64']}");
  ctx.dispatch(ListActionCreator.onIsShowLoading({'$name': true}));
  //拼接本地图片 直接展示到列表-------上
  ctx.dispatch(ListActionCreator.onShowChatFields(chatFields));
  try {
    var response = await dio.post(uri, data: formData,
        onSendProgress: (int sent, int total) {
      // double t = sent / total;
    });
    if (response.data["data"] != null) {
      map["pic"] = response.data["data"];
      ctx.dispatch(KeyBoardActionCreator.onSendMsg(map));
    } else {
      print("图片上传失败");
    }
  } catch (e) {
    Map file = Map<String, File>();
    file[Int64(time).toString()] = action.payload;
    ctx.dispatch(ListActionCreator.onUpPicError(file));
    throw UnimplementedError(e.toString());
  } finally {
    ctx.dispatch(ListActionCreator.onIsShowLoading({'$name': false}));
    ctx.dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  }
}

//图片消息处理
