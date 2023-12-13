import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeMsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeMsgPageState();
  }
}

class _HomeMsgPageState extends State<HomeMsgPage> {
  RefreshController controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Expanded(child: pullYsRefresh(
              refreshController: controller,
              enablePullUp: false,
              child: ListView.builder(
                itemCount: 0,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
            ),),
          ],
        ),
      ),
    );
  }
}
