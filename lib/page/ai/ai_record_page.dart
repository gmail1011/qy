import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';

import 'ai_record_table_view.dart';

class AiRecordPage extends StatefulWidget {
  int position = 0;

  AiRecordPage({
    Key key,
    this.position,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AiRecordPageState();
  }
}

class _AiRecordPageState extends State<AiRecordPage> {
  int currentIndex = 1;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  void _selectMenu(int index) {
    currentIndex = index;
    _controller.jumpToPage(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem("排队", 0 == currentIndex, 0),
                  Text(
                    "/",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  _buildMenuItem("成功", 1 == currentIndex, 1),
                  Text(
                    "/",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  _buildMenuItem("失败", 2 == currentIndex, 2),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: _selectMenu,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return AiRecordTableView(status: index + 1,pageType:widget.position);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => _selectMenu(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.primaryTextColor
                : Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
