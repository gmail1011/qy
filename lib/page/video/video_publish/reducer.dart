import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Reducer<VideoAndPicturePublishState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoAndPicturePublishState>>{
      VideoPublisherAction.refreshUI: _refreshUI,
      VideoPublisherAction.getTagListOkay: _getTagListOkay,
      VideoPublisherAction.setMoreTag: _setMoreTag,
      VideoPublisherAction.isSelectedCover: _isSelectedCover,
      VideoPublisherAction.setPostModule: _setPostModule,
      VideoPublisherAction.getCoin: getCoin,
      VideoPublisherAction.getImages: getImages,
      VideoPublisherAction.setLocation: setLocation,
      VideoPublisherAction.clearUi: clearUi,
      VideoPublisherAction.clearVideoCover: _clearVideoCover,
    },
  );
}


VideoAndPicturePublishState _clearVideoCover(
    VideoAndPicturePublishState state, Action action) {
  return state.clone()..videoCover = null;
}

VideoAndPicturePublishState _refreshUI(
    VideoAndPicturePublishState state, Action action) {
  return state.clone();
}

VideoAndPicturePublishState _getTagListOkay(
    VideoAndPicturePublishState state, Action action) {
  return state.clone()..tagList = action.payload;
}

VideoAndPicturePublishState _setMoreTag(
    VideoAndPicturePublishState state, Action action) {
  var newState = state.clone();
  newState.tagList = action.payload;
  newState.isMoreTag = true;
  return newState;
}

VideoAndPicturePublishState _isSelectedCover(
    VideoAndPicturePublishState state, Action action) {
  var newState = state.clone();
  newState.isSelectedCover = action.payload;
  return newState;
}

VideoAndPicturePublishState _setPostModule(VideoAndPicturePublishState state, Action action){
  var newState = state.clone();
  newState.postModuleModel = action.payload;
  return newState;
}


VideoAndPicturePublishState getCoin(
    VideoAndPicturePublishState state, Action action) {
  var newState = state.clone();
  newState.coin = action.payload;
  return newState;
}


VideoAndPicturePublishState getImages(
    VideoAndPicturePublishState state, Action action) {
  var newState = state.clone();
  newState.selectedImags = action.payload;
  return newState;
}

VideoAndPicturePublishState setLocation(
    VideoAndPicturePublishState state, Action action) {
  var newState = state.clone();
  newState.isSelectedCity = true;
  newState.locationCity = action.payload;
  return newState;
}


VideoAndPicturePublishState clearUi(
    VideoAndPicturePublishState state, Action action) {
  var newState = state.clone();
  newState.textController.clear();
  newState.uploadModel.localPicList.clear();
  newState.uploadModel.selectedTagIdList.clear();
  newState.coin = 0;
  newState.videoCover = null;
  newState.uploadModel.videoLocalPath = null;
  return newState;
}
