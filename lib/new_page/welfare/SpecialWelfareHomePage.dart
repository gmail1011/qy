import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/welfare/welfare_home_page.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_task.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';

class SpecailWelfareViewTaskPage extends StatefulWidget {

  SpecailWelfareViewTaskPage();

  @override
  State<SpecailWelfareViewTaskPage> createState() => _State();
}

class _State extends State<SpecailWelfareViewTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getCommonAppBar("福利中心"),
        body: WelfareViewTask(),
    );
  }
}
