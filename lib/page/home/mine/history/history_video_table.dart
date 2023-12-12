import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/home/mine/history/history_record_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../assets/lang.dart';
import '../../../../model/video_model.dart';

class HistoryVideoTable extends StatefulWidget {
  final bool isEdit;

  const HistoryVideoTable({this.isEdit = false}); // 0长视频 1短视频

  @override
  State<StatefulWidget> createState() {
    return HistoryVideoTableState();
  }
}

class HistoryVideoTableState extends State<HistoryVideoTable> {
  List<VideoModel> modelList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {
    modelList = await HistoryRecordUtil.getVideoModelList();
    setState(() {});
  }

  void deleteVideo(VideoModel model) async {
    modelList.remove(model);
    await HistoryRecordUtil.deleteVideo(model);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (modelList.isEmpty) {
      return Center(
        child: CErrorWidget(
          Lang.EMPTY_DATA,
          retryOnTap: () {
            _loadData();
          },
        ),
      );
    } else {
      return StaggeredGridView.countBuilder(
        controller: scrollController,
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: modelList.length,
        staggeredTileBuilder: (index){
          var item = modelList[index];
          var ratio = 168/130;
          return StaggeredTile.count(1, 1 / ratio);
        },
        itemBuilder: (context, index) {
          var item = modelList[index];
          return GestureDetector(
            onTap: () {
              pushToPage(FilmTvVideoDetailPage().buildPage({"videoModel":item}));
            },
            child: VideoCellWidget(
              videoModel: item,
              textLine: 1,
              isShowDeleteStatus: widget.isEdit,
              deleteCallback: (model) {
                deleteVideo(model);
              },
            ),
          );
        },
      );
    }
  }
}
