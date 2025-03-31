import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:get/get.dart';

import 'text_field_controller.dart';

class TextFieldView extends StatelessWidget {
  const TextFieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("TextField Customizer")),
      body: GetBuilder<TextFieldController>(
        builder: (controller) {
          return Row(
            children: [
              // Live Preview
              Expanded(
                child: Center(
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        controller.borderRadius,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 2,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: controller.hintText,
                        hintStyle: TextStyle(
                          fontSize: controller.fontSize,
                          color: controller.textColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.borderRadius,
                          ),
                          borderSide: BorderSide(
                            color: controller.borderColor,
                            width: controller.borderWidth,
                          ),
                        ),
                        filled: controller.isFilled,
                        fillColor: controller.fillColor,
                      ),
                      style: TextStyle(
                        fontSize: controller.fontSize,
                        color: controller.textColor,
                      ),
                    ),
                  ),
                ),
              ),

              // Customization Panel
              Container(
                width: 350,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Customize TextField",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Hint Text
                      const Text("Hint Text"),
                      TextField(
                        onChanged: (value) {
                          controller.hintText = value;
                          controller.update();
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter hint text",
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Font Size
                      const Text("Font Size"),
                      Slider(
                        value: controller.fontSize,
                        min: 10,
                        max: 30,
                        divisions: 20,
                        label: controller.fontSize.round().toString(),
                        onChanged: (value) {
                          controller.fontSize = value;
                          controller.update();
                        },
                      ),

                      // Text Color
                      const Text("Text Color (Hex)"),
                      TextField(
                        controller: controller.textColorController,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefix: Text("#"),
                          hintText: "Enter Hex Code",
                        ),
                        onChanged: controller.updateTextColorFromHex,
                      ),
                      const SizedBox(height: 10),

                      // Border Color
                      const Text("Border Color (Hex)"),
                      TextField(
                        controller: controller.borderColorController,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefix: Text("#"),
                          hintText: "Enter Hex Code",
                        ),
                        onChanged: controller.updateBorderColorFromHex,
                      ),
                      const SizedBox(height: 10),

                      // Border Radius
                      const Text("Border Radius"),
                      Slider(
                        value: controller.borderRadius,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        label: controller.borderRadius.round().toString(),
                        onChanged: (value) {
                          controller.borderRadius = value;
                          controller.update();
                        },
                      ),

                      // Border Width
                      const Text("Border Width"),
                      Slider(
                        value: controller.borderWidth,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: controller.borderWidth.toString(),
                        onChanged: (value) {
                          controller.borderWidth = value;
                          controller.update();
                        },
                      ),

                      // Fill Color Toggle
                      Row(
                        children: [
                          Checkbox(
                            value: controller.isFilled,
                            onChanged: (value) {
                              controller.isFilled = value!;
                              controller.update();
                            },
                          ),
                          const Text("Fill Background"),
                        ],
                      ),

                      // Generated Code Tabs
                      const SizedBox(height: 20),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            const TabBar(
                              tabs: [
                                Tab(text: "Custom Widget"),
                                Tab(text: "Extension"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildCodeBox(
                                    controller.generateCode(),
                                  ), // Widget Code
                                  _buildCodeBox(
                                    controller.generateExtensionCode(),
                                  ), // Extension Code
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCodeBox(String code) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              Get.snackbar(
                "Copied!",
                "Code copied to clipboard",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: HighlightView(
                code,
                language: 'dart',
                theme: monokaiSublimeTheme,
                padding: const EdgeInsets.all(12),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
