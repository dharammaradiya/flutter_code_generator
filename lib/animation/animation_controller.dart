import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class AnimationControllerX extends GetxController {
//   String className = "MyAnimatedWidget";
//   String selectedAnimation = "Fade";
//   double duration = 1.0;
//   Curve curve = Curves.easeInOut;

//   void updateAnimation(String newAnimation) {
//     selectedAnimation = newAnimation;
//     update();
//   }

//   void updateDuration(double newDuration) {
//     duration = newDuration;
//     update();
//   }

//   void updateCurve(Curve newCurve) {
//     curve = newCurve;
//     update();
//   }

//   String generateMainCode() {
//     return """
// import 'package:flutter/material.dart';
// import 'animation_extensions.dart';

// class $className extends StatefulWidget {
//   @override
//   _${className}State createState() => _${className}State();
// }

// class _${className}State extends State<$className> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: ${duration.toInt()}),
//     )..repeat(reverse: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: 100,
//           height: 100,
//           color: Colors.blue,
//         ).animated(
//           controller: _controller,
//           curve: ${curve.toString().split('.').last},
//           type: "$selectedAnimation",
//         ),
//       ),
//     );
//   }
// }
// """;
//   }

//   String generateExtensionsCode() {
//     return """
// import 'package:flutter/material.dart';

// extension WidgetAnimations on Widget {
//   Widget animated({
//     required AnimationController controller,
//     required Curve curve,
//     required String type,
//   }) {
//     Animation<double> animation;

//     switch (type) {
//       case 'Fade':
//         animation = Tween<double>(begin: 0.2, end: 1.0).animate(
//           CurvedAnimation(parent: controller, curve: curve),
//         );
//         return AnimatedBuilder(
//           animation: animation,
//           builder: (_, child) => Opacity(opacity: animation.value, child: child),
//           child: this,
//         );

//       case 'Scale':
//         animation = Tween<double>(begin: 0.5, end: 1.5).animate(
//           CurvedAnimation(parent: controller, curve: curve),
//         );
//         return AnimatedBuilder(
//           animation: animation,
//           builder: (_, child) => Transform.scale(scale: animation.value, child: child),
//           child: this,
//         );

//       case 'Rotate':
//         animation = Tween<double>(begin: 0, end: 2 * 3.14).animate(
//           CurvedAnimation(parent: controller, curve: curve),
//         );
//         return AnimatedBuilder(
//           animation: animation,
//           builder: (_, child) => Transform.rotate(angle: animation.value, child: child),
//           child: this,
//         );

//       case 'Slide':
//         animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
//           CurvedAnimation(parent: controller, curve: curve),
//         );
//         return AnimatedBuilder(
//           animation: animation,
//           builder: (_, child) => Transform.translate(offset: animation.value, child: child),
//           child: this,
//         );

//       default:
//         return this;
//     }
//   }
// }
// """;
//   }
// }

class AnimationControllerX extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  String selectedAnimation = 'Fade';
  double duration = 1.0;
  String className = "MyAnimatedWidget";

  Curve curve = Curves.easeInOut;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration.toInt()),
    )..repeat(reverse: true);

    _setAnimation();
  }

  void _setAnimation() {
    switch (selectedAnimation) {
      case 'Fade':
        animation = Tween<double>(
          begin: 0.2,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animationController, curve: curve));
        break;
      case 'Scale':
        animation = Tween<double>(
          begin: 0.5,
          end: 1.2,
        ).animate(CurvedAnimation(parent: animationController, curve: curve));
        break;
      case 'Rotate':
        animation = Tween<double>(
          begin: 0,
          end: 2 * 3.14,
        ).animate(CurvedAnimation(parent: animationController, curve: curve));
        break;
      case 'Slide':
        animation = Tween<double>(
          begin: -50,
          end: 50,
        ).animate(CurvedAnimation(parent: animationController, curve: curve));
        break;
    }
    update();
  }

  void updateAnimation(String newAnimation) {
    selectedAnimation = newAnimation;
    _setAnimation();
  }

  void updateDuration(double newDuration) {
    duration = newDuration;
    animationController.duration = Duration(seconds: duration.toInt());
    animationController.repeat(reverse: true);
    update();
  }

  Widget buildAnimatedWidget(Widget? child) {
    switch (selectedAnimation) {
      case 'Rotate':
        return Transform.rotate(angle: animation.value, child: child);
      case 'Scale':
        return Transform.scale(scale: animation.value, child: child);
      case 'Slide':
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      default:
        return Opacity(opacity: animation.value, child: child);
    }
  }

  String generateMainCode() {
    return """
import 'package:flutter/material.dart';
import 'animation_extensions.dart'; 

class $className extends StatefulWidget {
  @override
  _${className}State createState() => _${className}State();
}

class _${className}State extends State<$className> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: ${duration.toInt()}),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
        ).animated(
          controller: _controller,
          curve: ${curve.toString().split('.').last},
          type: "$selectedAnimation",
        ),
      ),
    );
  }
}
""";
  }

  String generateExtensionsCode() {
    return """
import 'package:flutter/material.dart';

extension WidgetAnimations on Widget {
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
        animation = Tween<double>(begin: 0.5, end: 1.5).animate(
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
        animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: controller, curve: curve),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Transform.translate(offset: animation.value, child: child),
          child: this,
        );

      default:
        return this;
    }
  }
}
""";
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
