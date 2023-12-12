import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/publish_tag_model.dart';
import 'package:flutter_app/model/search/PostModuleModel.dart';
import 'package:flutter_app/page/video/video_publish/select_tags/SelecteTagsPage.dart';
import 'package:flutter_app/page/video/video_publish/select_tags/select_tags_view.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';

enum VideoPublisherAction {
  onSelectCity,
  onShowSetPriceDialog,
  getTagListOkay,
  onDeleteItem,
  onDeleteVideoPic,
  onUploadVideo,
  refreshUI,
  onUploadPicture,
  onUploadPictureAndText,
  onPickPicAndVideo,
  onSelectCover,
  loadMoreTag,
  setMoreTag,
  onPop,
  isSelectedCover,
  setPostModule,
  getCoin,
  getImages,
  setLocation,
  clearUi,
  clearVideoCover,
}

class VideoPublishActionCreator {
  static Action loadMoreTag() {
    return Action(VideoPublisherAction.loadMoreTag);
  }

  static Action onSelectCity() {
    return Action(VideoPublisherAction.onSelectCity);
  }

  static Action onDeleteItem(int index) {
    return Action(VideoPublisherAction.onDeleteItem, payload: index);
  }

  static Action onShowSetPriceDialog() {
    return Action(VideoPublisherAction.onShowSetPriceDialog);
  }

  static Action getTagListOkay(List<PublishTag> tagList) {
    return Action(VideoPublisherAction.getTagListOkay, payload: tagList);
  }

  static Action setMoreTag(List<PublishTag> tagList) {
    return Action(VideoPublisherAction.setMoreTag, payload: tagList);
  }

  static Action onUploadVideo(String taskId) {
    return Action(VideoPublisherAction.onUploadVideo, payload: taskId);
  }

  static Action refreshUI() {
    return Action(VideoPublisherAction.refreshUI);
  }

  static Action onUploadPicture(String taskId) {
    return Action(VideoPublisherAction.onUploadPicture, payload: taskId);
  }
  static Action onUploadPictureAndText(String taskId) {
    return Action(VideoPublisherAction.onUploadPictureAndText, payload: taskId);
  }

  static Action onSelectPicAndVideo() {
    return Action(VideoPublisherAction.onPickPicAndVideo);
  }

  static Action onSelectCover() {
    return Action(VideoPublisherAction.onSelectCover);
  }

  static Action onPop() {
    return Action(VideoPublisherAction.onPop);
  }

  static Action isSelectedCover(bool isSelectedCover) {
    return Action(VideoPublisherAction.isSelectedCover, payload: isSelectedCover);
  }

  static Action setPostModule(PostModuleModel postModuleModel) {
    return Action(VideoPublisherAction.setPostModule, payload: postModuleModel);
  }

  static Action getCoin(int coin) {
    return Action(VideoPublisherAction.getCoin, payload: coin);
  }

  static Action getImages(int coin) {
    return Action(VideoPublisherAction.getImages, payload: coin);
  }

  static Action setLocation(String city) {
    return Action(VideoPublisherAction.setLocation, payload: city);
  }

  static Action clearUi() {
    return Action(VideoPublisherAction.clearUi);
  }

  static Action onClearVideoCover() {
    return Action(VideoPublisherAction.clearVideoCover);
  }
  static Action onDeleteVideoPicture(int index){
    return Action(VideoPublisherAction.onDeleteVideoPic,payload: index);
  }
}
