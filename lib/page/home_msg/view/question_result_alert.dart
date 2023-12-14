
import 'package:flutter/material.dart';

class QuestionResultAlert extends StatefulWidget {
  final String descText;
  final int type;
  const QuestionResultAlert({Key key, this.descText, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionResultAlertState();
  }

  static show(BuildContext context, {int type, String descText}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return QuestionResultAlert(
          descText: descText,
          type: type,
        );
      },
    );
  }
}

class _QuestionResultAlertState extends State<QuestionResultAlert> {

  @override
  Widget build(BuildContext context) {
    double scale = MediaQuery.of(context).size.width / 428;
    if (scale > 1) scale = 1;
    if (scale < 0.88) scale = 0.88;
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 300,
          height: 382,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/q_result_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 145),
              Image.asset("assets/images/title_result_${widget.type}.png", width: 132, height: 36,),
              SizedBox(height: 24),
              Container(
                width: 232,
                height: 130,
                child:  Text(
                  widget.descText,
                  style: TextStyle(
                    color: Color(0xff663418),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
