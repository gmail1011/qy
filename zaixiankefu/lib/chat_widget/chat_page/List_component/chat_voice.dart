import 'package:bubble/bubble.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/download_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/assets_svg.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/file_manager.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/utils/sound_helper.dart';
import 'package:chat_online_customers/chat_widget/chat_core/pkt/pb.pb.dart';
import 'package:chat_online_customers/chat_widget/chat_page/List_component/action.dart';
import 'package:chat_online_customers/chat_widget/chat_page/utils/bubble_style.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatVoicePage<T, ViewService, P, V, D> extends StatefulWidget {
  final T bean;
  final ViewService viewService;
  final P p;
  final V value;
  final D dispatch;
  ChatVoicePage(this.bean, this.viewService, this.p, this.value, this.dispatch);
  @override
  State<StatefulWidget> createState() {
    return ChatVoiceState();
  }
}

class ChatVoiceState extends State<ChatVoicePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: widget.bean.type == 1
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.bean.type != 1
                ? (AvatarWidget(Instance.customerAvatar) ??
                    AvatarWidget(widget.value?.avatar ?? ''))
                : Container(),
            Container(
              child: Column(
                  crossAxisAlignment: widget.bean.type == 1
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                          widget.bean.type == 1
                              ? (SocketManager().model?.username ??
                                  widget.p?.username ??
                                  '')
                              : widget.value?.username ??
                                  Instance.customerUsername,
                          style: TextStyle(
                              fontSize: 12,
                              color: SocketManager()
                                  .model
                                  .nicknameColor) //TextStyle(fontSize: 15),
                          ),
                    ),
                    Bubble(
                        style: myBubble(
                            widget.viewService.context, widget.bean.type),
                        child: widget.bean.photo.length > 0
                            ? VoiceItem(widget.bean, widget.dispatch)
                            : Container(
                                child: Text(
                                  '语音内容已失效',
                                  style: TextStyle(
                                      color: SocketManager().model.unReadColor,
                                      fontSize: 10),
                                ),
                              )),
                    widget.bean.type == 1
                        ? Container(
                            padding: EdgeInsets.only(right: 6, top: 4),
                            child: Text(widget.bean.isRead != 2 ? '未读' : '已读',
                                style: widget.bean.isRead != 2
                                    ? TextStyle(
                                        color:
                                            SocketManager().model.unReadColor,
                                        fontSize: 10)
                                    : TextStyle(
                                        color:
                                            SocketManager().model.primaryColor,
                                        fontSize: 10)),
                          )
                        : Container()
                  ]),
            ),
            // bean.type == 1 ? AvatarWidget(p.avatar) : Container(height: 0),
            widget.bean.type == 1
                ? AvatarWidget(SocketManager().model?.avatar)
                : Container(height: 0),
          ]),
    );
  }
}

class VoiceItem extends StatefulWidget {
  final dynamic bean;
  final Dispatch kDispatch;
  VoiceItem(this.bean, this.kDispatch);
  @override
  State<StatefulWidget> createState() {
    return VoiceWidgetState();
  }
}

class VoiceWidgetState extends State<VoiceItem> {
  static String voiceIcon = ASvg.LABA_RIGHT_3;
  bool isPlay = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(Object context) {
    var voiceWidget = GestureDetector(
        onTap: () {
          // widget.dispatch(KeyBoardActionCreator.onPlayAudio(widget.bean));
          if (widget.bean.photo != null && widget.bean.photo.length > 0) {
            print('==============${widget.bean.photo}');
            playSound(widget.bean);
          }
        },
        child: Container(
          width: 65,
          child: Column(
              crossAxisAlignment: widget.bean.type == 1
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Row(
                        mainAxisAlignment: widget.bean.type == 1
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: <Widget>[
                          widget.bean.type != 1
                              ? Container(
                                  margin: EdgeInsets.only(right: 6),
                                  child: SvgPicture.asset(
                                    isPlay == false
                                        ? ASvg.LABA_LEFT_3
                                        : voiceIcon,
                                    package: 'chat_online_customers',
                                  ))
                              : Container(),
                          Container(
                              padding: EdgeInsets.only(right: 6),
                              child: Text(
                                  '${widget.bean.duration != null && widget.bean.duration != 0 ? widget.bean.duration : widget.bean.photo.first.split('_').last}s')),
                          widget.bean.type == 1
                              ? Container(
                                  child: SvgPicture.asset(
                                  isPlay == false
                                      ? ASvg.LABA_RIGHT_3
                                      : voiceIcon,
                                  package: 'chat_online_customers',
                                ))
                              : Container(),
                        ])),
              ]),
        ) //Text('Can you help me?'),
        );

    return voiceWidget;
  }

  ///播放语音
  playSound(dynamic data) async {
    isPlay = true;
    sound_helper.stopPlayer();

    ChatFields chatFields = data;
    String path = await Network().isExist(chatFields);
    if (path.length > 0) {
      sound_helper.startPlayer(path, (duration) {
        if (duration != 1.0) {
          setState(() {
            if (duration <= 0.1) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_1 : ASvg.LABA_LEFT_1;
            } else if (duration <= 0.2 && duration > 0.1) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_2 : ASvg.LABA_LEFT_2;
            } else if (duration <= 0.3 && duration > 0.2) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_3 : ASvg.LABA_LEFT_3;
            } else if (duration <= 0.4 && duration > 0.3) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_2 : ASvg.LABA_LEFT_2;
            } else if (duration <= 0.5 && duration > 0.4) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_1 : ASvg.LABA_LEFT_1;
            } else if (duration <= 0.6 && duration > 0.5) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_2 : ASvg.LABA_LEFT_2;
            } else if (duration <= 0.7 && duration > 0.6) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_3 : ASvg.LABA_LEFT_3;
            } else if (duration <= 0.8 && duration > 0.7) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_2 : ASvg.LABA_LEFT_2;
            } else if (duration <= 0.9 && duration > 0.8) {
              voiceIcon =
                  chatFields.type == 1 ? ASvg.LABA_RIGHT_1 : ASvg.LABA_LEFT_1;
            }
          });
        } else {
          sound_helper.stopPlayer();
          setState(() {
            isPlay = false;
            voiceIcon =
                chatFields.type == 1 ? ASvg.LABA_RIGHT_3 : ASvg.LABA_LEFT_3;
          });
        }
      });
    } else {
      downloadVoiceData(chatFields);
    }
  }

  downloadVoiceData(ChatFields chatFields) async {
    List l = chatFields.photo.first.split('_');
    var filename = "";
    for (var i = 0; i < l.length - 1; i++) {
      if (i == 0) {
        filename = l[0];
      } else {
        filename = filename + '_' + l[i];
      }
    }
    var localPath = await fileMgr.getRootPath() + '/' + filename + '.aac';
    String uri = SocketManager().model.baseUrl + '/kefu/audio/' + filename;
    Network().download(uri, localPath,
        (data) => {print('====$data'), playSound(chatFields)}, (e) => {});
  }
}
