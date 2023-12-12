

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';

class HJCustomTabBar extends StatefulWidget {
  List<String> tabs;
  TabController controller;
  bool isSearchStyle;
  Color selectedColor;
  Color bgColor;
  HJCustomTabBar(this.tabs, this.controller, {this.isSearchStyle = false, this.selectedColor, this.bgColor});

  @override
  State<StatefulWidget> createState() {
    return _HJCustomTabBarState();
  }
}

class _HJCustomTabBarState extends State<HJCustomTabBar>
    with TickerProviderStateMixin {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _tabIndex = widget.controller.index;
        print("_tabIndex:${_tabIndex}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isSearchStyle == true){
      return Container(
        width: 148,
        height: 30,
        margin: EdgeInsets.only(left: 8),
        padding: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: widget.bgColor ??  Color(0xff1a1a1a)
        ),
        child: _buildSearchStyle(),
      );
    }
    return Container(
      width: 160,
      height: 32,
      margin: EdgeInsets.only(left: 8),
      padding: EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: widget.bgColor ??  Color(0xff1a1a1a)
          ),
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        controller: widget.controller,
        // isScrollable: true,//设置为true则TabBar居中
        indicator: const BoxDecoration(), //不设置下划线
        tabs: _buildTabItem(_tabIndex),
      ),
    );
  }

  Widget _buildSearchStyle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildSearchTabItem(0),),
        Expanded(child: _buildSearchTabItem(1),),
      ],
    );
  }

  Widget _buildSearchTabItem(int index){
    return InkWell(
      onTap: (){
        widget.controller.index = index;
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: index == _tabIndex ? AppColors.primaryTextColor : Colors.transparent,
        ),
        child: Text(widget.tabs[index], style: TextStyle(
          color: index == _tabIndex ?  Colors.white : Color(0xff999999),
          fontSize: 12,
          fontWeight:index == _tabIndex ? FontWeight.w500 : FontWeight.normal,
        ),),
      ),
    );
  }

  _buildTabItem(int index) {
    List<Widget> list = [];
    for (var i = 0; i < widget.tabs.length; i++) {
      list.add(
        Container(
          //margin: EdgeInsets.only(left: 12),
          decoration: index == i
              ? BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: widget.selectedColor ?? AppColors.primaryTextColor,)
              : BoxDecoration(color: Colors.transparent),
          child: Center(
            child: Text(
              widget.tabs[i],
              style: TextStyle(
                  color: index == i ? Color(0xffffffff) : Color(0xff999999),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
            ),
          ),
        ),
      );
    }
    return list;
  }
}
