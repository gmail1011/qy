/// @date: 2021/12/6 2:53 下午
/// @author: admin
/// @description: dart
///
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSheet extends StatelessWidget {
  ///标题文字描述
  final String title;

  ///选项列表
  final List<String> options;

  ///标题文字样式
  final TextStyle titleTextStyle;

  ///选项内容文字样式
  final TextStyle optionTextStyle;

  ///取消按钮文字样式
  final TextStyle cancelTextStyle;

  final Function(int index) didIndexSelected;

  CupertinoSheet({
    Key key,
    @required this.title,
    @required this.options,
    this.titleTextStyle,
    this.optionTextStyle,
    this.cancelTextStyle,
    @required this.didIndexSelected,
  }) : super(key: key);

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Color(0xFF646B77),
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    title,
                    style: titleTextStyle ??
                        TextStyle(
                          color: Color(0xFF3F454F),
                          fontSize: 17,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    didIndexSelected.call(selectedIndex);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3581FF),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Expanded(
            child: CupertinoPicker(
              onSelectedItemChanged: (index) {
                selectedIndex = index;
              },
              squeeze: 1,
              useMagnifier: true,
              magnification: 1.4,
              itemExtent: 42,
              children: options
                  .map(
                    (e) => Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF3F454F),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
