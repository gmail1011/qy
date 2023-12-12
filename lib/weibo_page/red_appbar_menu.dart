import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RedAppbarMenu extends StatefulWidget {

  final String title;
  final TabController tabController;

  const RedAppbarMenu({Key key, this.title, this.tabController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RedAppbarMenuState();
  }
}

class _RedAppbarMenuState extends State<RedAppbarMenu>{

  @override
  void initState() {
    if(widget.title == "关注"){
      widget.tabController?.addListener(_reFlashUI);
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.title == "关注"){
      widget.tabController?.removeListener(_reFlashUI);
    }
    super.dispose();
  }

  void _reFlashUI() {
    if(widget.tabController?.index == 0 && Config.followNewsStatus == true){
      Config.followNewsStatus = false;
      setState(() {});
    }

  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 22.nsp),
          ),
          if (widget.title == '关注' && Config.followNewsStatus == true)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }

}