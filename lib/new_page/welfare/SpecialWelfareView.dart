import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/welfare/welfare_home_page.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_recommend.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_task.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';

class SpecialWelfareViewPage extends StatefulWidget {

  int index = 1;

  SpecialWelfareViewPage(this.index);

  @override
  State<SpecialWelfareViewPage> createState() => _State();
}

class _State extends State<SpecialWelfareViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getCommonAppBar("免费福利"),
        body: WelfareHomePage(widget.index),
    );
  }
}
