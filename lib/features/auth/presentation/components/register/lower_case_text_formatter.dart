import 'package:flutter/services.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  const LowerCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final lowerCaseText = newValue.text.toLowerCase();

    return newValue.copyWith(
      text: lowerCaseText,
      selection: TextSelection.collapsed(
        offset: lowerCaseText.length,
      ),
      composing: TextRange.empty,
    );
  }
}
