import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 分页指示器
class TabIndicator extends StatefulWidget {
  TabIndicator({Key key, this.itemCount, this.selectIndex = 0, this.space = 5.0, this.tabController}) : super(key: key);
  final int itemCount;
  final int selectIndex;
  final double space;
  final TabController tabController;

  @override
  _CIndicatorState createState() => new _CIndicatorState();
}

class _CIndicatorState extends State<TabIndicator> {
  int currentIndex;

  void initState() {
    currentIndex = widget.selectIndex;
    widget.tabController.addListener(() {
      int index = widget.tabController.index;
      if (currentIndex != index) {
        currentIndex = index;
        setState(() {});
      }
    });
    super.initState();
  }

  Widget _getBall(int index) {
    var normalBall = Padding(
      padding: EdgeInsets.only(left: widget.space),
      child: ClipOval(
        child: Container(
          width: 5,
          height: 5,
          color: Colors.white,
        ),
      ),
    );
    var selectBall = Padding(
        padding: EdgeInsets.only(left: widget.space),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 15,
            height: 5,
            color: Colors.yellow,
          ),
        ));
    return (currentIndex == index) ? selectBall : normalBall;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.itemCount; ++i) {
      list.add(_getBall(i));
    }
    var wd = Container(
      child: Row(
        children: list,
      ),
    );
    return wd;
  }
}
