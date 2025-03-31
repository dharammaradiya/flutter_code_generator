import 'package:flutter/material.dart';

// Generic Animation Extension for Any Widget
extension AnimatedWidgetX on Widget {
  Widget animated({
    required AnimationController controller,
    required Curve curve,
    required String type,
  }) {
    Animation<double> animation;

    switch (type) {
      case 'Fade':
        animation = Tween<double>(begin: 0.2, end: 1.0).animate(
          CurvedAnimation(parent: controller, curve: curve),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Opacity(opacity: animation.value, child: child),
          child: this,
        );

      case 'Scale':
        animation = Tween<double>(begin: 0.5, end: 1.2).animate(
          CurvedAnimation(parent: controller, curve: curve),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Transform.scale(scale: animation.value, child: child),
          child: this,
        );

      case 'Rotate':
        animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(
          CurvedAnimation(parent: controller, curve: curve),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Transform.rotate(angle: animation.value, child: child),
          child: this,
        );

      case 'Slide':
        animation = Tween<double>(begin: -50, end: 50).animate(
          CurvedAnimation(parent: controller, curve: curve),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Transform.translate(offset: Offset(0, animation.value), child: child),
          child: this,
        );

      default:
        return this;
    }
  }
}