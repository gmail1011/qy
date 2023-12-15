import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/global_store/store.dart';


class ChatItemCell extends StatefulWidget {
  final dynamic model;

   ChatItemCell({Key key, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatItemCellState();
  }
}

class _ChatItemCellState extends State<ChatItemCell> {
  bool get isImg => widget.model?.imgContent?.isNotEmpty == true;

  bool get isMe => GlobalStore.isMe(widget.model?.uid);

  @override
  void initState() {
    super.initState();
  }

  void _showImageScan(String imageUrl) {
    if(imageUrl.isNotEmpty) {
      showDialog(
        context: context,
          barrierDismissible:false,
        builder: (context) {
          return GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Center(
              child: CustomNetworkImageNew(
                imageUrl: imageUrl,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return _buildRightStyle();
    } else {
      return _buildLeftStyle();
    }
  }

  Widget _buildLeftStyle() {
    return Container(
      padding:  EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        children: [
          _buildTime(),
          Container(
            padding:  EdgeInsets.fromLTRB(16, 0, 50, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImageNew(
                  imageUrl: widget.model?.avatar ?? "",
                  width: 40,
                  height: 40,
                  radius: 20,
                ),
                 SizedBox(width: 12),
                Flexible(
                    child:Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.model?.nickName ?? "", style:  TextStyle(
                          color: Color(0xff262424),
                          fontSize: 14,
                        ),),
                         SizedBox(height: 10),
                        if (isImg)
                          InkWell(
                            onTap: () {
                              _showImageScan(widget.model?.imgContent ?? "");
                            },
                            child: CustomNetworkImageNew(
                              imageUrl: widget.model?.imgContent ?? "",
                              width: 173,
                              height: 96,
                            ),
                          )
                        else
                          Container(
                            padding:  EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration:  BoxDecoration(
                              color: Color(0xff333333),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              widget.model?.content ?? "",
                              style:  TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightStyle() {
    return Container(
      padding:  EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: Column(
        children: [
          _buildTime(),
          Container(
            padding:  EdgeInsets.fromLTRB(50, 0, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.model?.nickName ?? "", style:  TextStyle(
                          color: Color(0xff262424),
                          fontSize: 14,
                        ),),
                         SizedBox(height: 10),
                        if (isImg)
                          InkWell(
                            onTap: () {
                              _showImageScan(widget.model?.imgContent ?? "");
                            },
                            child: CustomNetworkImageNew(
                              key: ValueKey(widget.model?.imgContent),
                              imageUrl: widget.model?.imgContent ?? "",
                              width: 173,
                              height: 96,
                            ),
                          )
                        else
                          Container(
                            padding:  EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTextColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              widget.model?.content ?? "",
                              style:  TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                ),

                 SizedBox(width: 12),
                CustomNetworkImageNew(
                  imageUrl: widget.model?.avatar,
                  width: 40,
                  height: 40,
                  radius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    if (widget.model?.isShowTime == true) {
      return Container(
        margin:  EdgeInsets.fromLTRB(0, 12, 0, 24),
        padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:  Color(0xfff7f7f7).withOpacity(0.42),
        ),
        child: Text(
          widget.model?.createAtDesc ?? "",
          style:  TextStyle(
            color: Color(0xff999393),
            fontSize: 12,
          ),
        ),
      );
    }
    return  SizedBox();
  }
}
