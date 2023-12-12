import 'package:fish_redux/fish_redux.dart';

enum YuePaoReportAction { type, selectPic, updatePic, deleteItem, onReport }

class YuePaoReportActionCreator {

  static Action onTypeChange(int value){
    return Action(YuePaoReportAction.type, payload: value);
  }
  static Action onSelectPic(){
    return Action(YuePaoReportAction.selectPic);
  }
  static Action onUpdatePic(List<String> list){
    return Action(YuePaoReportAction.updatePic, payload: list);
  }
  static Action onDeleteItem(int index){
    return Action(YuePaoReportAction.deleteItem, payload: index);
  }

  static Action onReport(){
    return Action(YuePaoReportAction.onReport);
  }
  
}
