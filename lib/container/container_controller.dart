import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    hexController.text = getHexFromColor(containerColor);
    hexShadowController.text = getHexFromColor(shadowColor);
  }

  double borderRadius = 8.0;
  Color containerColor = Colors.blue;
  Color shadowColor = Colors.black;
  String className = "MyCustomBox";
  bool hasShadow = false;
  double shadowBlurRadius = 4.0;
  double shadowSpreadRadius = 2.0;
  double shadowOffsetX = 0.0;
  double shadowOffsetY = 2.0;

  final TextEditingController hexController = TextEditingController();
  final TextEditingController hexShadowController = TextEditingController();

  String generateCode() {
    return '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  final Color color;
  final double borderRadius;
  final bool hasShadow;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;
  final Color shadowColor;

  const $className({
    super.key,
    this.color = ${getColorString(containerColor)},
    this.borderRadius = $borderRadius,
    this.hasShadow = $hasShadow,
    this.shadowBlurRadius = $shadowBlurRadius,
    this.shadowSpreadRadius = $shadowSpreadRadius,
    this.shadowOffset = const Offset($shadowOffsetX , $shadowOffsetY),
    this.shadowColor = ${getColorString(shadowColor)},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: shadowBlurRadius,
                  spreadRadius: shadowSpreadRadius,
                  offset: shadowOffset,
                ),
              ]
            : [],
      ),
    );
  }
}
''';
  }

  String generateExtensionCode() {
    return '''
import 'package:flutter/material.dart';

extension CustomContainer on Widget {
  Container applyCustomStyle({
    Color color = ${getColorString(containerColor)},
    double borderRadius = $borderRadius,
    bool hasShadow = $hasShadow,
    double shadowBlurRadius = $shadowBlurRadius,
    double shadowSpreadRadius = $shadowSpreadRadius,
    Offset shadowOffset = const Offset($shadowOffsetX , $shadowOffsetY),
    Color shadowColor = ${getColorString(shadowColor)},
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: shadowBlurRadius,
                  spreadRadius: shadowSpreadRadius,
                  offset: shadowOffset,
                ),
              ]
            : [],
      ),
      child: this.child,
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

  void updateColorFromHex(String hex) {
    try {
      if (hex.isNotEmpty) {
        Color newColor = Color(int.parse("0xFF${hex.replaceAll("#", "")}"));

        containerColor = newColor;
        update();
      }
    } catch (e) {
      // Handle invalid hex input
    }
  }

  void updateShadowColorFromHex(String hex) {
    try {
      if (hex.isNotEmpty) {
        Color newColor = Color(int.parse("0xFF${hex.replaceAll("#", "")}"));

        shadowColor = newColor;
        update();
      }
    } catch (e) {
      // Handle invalid hex input
    }
  }
}
