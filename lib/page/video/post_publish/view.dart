import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(PostPublishState state, Dispatch dispatch, ViewService viewService) {
  return WillPopScope(
    child: Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 19, 30),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 19, 30),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              dispatch(PostPublishActionCreator.onBack());
            }),
        actions: <Widget>[
          Container(
            child: FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.pt3)),
              color: Color.fromARGB(255, 167, 53, 42),
              onPressed: () {
                dispatch(PostPublishActionCreator.onPublishPost());
              },
              child: Text("發佈",style: TextStyle(color: Colors.white,fontSize: Dimens.pt14),),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(color: Color(0xffeeeeee), height: 0.5),
              TextField(
                cursorColor: Colors.blueAccent,
                style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                maxLength: 100,
                maxLines: 4,
                controller: state.contentController,
                decoration: InputDecoration(
                  hintText: Lang.VIDEO_PUBLISH_CONTENT_TIP,
                  border: InputBorder.none,
                  counterText: '',
                  hintStyle: TextStyle(color: Colors.grey[800], fontSize: Dimens.pt12),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(viewService.context).requestFocus(FocusNode());
        },
      ),
    ),
    onWillPop: () {
      dispatch(PostPublishActionCreator.onBack());
      return;
    },
  );
}
