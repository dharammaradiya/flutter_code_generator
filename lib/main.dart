import 'package:ai_code/animation/animation_binding.dart';
import 'package:ai_code/animation/animation_view.dart';
import 'package:ai_code/container/container_binding.dart';
import 'package:ai_code/container/container_view.dart';
import 'package:ai_code/container/text%20field/text_field_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'container/text field/text_field_binding.dart';

void main() {
  runApp(const MyApp());
  ContainerBinding().dependencies(); // Initial binding
}

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final List<GetPage> screens = [
    GetPage(
      name: "/container",
      page: () => const ContainerView(),
      binding: ContainerBinding(),
    ),
    GetPage(
      name: "/animation",
      page: () => AnimationView(),
      binding: AnimationBinding(),
    ),
    GetPage(
      name: "/text_field",
      page: () => TextFieldView(),
      binding: TextFieldBinding(),
    ),
    GetPage(
      name: "/components",
      page: () => const ContentArea(title: "Components Page"),
    ),
  ];

  void switchScreen(int newIndex) {
    if (selectedIndex.value != newIndex) {
      // Dispose previous controller if needed
      screens[selectedIndex.value].binding?.dependencies();

      selectedIndex.value = newIndex;
      screens[newIndex].binding?.dependencies(); // Ensure correct binding
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebStyleNavigation(),
    );
  }
}

class WebStyleNavigation extends StatelessWidget {
  final NavigationController controller = Get.put(NavigationController());

  final List<String> menuItems = [
    "Container",
    "Animation",
    "Text Field",
    "Components",
  ];

  WebStyleNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarNavigation(menuItems: menuItems, controller: controller),
          Expanded(
            child: Obx(
              () => controller.screens[controller.selectedIndex.value].page(),
            ),
          ),
        ],
      ),
    );
  }
}

// Sidebar Widget
class SidebarNavigation extends StatelessWidget {
  final List<String> menuItems;
  final NavigationController controller;

  const SidebarNavigation({
    super.key,
    required this.menuItems,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.blueGrey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(menuItems.length, (index) {
          return Obx(
            () => InkWell(
              onTap: () => controller.switchScreen(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Text(
                  menuItems[index],
                  style: TextStyle(
                    color:
                        controller.selectedIndex.value == index
                            ? Colors.blue
                            : Colors.white,
                    fontSize: 16,
                    fontWeight:
                        controller.selectedIndex.value == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// Content Area Widget
class ContentArea extends StatelessWidget {
  final String title;

  const ContentArea({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title, style: const TextStyle(fontSize: 24)));
  }
}
