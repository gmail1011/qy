import 'dart:async';
import 'dart:io';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_page/action.dart';
import 'package:flutter_svg/svg.dart';
import '../../chat_core/network/connection/connect_util.dart';
import '../List_component/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'action.dart';
import 'state.dart';

Timer _throttlingTimer;
var text;
Widget buildView(
    KeyBoardState state, Dispatch dispatch, ViewService viewService) {
  print('重新build:' + state.editController.hashCode.toString());
  state.editController.text = text ?? "";

  var textField = TextField(
    keyboardType: TextInputType.text,
    cursorColor: Colors.blue,
    controller: state.editController,
    maxLines: 100,
    minLines: 1,
    enabled: state.freezePlayer?.type == 1 ? false : true,
    decoration: InputDecoration(
      hintText: state.freezePlayer?.type == 1 ? "您已被禁言" : "输入",
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      isDense: true,
      border: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
            width: 0.5,
            // style: BorderStyle.none,
            color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.4),
          width: 0.5,
          // style: BorderStyle.none,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
          // style: BorderStyle.none,
        ),
      ),
    ),
    onChanged: (v) {
      text = v;
      // 节流处理
      _throttlingTimer?.cancel();
      _throttlingTimer = null;
      _throttlingTimer = Timer(Duration(milliseconds: 300),
          () => dispatch(KeyBoardActionCreator.onStartInput()));
    },
  );
  var voice = GestureDetector(
    onPanDown: (s) {
      print('开始');

      dispatch(KeyBoardActionCreator.onRecordVoice());
    },
    onPanCancel: () {
      print('结束');

      dispatch(KeyBoardActionCreator.onStopRecord());
      dispatch(ChatActionCreator.cancelRecordUI());
    },
    onVerticalDragEnd: (v) {
      dispatch(KeyBoardActionCreator.onStopRecord());
      dispatch(ChatActionCreator.cancelRecordUI());
    },
    // onVerticalDragStart: (details) {
    //   dispatch(KeyBoardActionCreator.onRecordVoice());
    // },
    // onVerticalDragEnd: (details) {
    //   dispatch(KeyBoardActionCreator.onStopRecord());
    // },
    // onVerticalDragUpdate: (details) {
    //   dispatch(ChatActionCreator.cancelRecordUI());
    // },
    child: Container(
      height: 32,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text('按住讲话'),
      ),
    ),
  );

  // 消息内容
  return SafeArea(
      child: Column(
    children: <Widget>[
      Divider(
        height: 0.5,
        color: Colors.grey,
        endIndent: 0,
        indent: 0,
      ),
      Container(
        height: 50,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  if (state.freezePlayer?.type == 1 ||
                      Instance.isConnect == false) {
                  } else {
                    _showModalBottomSheet(viewService.context, dispatch);
                  }
                },
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    child: Container(
                      height: 24,
                      width: 24,
                      child: SvgPicture.asset(
                        'assets/svg/pic.svg',
                        package: 'chat_online_customers',
                        color: SocketManager().model.primaryColor,
                      ),
                    )
                    // child: Image.asset('assets/images/msg.png',
                    //         package: 'chat_online_customers',
                    //         color: ChatColor.selectPicColor),
                    ),
              ),
            ),
           SocketManager().model.isVoice == false ? GestureDetector(
                onTap: () {
                  FocusScope.of(viewService.context).requestFocus(FocusNode());
                  if (state.freezePlayer?.type != 1) {
                    if (state.isVoice == true) {
                      dispatch(KeyBoardActionCreator.onClickVoiceAction(false));
                    } else {
                      dispatch(KeyBoardActionCreator.onClickVoiceAction(true));
                    }
                  }
                },
               child: Container(
                    height: 24,
                    width: 24,
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 0, right: 10),
                    child: SvgPicture.asset(
                      state.isVoice == false
                          ? 'assets/svg/laba.svg'
                          : 'assets/svg/keybook.svg',
                      color: SocketManager().model.primaryColor,
                      package: 'chat_online_customers',
                    ))) : Container(),
            Expanded(child: state.isVoice == true ? voice : textField),
            GestureDetector(
              onTap: () {
                if (state.freezePlayer?.type == 1) {
                  //禁言弹窗
                  // YYDialogDontTalk(
                  //     viewService.context, state.freezePlayer.reason);
                } else {
                  if (text != null && text.length > 0) {
                    Map<String, dynamic> textMap = Map();
                    textMap["text"] = text;
                    dispatch(KeyBoardActionCreator.onSendMsg(textMap));
                    //重置是否滚动到底部状态
                    dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
                    dispatch(KeyBoardActionCreator.onClearTextField());
                    text = '';
                  } else {
                    print('请输入消息内容');
                  }
                }
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
                child: Text('发送',
                    style: TextStyle(
                        fontSize: 14,
                        color: SocketManager().model.primaryColor),
                    textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      )
    ],
  ));
}

_showModalBottomSheet(BuildContext context, Dispatch dispatch) {
  final List<String> textList = ['相册', '拍照', '取消'];
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SafeArea(
            child: Container(
              child: ListView(
                  children: List.generate(
                textList.length,
                (index) => InkWell(
                    child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        child: Text('${textList[index]}')),
                    onTap: () {
                      if (index == 0) {
                        // _openGallery();
                        getImageByGallery(dispatch);
                      } else if (index == 1) {
                        getImageByCamera(dispatch);
                      } else if (index == 2) {}
                      Navigator.pop(context);
                    }),
              )),
              height: 180,
            ),
          ));
}

// class SendBtnWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return SendBtnState();
//   }
// }

// class SendBtnState extends State<SendBtnWidget> {
//   bool isVoice = true;

//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
//       margin: EdgeInsets.only(left: 10, right: 10),
//       // child: SvgPicture.asset(
//       //   'assets/svg/ic_chat_voice.svg',
//       //   color: Colors.blue,
//       //   package: 'chat_online_customers',
//       // ),
//       child: Text(isVoice == true ? '语音' : '发送',
//           style: TextStyle(
//               fontSize: 14, color: SocketManager().model.primaryColor),
//           textAlign: TextAlign.center),
//     );
//   }
// }

Future getImageByGallery(Dispatch dispatch) async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  var tw = 400;
  File _image = image;
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(_image.path);
  File compressedFile = await FlutterNativeImage.compressImage(_image.path,
      quality: 80,
      // percentage: 100,
      targetWidth: tw,
      targetHeight: (properties.height * tw / properties.width).round());
  //重置是否滚动到底部状态
  dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  //拍照获取图片上传
  dispatch(KeyBoardActionCreator.upPicAction(compressedFile));
}

Future getImageByCamera(Dispatch dispatch) async {
  var image = await ImagePicker.pickImage(source: ImageSource.camera);
  File _image = image;
  var tw = 400;
  ImageProperties properties =
      await FlutterNativeImage.getImageProperties(_image.path);
  File compressedFile = await FlutterNativeImage.compressImage(_image.path,
      quality: 80,
      targetWidth: tw,
      targetHeight: (properties.height * tw / properties.width).round());
  //重置是否滚动到底部状态
  dispatch(ListActionCreator.onChangeIsScrollToBottom(true));
  //拍照获取图片上传
  dispatch(KeyBoardActionCreator.upPicAction(compressedFile));
}
