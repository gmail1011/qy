



import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';
import 'package:flutter/material.dart';
import 'package:fish_redux/fish_redux.dart';

//系统时间展示 ---系统提示语
class SystemContentWidget<S> extends StatelessWidget {
  final S bean;
  final ViewService viewService;
  SystemContentWidget(this.bean, this.viewService);
  @override
  Widget build(BuildContext context) => textItem(bean, viewService);

  Widget textItem(dynamic bean, ViewService viewService) {
    return Container(
      width: MediaQuery.of(viewService.context).size.width * 0.67,
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      padding: EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 0,
            maxWidth: MediaQuery.of(viewService.context).size.width * 0.5),
        child: Center(
          child: Text(bean.declaration,
              textAlign: TextAlign.center,
              maxLines: 10,
              style: TextStyle(fontSize: 10, color: SocketManager().model.tipColor)),
        ),
      ),
    );
  }
}
