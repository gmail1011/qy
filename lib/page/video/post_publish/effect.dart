import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'action.dart';
import 'state.dart';

Effect<PostPublishState> buildEffect() {
  return combineEffects(<Object, Effect<PostPublishState>>{
    PostPublishAction.onAddTag: _onAddTag,
    PostPublishAction.onCameraVideo:_onCameraVideo,
    PostPublishAction.onConfigCity:_onConfigCity,
    PostPublishAction.onConfigPrice:_onConfigPrice,
    PostPublishAction.onPublishPost:_onPublishPost,
    PostPublishAction.onInitTags:_onInitTags,
    PostPublishAction.onBack:_onBack,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<PostPublishState> ctx){
  
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _onInitTags(Action action, Context<PostPublishState> ctx) {

}

void _onAddTag(Action action, Context<PostPublishState> ctx) {

}

void _onCameraVideo(Action action, Context<PostPublishState> ctx) {

}

void _onConfigCity(Action action, Context<PostPublishState> ctx) {

}

void _onConfigPrice(Action action, Context<PostPublishState> ctx) {

}

void _onPublishPost(Action action, Context<PostPublishState> ctx) {

}

void _onBack(Action action, Context<PostPublishState> ctx) {

}
