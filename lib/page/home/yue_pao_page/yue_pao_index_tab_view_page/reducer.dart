import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/lou_feng_model.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoIndexTabViewState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoIndexTabViewState>>{
      YuePaoIndexTabViewAction.onChangeList: _onChangeList,
      YuePaoIndexTabViewAction.onChangePageNumber: _onChangePageNumber,
      YuePaoIndexTabViewAction.initPageNumber: _initPageNumber,
      YuePaoIndexTabViewAction.onChangeAD: _onChangeAD,
      YuePaoIndexTabViewAction.onChangeCity: _onChangeCity,
      YuePaoIndexTabViewAction.onChangeItem: _onChangeItem,
    },
  );
}

YuePaoIndexTabViewState _onChangeItem(YuePaoIndexTabViewState state, Action action) {
  LouFengItem louFengItem = action.payload;
  final YuePaoIndexTabViewState newState = state.clone();
  var list = newState.louFengList.map((item){
    if(item.id == louFengItem.id){
      return louFengItem;
    }
    return item;
  }).toList();
  newState.louFengList = list;
  return newState;
}

YuePaoIndexTabViewState _onChangeList(YuePaoIndexTabViewState state, Action action) {
  var map = action.payload;
  final YuePaoIndexTabViewState newState = state.clone();
  if(map['pageNumber'] == 1){
    newState.louFengList = map['list'];
  } else {
    if(newState.hasAD){
      newState.louFengList.addAll(map['list']);
    }else{
      newState.louFengList.insertAll(0,map['list']);
    }
  }
  return newState;
}

YuePaoIndexTabViewState _onChangeCity(YuePaoIndexTabViewState state, Action action) {
  final YuePaoIndexTabViewState newState = state.clone()
  ..city = action.payload??'';
  return newState;
}
YuePaoIndexTabViewState _onChangePageNumber(YuePaoIndexTabViewState state, Action action) {
  final YuePaoIndexTabViewState newState = state.clone()
  ..pageNumber +=1;
  return newState;
}

YuePaoIndexTabViewState _initPageNumber(YuePaoIndexTabViewState state, Action action) {
  final YuePaoIndexTabViewState newState = state.clone()
  ..pageNumber =1;
  return newState;
}

YuePaoIndexTabViewState _onChangeAD(YuePaoIndexTabViewState state, Action action) {
  final YuePaoIndexTabViewState newState = state.clone()
  ..hasAD = action.payload;
  return newState;
}
