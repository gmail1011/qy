import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/city/city_video/state.dart';
import 'package:flutter_app/page/home/post/post_item_component/component.dart';
import '../reducer.dart';

class CityIndexAdapter extends SourceFlowAdapter<CityVideoState> {
  CityIndexAdapter()
      : super(
          pool: <String, Component<Object>>{
            "cityItem": PostItemComponent(),
          },
          reducer:buildReducer(),
        );
}

