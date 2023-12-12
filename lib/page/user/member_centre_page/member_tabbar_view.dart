import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';

class MemberTabbarView extends StatefulWidget {
  final TabController tabBarController;

  const MemberTabbarView({Key key, this.tabBarController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MemberTabbarViewState();
  }
}

class _MemberTabbarViewState extends State<MemberTabbarView> {
  double get contentWidth => screen.screenWidth - 16 * 2;
  double get buttonWidth => contentWidth/2 + 14;
  double get height => 41;
  @override
  void initState() {
    super.initState();
    widget.tabBarController.addListener(_flushUI);
  }

  @override
  void dispose() {
    super.dispose();
    widget.tabBarController.removeListener(_flushUI);
  }

  void _flushUI(){
    if(mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: height,
      width: contentWidth,
      child: widget.tabBarController.index == 0
          ? _buildSelectedLeft()
          : _buildSelectedRight(),
    );
  }

  Widget _buildSelectedLeft() {
    return Stack(
      children: [
        Positioned(
          right: 0,
          child: InkWell(
            onTap: () {
              widget.tabBarController.index = 1;
              setState(() {});
            },
            child: Container(
              width: buttonWidth,
              height: height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/right_unselected.png"),
                    fit: BoxFit.fill,
                    width: buttonWidth,
                    height: height,
                  ),
                  Text(
                    "钱包",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xff909298),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
             widget.tabBarController.index = 0;
             setState(() {});
          },
          child: Container(
            width: buttonWidth,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/left_selected.png"),
                  fit: BoxFit.fill,
                  width: buttonWidth,
                  height: height,
                ),
                Text(
                  "VIP会员",
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff483f25),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedRight() {
    return Stack(
      children: [
        InkWell(
          onTap: () {
             widget.tabBarController.index = 0;
             setState(() {});
          },
          child: Container(
            width: buttonWidth,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/left_unselected.png"),
                  fit: BoxFit.fill,
                  width: buttonWidth,
                  height: height,
                ),
                Text(
                  "VIP会员",
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xff909298),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: InkWell(
            onTap: () {
              widget.tabBarController.index = 1;
              setState(() {});
            },
            child: Container(
              width: buttonWidth,
              height: height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/right_selected.png"),
                    fit: BoxFit.fill,
                    width: buttonWidth,
                    height: height,
                  ),
                  Text(
                    "钱包",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xff483f25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
