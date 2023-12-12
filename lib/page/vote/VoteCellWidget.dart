import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/vote/Options.dart';
import 'package:flutter_app/model/vote/VoteItemModel.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

class VoteCellWidget extends StatefulWidget {
  VoteItemModel voteItemModel;
  List<String> selectOptionIds = [];
  VoidCallback buttonCallback;
  VoteCellWidget({Key key, this.voteItemModel,this.buttonCallback}) : super(key: key);

  @override
  State<VoteCellWidget> createState() => _VoteCellWidgetState();
}

class _VoteCellWidgetState extends State<VoteCellWidget> {
  @override
  Widget build(BuildContext context) {
    String result = DateTimeUtil.calTime(DateTimeUtil.utc2iso(widget.voteItemModel.endTime), DateTime.now());
    List<String> timeList = result.split("_");
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.voteItemModel.title,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),))
          ],
        ),
        SizedBox(height: 10,),
        ListView.builder(
          itemCount: widget.voteItemModel.options.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var voteCountAll = 0;
            Options  optionItem =  widget.voteItemModel.options[index];
            for( Options option in widget.voteItemModel.options){
              voteCountAll+=option.voteCount;
            }
            double percent = 0.0;
            if(voteCountAll>0){
              percent = double.parse((optionItem.voteCount/voteCountAll).toStringAsFixed(2));
            }
            return GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: _buildVoteItem(optionItem,percent,widget.voteItemModel),
                ),
                onTap: () async {
                  if( widget.voteItemModel.hasVoted??false){
                    //已经投过票
                    return;
                  }
                  Options clickOption =  widget.voteItemModel.options[index];
                    if(widget.voteItemModel.isMulCheck){ //多选
                      widget.voteItemModel.options.forEach((element) {
                        if(clickOption.id == element.id){
                          element.hasVoted = !(element.hasVoted??false);
                        }
                      });
                    }else{   //单选
                      widget.voteItemModel.options.forEach((element) {
                        if(clickOption.id != element.id){
                          element.hasVoted = false;
                        }else{
                          element.hasVoted = !(element.hasVoted??false);
                        }
                      });
                    }
                    setState(() {
                    });
                },
            );
          },
        ),
        Row(
          children: [
            Text("${widget.voteItemModel.voteCount}人参与",style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1),fontSize: 13),),
            SizedBox(width: 10,),
            Expanded(child: Text("还有${timeList[0]}天结束",style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1),fontSize: 13),),),
            widget.voteItemModel.hasVoted??false?SizedBox():GestureDetector(
              child: Container(
                width: 101,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(254, 127, 15, 1),
                      Color.fromRGBO(234, 139, 37, 1),
                    ]
                  )
                ),
                child: Text("投票",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 13),),
              ),
              onTap: () async {
                widget.voteItemModel.options.forEach((element) {
                  if(element.hasVoted??false){
                    widget.selectOptionIds.add(element.id);
                  }
                });
                if(widget.selectOptionIds.length==0){
                   showToast(msg: "还没现选择投票选项");
                   return;
                }
                try {
                  await netManager.client.voteSubmit(widget.selectOptionIds,widget.voteItemModel.id);
                  widget.selectOptionIds.clear();
                  setState(() {
                  });
                  showToast(msg: "投票成功！");
                  widget.buttonCallback?.call();
                } catch (e) {
                  widget.selectOptionIds.clear();
                  showToast(msg: "投票失败！");
                }
              },
            )
          ],
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}

Widget _buildVoteItem(Options options,double progress,VoteItemModel voteItemModel){
  return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        width: screen.screenWidth,
        height: 33,
        color: Color.fromRGBO(52, 52, 52, 0.5),
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            LinearProgressIndicator(
              backgroundColor:  Colors.transparent,
              value: (voteItemModel.showResult??false)?progress:0,
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(234, 139, 37, 1)),
              minHeight:33,
            ),
            Positioned(
                child: Container(
                  child: Row(
                    children: [
                      Text(options.option,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),
                      SizedBox(width: 20,),
                      (voteItemModel.showResult??false)?(progress==0?SizedBox():Text("${(progress*100).toStringAsFixed(2)}%",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 17))):SizedBox() ,
                    ],
                  ),
                ),
                left: 20,top: 0,bottom: 0
            ),
            ((voteItemModel.hasVoted??false)&& !(voteItemModel.showResult??false))?SizedBox():(((options.hasVoted??false))?Positioned(child: Image.asset("assets/weibo/vote_selected.png",width: 16,height: 16,),right: 5,top: 0,bottom: 0,):SizedBox()) ,
          ],
        ),
      ),
   );
}

