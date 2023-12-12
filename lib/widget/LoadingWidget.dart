import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget{
  LoadingWidgetState loadingWidgetState;
  String title;
  bool canCancel;
  LoadingWidget({this.title,this.canCancel = false});
  void show(context){

    showDialog(
        context: context,
        barrierDismissible: canCancel,
        builder: (context){
          return this;
        }
    );
  }
  void cancel(){
    if(loadingWidgetState!=null){
      loadingWidgetState.cancel();
      loadingWidgetState = null;
    }
  }
  @override
  State<StatefulWidget> createState() {
    loadingWidgetState =LoadingWidgetState();
    return loadingWidgetState;
  }
}


class LoadingWidgetState extends State<LoadingWidget>{

  void cancel(){
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {

    SizedBox sizedBox = SizedBox(
      width: 36,
      height: 36,
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey[500],
        valueColor: AlwaysStoppedAnimation(Colors.white70),
        strokeWidth: 2,
//              value: .5,
      ),
    );

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        sizedBox,
        Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          child: Text(
              widget.title==null?"加载中...":widget.title,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none
              )
          ),
        )
      ],
    );


    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: column,
        ),
      ),
    );


    WillPopScope willPopScope =  WillPopScope(
      onWillPop: () async => widget.canCancel,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: column,
          ),
        ),
      ),

    );

    return willPopScope;
  }

}