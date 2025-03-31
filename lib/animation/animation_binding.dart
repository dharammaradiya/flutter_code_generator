import 'package:ai_code/animation/animation_controller.dart';
import 'package:get/get.dart';

class AnimationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnimationControllerX>(() => AnimationControllerX());
  }
}
