
import 'package:ai_code/container/text%20field/text_field_controller.dart';
import 'package:get/get.dart';

class TextFieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TextFieldController>(() => TextFieldController());
  }
}
