import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/comment/comment_list_page.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';

class CommunityDetailState implements Cloneable<CommunityDetailState> {
  List<AdsInfoBean> adsList = [];

  TextEditingController textEditingController =
      new TextEditingController(text: "");

  String videoId;

  VideoModel videoModel;
  int commentCellCount= 0;
  BaseRequestController requestController = BaseRequestController();

  String videoUrl;

  VideoPlayerController videoPlayerController;

  GlobalKey<CommentListState> commentKey = GlobalKey();

  bool alreadyShowDialog = false;

  RefreshController controller = RefreshController();

  ChewieController chewieController;

  ScrollController  scrollControllerOne = ScrollController();
  ScrollController  scrollControllerTwo = ScrollController();

  bool  needToBottom = false;

  bool autoPlay = false;
  String randomTag;


  LinearGradient linearGradient;

  @override
  CommunityDetailState clone() {
    return CommunityDetailState()
      ..adsList = adsList
      ..videoId = videoId
      ..videoModel = videoModel
      ..commentKey = commentKey
      ..controller = controller
      ..videoUrl =videoUrl
      ..chewieController = chewieController
      ..videoPlayerController = videoPlayerController
      ..scrollControllerOne = scrollControllerOne
      ..scrollControllerTwo = scrollControllerTwo
      ..needToBottom = needToBottom
      ..textEditingController = textEditingController
      ..randomTag = randomTag
      ..linearGradient = linearGradient
      ..requestController = requestController
      ..commentCellCount = commentCellCount
    ;
  }
}

CommunityDetailState initState(Map<String, dynamic> args) {

  return CommunityDetailState()..videoId = args["videoId"]
          ..needToBottom = args["needToBottom"]
          ..linearGradient = args["randomLinearGradient"]
           ..randomTag = args["randomTag"]
  ;
}
