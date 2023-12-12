import 'package:flutter/material.dart';

class Stars extends StatelessWidget {
  final double factor;
  final int number;
  final double size;

  Stars({this.factor: 4.5, this.number: 5, this.size: 30});
  // 星星数量
  _obtainStar(int numb, double factor) {
    List<Widget> _list = List();
    // 总分
    double _totalScore = factor;
    // 遮挡值
    double _factor = 0;
    for (var i = 0; i < numb; i++) {
      if(_totalScore - 1>=0){
        _factor = 1;
      } else {
        _factor = _totalScore > 0 ? _totalScore : 0;
      }
      _totalScore -= 1;
      _list.add(Stack(
        children: <Widget>[
          Icon(
            Icons.star_border,
            size: size,
            color: Colors.grey,
          ),
          ClipRect(
              child: Align(
            alignment: Alignment.topLeft,
            widthFactor: _factor,
            child: Icon(
              Icons.star,
              size: size,
              color: Colors.redAccent,
            ),
          ))
        ],
      ));
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _obtainStar(number, factor)
    );
  }
}