import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';

enum BankCardListAction {
  action,
  back,
  onAddBankCard,
  onDeleteBankCard,
  onUpdateData,
  onRefreshList,
  updateUI,
  onItemBankClicked,
  validatedBankCard
}

class BankCardListActionCreator {
  static Action onAction() {
    return const Action(BankCardListAction.action);
  }

  static Action onBack() {
    return const Action(BankCardListAction.back);
  }

  static Action validatedBankCard() {
    return const Action(BankCardListAction.validatedBankCard);
  }

  static Action onAddBankCard() {
    return const Action(BankCardListAction.onAddBankCard);
  }

  static Action onDeleteBankCard(int index) {
    return Action(BankCardListAction.onDeleteBankCard, payload: index);
  }

  static Action onItemBankClicked(int index) {
    return Action(BankCardListAction.onItemBankClicked,payload: index);
  }

  static Action onUpdateData(ApBankListModel model) {
    return Action(BankCardListAction.onUpdateData, payload: model);
  }

  static Action onRefreshList() {
    return const Action(BankCardListAction.onRefreshList);
  }

  static Action updateUI() {
    return const Action(BankCardListAction.updateUI);
  }
}
