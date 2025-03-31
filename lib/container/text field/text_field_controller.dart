import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    textColorController.text = getHexFromColor(textColor);
    borderColorController.text = getHexFromColor(borderColor);
  }

  String hintText = "Enter text...";
  double fontSize = 16.0;
  Color textColor = Colors.black;
  Color borderColor = Colors.grey;
  double borderRadius = 8.0;
  double borderWidth = 1.0;
  bool isFilled = false;
  Color fillColor = Colors.transparent;
  String className = "CustomTextField";

  final TextEditingController textColorController = TextEditingController();
  final TextEditingController borderColorController = TextEditingController();

  // Generates the full StatelessWidget code
  String generateCode() {
    return '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  final String hintText;
  final double fontSize;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final bool isFilled;
  final Color fillColor;

  const $className({
    super.key,
    this.hintText = "$hintText",
    this.fontSize = $fontSize,
    this.textColor = ${getColorString(textColor)},
    this.borderColor = ${getColorString(borderColor)},
    this.borderRadius = $borderRadius,
    this.borderWidth = $borderWidth,
    this.isFilled = $isFilled,
    this.fillColor = ${getColorString(fillColor)},
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: fontSize, color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        ),
        filled: isFilled,
        fillColor: fillColor,
      ),
    );
  }
}
''';
  }

  // Generates extension code
  String generateExtensionCode() {
    return '''
import 'package:flutter/material.dart';

extension CustomTextField on Widget {
  Widget applyCustomTextField({
    String hintText = "$hintText",
    double fontSize = $fontSize,
    Color textColor = ${getColorString(textColor)},
    Color borderColor = ${getColorString(borderColor)},
    double borderRadius = $borderRadius,
    double borderWidth = $borderWidth,
    bool isFilled = $isFilled,
    Color fillColor = ${getColorString(fillColor)},
  }) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: fontSize, color: textColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        ),
        filled: isFilled,
        fillColor: fillColor,
      ),
    );
  }
}
''';
  }

  String getColorString(Color color) {
    return "Color(0x${color.value.toRadixString(16).padLeft(8, '0')})";
  }

  String getHexFromColor(Color color) {
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }

  void updateTextColorFromHex(String hex) {
    try {
      if (hex.isNotEmpty) {
        textColor = Color(int.parse("0xFF${hex.replaceAll("#", "")}"));
        update();
      }
    } catch (e) {
      // Handle invalid hex input
    }
  }

  void updateBorderColorFromHex(String hex) {
    try {
      if (hex.isNotEmpty) {
        borderColor = Color(int.parse("0xFF${hex.replaceAll("#", "")}"));
        update();
      }
    } catch (e) {
      // Handle invalid hex input
    }
  }
}
