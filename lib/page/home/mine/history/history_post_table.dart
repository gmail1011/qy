import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../assets/lang.dart';
import '../../../../model/video_model.dart';
import 'history_record_util.dart';


class HistoryPostTable extends StatefulWidget {
  final bool isEdit;
  const HistoryPostTable({this.isEdit = false});

  @override
  State<StatefulWidget> createState() {
    return HistoryPostTableState();
  }
}

class HistoryPostTableState extends State<HistoryPostTable> with AutomaticKeepAliveClientMixin {
  RefreshController refreshController = RefreshController();
  List<VideoModel> modelList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async{
    modelList = await HistoryRecordUtil.getVideoModelList(type: 1);
    setState(() {});
  }

  void deleteVideo(VideoModel model) async {
    modelList.remove(model);
    await HistoryRecordUtil.deleteVideo(model, type: 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (modelList.isNotEmpty != true) {
      return Center(
        child: CErrorWidget(
          Lang.EMPTY_DATA,
          retryOnTap: () {
            _loadData();
          },
        ),
      );
    } else {
      return pullYsRefresh(
        enablePullUp: false,
        onRefresh: _loadData,
        refreshController: refreshController,
        child: ListView.builder(
          itemCount: modelList.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            var videoModel = modelList[index];
            return Stack(
              children: [
                WordImageWidgetForHjll(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 12),
                  videoModel: videoModel,
                  showTopInfo: false,
                  isHaiJiaoLLDetail: false,
                  isEdit: widget.isEdit,
                  deleteCallback: (model){
                    deleteVideo(model);
                  },
                ),

              ],
            );
          },
        ),
      );
    }
  }
}
