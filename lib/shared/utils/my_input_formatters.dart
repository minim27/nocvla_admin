import 'package:flutter/services.dart';

class NoLeadingZeroTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isNotEmpty && newValue.text.startsWith('0')) {
      return TextEditingValue(
        text: newValue.text.replaceFirst('0', ''),
        selection: newValue.selection.copyWith(
          baseOffset: newValue.selection.baseOffset - 1,
          extentOffset: newValue.selection.extentOffset - 1,
        ),
      );
    }
    return newValue;
  }
}

class No62TextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isNotEmpty && newValue.text.startsWith('62')) {
      return TextEditingValue(
        text: newValue.text.replaceFirst('62', ''),
        selection: newValue.selection.copyWith(
          baseOffset: newValue.selection.baseOffset - 1,
          extentOffset: newValue.selection.extentOffset - 1,
        ),
      );
    }
    return newValue;
  }
}
