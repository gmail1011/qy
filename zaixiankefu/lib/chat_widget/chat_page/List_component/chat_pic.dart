
import 'dart:typed_data';

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/connect_util.dart';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';


import '../utils/bubble_style.dart';
import '../utils/tool.dart';
import 'package:bubble/bubble.dart';
import 'package:dio/dio.dart';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_pickers/image_pickers.dart';

//图片消息
class PicMsgWidget<T, P, V> extends StatelessWidget {
  final T bean;
  final ViewService viewservice;
  final P p;
  final V v;
  final Map<String, bool> loadingState;
  PicMsgWidget(this.bean, this.viewservice, this.p, this.v,
      {this.loadingState});
  Widget build(BuildContext context) {
    return photoItem(bean, viewservice, p, v, context);
  }

  Widget photoItem(dynamic bean, ViewService viewService, dynamic p, dynamic v,
      BuildContext context) {
    String name;
    dynamic _getPicUrl() {
      dynamic url;
      if (bean.photo[0].indexOf('^') > 0) {
        List<String> array = bean.photo[0].split('^');
        url = array[1];
        name = array[0];
      } else {
        url = bean.photo[0].startsWith('http')
            ? bean.photo[0]
            : "${SocketManager().model.baseUrl}/kefu/file/${bean.photo.first}";
      }
      return url;
    }

    return Container(
      child: Row(
        mainAxisAlignment:
            bean.type == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          bean.type != 1
              ? ((AvatarWidget(Instance.customerAvatar) ??
                  AvatarWidget(v?.avatar ?? '')))
              : Container(),
          Container(
              padding: EdgeInsets.only(top: 8),
              child: Column(
                  crossAxisAlignment: bean.type == 1
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                          bean.type == 1
                              ? (SocketManager().model.username ??
                                  p?.username ??
                                  '')
                              : (v?.username ?? Instance.customerUsername),
                          style: TextStyle(
                              color: SocketManager().model.nicknameColor,
                              fontSize: 12) //TextStyle(fontSize: 15)
                          ),
                    ),
                    Container(
                        child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(viewService.context).size.width *
                                  0.6),
                      child: Bubble(
                          style: myBubble(viewService.context, bean?.type ?? 0),
                          child: Column(children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showDialog(viewService.context, _getPicUrl());
                              },
                              child: Container(
                                  // padding: EdgeInsets.all(10),
                                  child: PlaceHolderImgWidget(_getPicUrl(),
                                      indicatorState: loadingState,
                                      name: name) //Image.network(pic),
                                  //
                                  ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.only(top: 8),
                            //   child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.end,
                            //       children: <Widget>[
                            //         Text(showMsgTime(bean?.time ?? ''),
                            //             style: TextStyle(
                            //                 color: SocketManager().model.baseColor,
                            //                 fontSize: 10)),
                            //         bean.type == 1
                            //             ? Container(
                            //                 child: Container(
                            //                 padding: EdgeInsets.only(left: 8),
                            //                 child: Text(
                            //                     bean.isRead != 2 ? '未读' : '已读',
                            //                     style: bean.isRead != 2
                            //                         ? TextStyle(
                            //                             color: SocketManager().model
                            //                                 .unReadColor,
                            //                             fontSize: 10)
                            //                         : TextStyle(
                            //                             color: SocketManager().model
                            //                                 .alreadyReadColor,
                            //                             fontSize: 10)),
                            //               ))
                            //             : Container()
                            //       ]),
                            // )
                          ])),
                    )),
                    bean.type == 1
                        ? Container(
                            padding: EdgeInsets.only(right: 6, top: 4),
                            child: Text(bean.isRead != 2 ? '未读' : '已读',
                                style: bean.isRead != 2
                                    ? TextStyle(
                                        color:
                                            SocketManager().model.unReadColor,
                                        fontSize: 10)
                                    : TextStyle(
                                        color: SocketManager()
                                            .model
                                            .primaryColor,
                                        fontSize: 10)),
                          )
                        : Container(),
                  ])),
          bean.type == 1
              ? AvatarWidget(SocketManager().model?.avatar ?? '')
              : Container(),
        ],
      ),
    );
  }
}

//图像放大
_showDialog(BuildContext context, String url) async {
  var result = await showDialog(
      context: context,
      builder: (ctx) {
        return SafeArea(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          onLongPress: () {
            _showModalBottomSheet(context, url);
          },
          child: Center(child: PlaceHolderImgWidget(url)),
        ));
      });
  print(result);
}

//底部弹出框
_showModalBottomSheet(BuildContext context, String url) {
  final List<String> textList = ['保存图片', '取消'];
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
                      // ImagePickers.saveImageToGallery(url);
                      savePicture(url);
                    }
                    Navigator.pop(context);
                  },
                  onLongPress: () {
                    _showModalBottomSheet(context, url);
                  },
                ),
              )),
              height: 120,
            ),
          ));
}

class PicWidget extends StatelessWidget {
  final String pic;
  var time;
  final String name;
  final int type;
  final Map<String, bool> loadingState;
  final ViewService viewService;
  PicWidget(this.pic, this.time, this.viewService, this.type,
      {this.loadingState, this.name});
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          // border: Border.all(width: 2.0, color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
                spreadRadius: 2.0),
            BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0)),
            BoxShadow(color: Colors.white)
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Colors.grey,
                padding: EdgeInsets.all(0),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(viewService.context).size.width * 0.67 -
                              60,
                      minWidth: 60,
                    ),
                    child: PlaceHolderImgWidget(pic,
                        indicatorState: loadingState,
                        name: name) //Image.network(pic),
                    ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(children: <Widget>[
                    Text(
                      showMsgTime(time),
                    )
                  ]))
            ]));
  }
}

void savePicture(String url) async {
  print('=========url========$url');
  var response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  final result =
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
  print('图片保存成功');
}
