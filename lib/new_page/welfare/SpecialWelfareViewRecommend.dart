import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/welfare/welfare_home_page.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_recommend.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_task.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';

class SpecialWelfareViewRecommendPage extends StatefulWidget {

  SpecialWelfareViewRecommendPage();

  @override
  State<SpecialWelfareViewRecommendPage> createState() => _State();
}

class _State extends State<SpecialWelfareViewRecommendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getCommonAppBar("福利任务"),
        body: WelfareViewTask(),
    );
  }
}
