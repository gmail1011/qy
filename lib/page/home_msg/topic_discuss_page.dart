import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';

class TopicDiscussPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TopicDiscussPageState();
  }

}

class _TopicDiscussPageState extends State<TopicDiscussPage> {


  var dataModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: getCommonAppBar("题目"),
      body: Container(),
    );
  }

  Widget _buildContent() {
    if(dataModel == null){
      return LoadingCenterWidget();
    }else if(dataModel == null){
      return CErrorWidget("暂无数据", retryOnTap: (){
        dataModel = null;
        setState(() {
        });
        _loadData();
      },);
    }else {
      return Container();
    }
  }
}
