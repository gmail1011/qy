import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';

enum AliListAction { onBack, onAddAliAccount, onUseAccount,onDeleteAccount, updateData,updateUI}

class AliListActionCreator {

  static Action onBack() {
    return const Action(AliListAction.onBack);
  }

  static Action onAddAliAccount() {
    return const Action(AliListAction.onAddAliAccount);
  }

  static Action onUseAccount(int index) {
    return Action(AliListAction.onUseAccount,payload: index);
  }

  static Action onDeleteAccount(int index) {
    return Action(AliListAction.onDeleteAccount,payload: index);
  }

  static Action onUpdateData(ApBankListModel model) {
    return Action(AliListAction.updateData, payload: model);
  }

  static Action updateUI() {
    return Action(AliListAction.updateUI,);
  }
  
}
