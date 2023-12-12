import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_detail_entity.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'html_parser.dart';

class Html extends StatelessWidget {
  Html({
    Key key,
    @required this.data,
    this.padding,
    this.backgroundColor,
    this.defaultTextStyle = const TextStyle(color: Colors.black),
    this.onLinkTap,
    this.renderNewlines = false,
    this.avCommentaryDetailEntity,
  }) : super(key: key);

  final String data;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final TextStyle defaultTextStyle;
  final Function onLinkTap;
  final bool renderNewlines;


  AVCommentaryDetailEntity avCommentaryDetailEntity;


  Future<bool> onLikeButtonTappedDianZhan(bool isLiked) async {

    if(isLiked){
      await netManager.client.cancelLikeAVCommentary(avCommentaryDetailEntity.id,"avcomment","");
    }else{
      await netManager.client.sendLike(avCommentaryDetailEntity.id,"avcomment");
    }

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }


  Future<bool> onLikeButtonTappedShouChang(bool isLiked) async {
    if(isLiked){
       netManager.client.postCollect(avCommentaryDetailEntity.id,"avcomment",false);
    }else{
       netManager.client.postCollect(avCommentaryDetailEntity.id,"avcomment",true);
    }

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: padding,
      color: backgroundColor,
      width: width,
      child: DefaultTextStyle.merge(
        style: defaultTextStyle,
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: HtmlParser(
                width: width,
                onLinkTap: onLinkTap,
                renderNewlines: renderNewlines,
              ).parse(data),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text("阅读",style: TextStyle(fontSize: Dimens.pt16,color: Colors.black),),

                    SizedBox(width: Dimens.pt6,),

                    Text(avCommentaryDetailEntity.readCount.toString(),style: TextStyle(fontSize: Dimens.pt16,color: Colors.red),),
                  ],
                ),

                Row(
                  children: [
                    LikeButton(
                      size: 20,
                      likeCount: avCommentaryDetailEntity.likeCount,
                      isLiked: avCommentaryDetailEntity.isLike,
                      //key: _globalKey,
                      countBuilder: (int count, bool isLiked, String text) {
                        final ColorSwatch<int> color =
                        isLiked ? Colors.pinkAccent : Colors.grey;
                        Widget result;
                        if (count == 0) {
                          result = Text(
                            '0',
                            style: TextStyle(color: color),
                          );
                        } else
                          result = Text(
                            count >= 1000
                                ? (count / 1000.0).toStringAsFixed(1) + 'k'
                                : text,
                            style: TextStyle(color: color),
                          );
                        return result;
                      },

                      likeBuilder: (bool isLiked) {
                        if(!isLiked){
                          return SvgPicture.asset("assets/svg/dian_zhan_press.svg");
                        }else{
                          return SvgPicture.asset("assets/svg/dian_zhan_pressed.svg");
                        }
                      },

                      likeCountAnimationType: avCommentaryDetailEntity.likeCount < 1000
                          ? LikeCountAnimationType.part
                          : LikeCountAnimationType.none,
                      likeCountPadding: const EdgeInsets.only(left: 6),
                      onTap: onLikeButtonTappedDianZhan,
                    ),

                  ],
                ),

                Row(
                  children: [
                    LikeButton(
                      size: 20,
                      likeCount: avCommentaryDetailEntity.favoritesCount,
                      isLiked: avCommentaryDetailEntity.isFavorites,
                      //key: _globalKey,
                      countBuilder: (int count, bool isLiked, String text) {
                        final ColorSwatch<int> color =
                        isLiked ? Colors.pinkAccent : Colors.grey;
                        Widget result;
                        if (count == 0) {
                          result = Text(
                            '0',
                            style: TextStyle(color: color),
                          );
                        } else
                          result = Text(
                            count >= 1000
                                ? (count / 1000.0).toStringAsFixed(1) + 'k'
                                : text,
                            style: TextStyle(color: color),
                          );
                        return result;
                      },
                      likeCountAnimationType: avCommentaryDetailEntity.favoritesCount < 1000
                          ? LikeCountAnimationType.part
                          : LikeCountAnimationType.none,
                      likeCountPadding: const EdgeInsets.only(left: 6),
                      onTap: onLikeButtonTappedShouChang,
                    ),

                  ],
                ),
              ],
            ),

            SizedBox(
              height: Dimens.pt30,
            ),

            Image.asset("assets/images/avcommentary_bottom_logo.png",width: Dimens.pt134,height: Dimens.pt42,),
            SizedBox(
              height: Dimens.pt26,
            ),
          ],
        ),
      ),
    );
  }
}
