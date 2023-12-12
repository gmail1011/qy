/*
 * @Author: your name
 * @Date: 2020-05-22 20:19:07
 * @LastEditTime: 2020-05-25 19:28:05
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /zaixiankefu/lib/chat_widget/chat_page/view.dart
 */

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'state.dart';

Widget buildView(ChatState state, Dispatch dispatch, ViewService viewService) {
  // print('==================${t}');
  String typing = state.typing;
  return GestureDetector(
    onTap: () => FocusScope.of(viewService.context).requestFocus(FocusNode()),
    child: Theme(
      data: SocketManager().model.themeData ?? ThemeData(),
      child: Scaffold(
        backgroundColor: SocketManager().model.backgroundColor ??
            Theme.of(viewService.context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: SocketManager().model.appBarColor ??
              Theme.of(viewService.context).appBarTheme.color,
          title: Text(typing ?? '在线客服'),
        ),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            Container(
              child: Column(children: <Widget>[
                viewService.buildComponent('ListComponent'),
                Container(height: 10),
                state.isNeedKeyboard == false
                    ? viewService.buildComponent('keyBoardComponent')
                    : Container(),
              ]),
            ),
            Container(
                child: Offstage(
              offstage: state.isHideRecord,
              child: viewService.buildComponent('VoiceComponent'),
            ))
          ],
        )),
      ),
    ),
  );
}

/*
Expanded(
              child: Offstage(
                offstage: state.isHideRecord,
                child: viewService.buildComponent('VoiceComponent'),
          )),
*/
