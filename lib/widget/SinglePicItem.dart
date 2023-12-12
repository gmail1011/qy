import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';


class SinglePicItem extends StatefulWidget{
  String imgUrl;
  bool isLocal;
  SinglePicItem(this.imgUrl,{this.isLocal = false,Key key}):super(key: key);
  @override
  State<StatefulWidget> createState() {

    return SinglePicItemState();
  }

}

class SinglePicItemState extends State<SinglePicItem>{

  File imgFile;

  @override
  void initState() {
    
    
//    if(widget.isLocal){
//      imgFile = File(widget.imgUrl);
//    }else{
//      ImageCacheManager().getSingleFile(widget.imgUrl).then((value){
//        imgFile = value;
//        setState(() {
//
//        });
//      });
//    }


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff333333),
      body: Center(
        child: CustomNetworkImage(
          imageUrl: widget.imgUrl,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

}