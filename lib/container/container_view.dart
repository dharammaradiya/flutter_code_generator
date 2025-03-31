import 'package:ai_code/container/container_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:get/get.dart';

class ContainerView extends StatefulWidget {
  const ContainerView({super.key});

  @override
  State<ContainerView> createState() => _ContainerViewState();
}

class _ContainerViewState extends State<ContainerView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("Container")),
      body: GetBuilder<ContainerController>(
        builder: (controller) {
          return Row(
            children: [
              // Live Preview
              Expanded(
                child: Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: controller.containerColor,
                      borderRadius: BorderRadius.circular(
                        controller.borderRadius,
                      ),
                      boxShadow:
                          controller.hasShadow
                              ? [
                                BoxShadow(
                                  color: controller.shadowColor,
                                  spreadRadius: controller.shadowSpreadRadius,
                                  blurRadius: controller.shadowBlurRadius,
                                  offset: Offset(
                                    controller.shadowOffsetX,
                                    controller.shadowOffsetY,
                                  ),
                                ),
                              ]
                              : [],
                    ),
                    child: const Center(
                      child: Text(
                        "Live Preview",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              // Settings Panel
              Container(
                width: 350,
                padding: const EdgeInsets.all(16),
                // margin: const EdgeInsets.all(16),
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
                        "Adjust Properties",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Class Name Input
                      const Text("Class Name"),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            controller.className =
                                value.isNotEmpty ? value : "MyCustomBox";
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter class name",
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Border Radius
                      const Text("Border Radius"),
                      Slider(
                        value: controller.borderRadius,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: controller.borderRadius.round().toString(),
                        onChanged: (value) {
                          controller.borderRadius = value;
                          controller.update();
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text("Container Color"),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controller.hexController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter Hex Code",
                            prefixText: "#",
                          ),
                          onChanged: (value) {
                            controller.updateColorFromHex(value.trim());
                          },
                        ),
                      ),

                      // Shadow Toggle
                      Row(
                        children: [
                          Checkbox(
                            value: controller.hasShadow,
                            onChanged: (value) {
                              controller.hasShadow = value!;
                              controller.update();
                            },
                          ),
                          const Text("Enable Shadow"),
                        ],
                      ),

                      if (controller.hasShadow) ...[
                        // Shadow Color Hex Input
                        const Text("Shadow Color"),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: controller.hexShadowController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Shadow Hex Code",
                              prefixText: "#",
                            ),
                            onChanged: (value) {
                              // try {
                              //   if (value.isNotEmpty) {
                              //     setState(() {
                              //       _shadowColor = Color(int.parse("0xFF${value.replaceAll("#", "")}"));
                              //     });
                              //   }
                              // } catch (e) {
                              //   // Handle invalid input
                              // }
                              controller.updateShadowColorFromHex(value.trim());
                            },
                          ),
                        ),

                        // Shadow Blur Radius
                        const Text("Shadow Blur Radius"),
                        Slider(
                          value: controller.shadowBlurRadius,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          onChanged: (value) {
                            controller.shadowBlurRadius = value;
                            controller.update();
                          },
                        ),

                        // Shadow Spread Radius
                        const Text("Shadow Spread Radius"),
                        Slider(
                          value: controller.shadowSpreadRadius,
                          min: 0,
                          max: 20,
                          divisions: 20,
                          onChanged: (value) {
                            controller.shadowSpreadRadius = value;
                            controller.update();
                          },
                        ),

                        // Shadow Offset X
                        const Text("Shadow Offset X"),
                        Slider(
                          value: controller.shadowOffsetX,
                          min: -20,
                          max: 20,
                          divisions: 40,
                          onChanged: (value) {
                            controller.shadowOffsetX = value;
                            controller.update();
                          },
                        ),

                        // Shadow Offset Y
                        const Text("Shadow Offset Y"),
                        Slider(
                          value: controller.shadowOffsetY,
                          min: -20,
                          max: 20,
                          divisions: 40,
                          onChanged: (value) {
                            controller.shadowOffsetY = value;
                            controller.update();
                          },
                        ),
                      ],

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
                            SizedBox(height: 10),
                            SizedBox(
                              height: 400,
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildCodeBox(
                                    controller.generateCode(),
                                  ), // Custom Widget Code
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
          // Copy Button
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied to clipboard!")),
              );
            },
          ),

          // Code Display
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
