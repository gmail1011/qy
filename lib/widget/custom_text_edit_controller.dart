

import 'package:flutter/widgets.dart';

class TextEditingControllerWorkRound extends TextEditingController {
  TextEditingControllerWorkRound({String text}) : super(text: text);

  void setTextAndPosition(String newText, {int caretPosition}) {
    int offset = caretPosition != null ? caretPosition : newText.length;
    value = value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: offset));
  }
}