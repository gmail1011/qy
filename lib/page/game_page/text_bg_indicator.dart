import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';


class TextBgIndicator extends StatefulWidget {

  final TabController controller;
  final List<String> titleArr;
  const TextBgIndicator({@required this.controller, @required this.titleArr,});

  @override
  State<StatefulWidget> createState() {
    return _TextBgIndicatorState();
  }
}

class _TextBgIndicatorState extends State<TextBgIndicator> {


  int get currentPage {
    int index = widget.controller.index;
    return index;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listen);
  }

  void _listen() {
    if(mounted){
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listen);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetArr = [];
    for(int i = 0; i < widget.titleArr.length; i++){
      widgetArr.add(_buildMenuButton(widget.titleArr[i], currentPage == i, i));
    }
    return  Container(
      height: 30,
      width: 148,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xff1f1f1f),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widgetArr,
      ),
    );
  }

  Widget _buildMenuButton(String text, bool isSelected, int index) {
    return InkWell(
      onTap: () {
       widget.controller.index = index;
       setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        width: 148/2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color:  isSelected ? AppColors.primaryTextColor : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xff999999),
          ),
        ),
      ),
    );
  }
}