import 'package:chat_online_customers/chat_widget/chat_page/bullet_box/dialog_component/simpLeDialog.dart';
import 'package:flutter/material.dart';


void showSimpleDialog(dynamic ctx, dynamic data) {
  var context = ctx.context;
  if (context != null)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BulletBox(
          ctx.dispatch,
          text: data.content,
          sessionId: data.sessionId,
        );
      },
    );
}
