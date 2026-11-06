import 'package:flutter/services.dart';

class NoLeadingZeroTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > 1 && newValue.text.startsWith('0')) {
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
