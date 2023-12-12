import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/bill_section_model.dart';

class SectionState implements Cloneable<SectionState> {
  ///uniqueId
  String uniqueId;
  BillSectionModel sectionModel;

  SectionState({this.sectionModel}) {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  SectionState clone() {
    return SectionState()
      ..sectionModel = sectionModel
      ..uniqueId = uniqueId;
  }
}

SectionState initState(Map<String, dynamic> args) {
  return SectionState();
}
