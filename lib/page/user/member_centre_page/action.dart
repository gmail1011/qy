import 'package:fish_redux/fish_redux.dart';

enum MemberCentreAction { submitRedemptionCode }

class MemberCentreActionCreator {
  static Action submitRedemptionCode(String code) {
    return Action(MemberCentreAction.submitRedemptionCode, payload: code);
  }
}
