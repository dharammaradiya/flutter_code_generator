import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:get/get.dart';

import 'animation_controller.dart';

class AnimationView extends StatelessWidget {
  AnimationView({super.key});

  final AnimationControllerX controller = Get.put(AnimationControllerX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: const Text("Animation Generator")),
      body: GetBuilder<AnimationControllerX>(
        builder: (controller) {
          return Row(
            children: [
              // Live Preview
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: controller.animation,
                    builder: (context, child) {
                      return controller.buildAnimatedWidget(child);
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.blue,
                      child: const Center(
                        child: Text("Live Preview", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),

              // Settings Panel
              _buildSettingsPanel(controller, context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingsPanel(AnimationControllerX controller, BuildContext context) {
    return Container(
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
              "Adjust Properties",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Class Name Input
            _buildTextField("Class Name", controller.className, (value) {
              controller.className = value.isNotEmpty ? value : "MyAnimatedWidget";
              controller.update();
            }),

            // Animation Type Dropdown
            const Text("Animation Type"),
            DropdownButton<String>(
              value: controller.selectedAnimation,
              items:
                  [
                    'Fade',
                    'Scale',
                    'Rotate',
                    'Slide',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => controller.updateAnimation(value!),
            ),

            // Animation Duration Slider
            const Text("Animation Duration"),
            Slider(
              value: controller.duration,
              min: 0.5,
              max: 5,
              divisions: 9,
              label: "${controller.duration} sec",
              onChanged: (value) => controller.updateDuration(value),
            ),

            const SizedBox(height: 20),
            _buildCodeTabs(controller, context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Enter value"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCodeTabs(AnimationControllerX controller, BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs
      child: Column(
        children: [
          const TabBar(tabs: [Tab(text: "Main Code"), Tab(text: "Extensions Code")]),
          SizedBox(height: 10),
          SizedBox(
            height: 400,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCodeBox(controller.generateMainCode(), context),
                _buildCodeBox(controller.generateExtensionsCode(), context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBox(String code, BuildContext context) {
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Copied to clipboard!")));
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
                textStyle: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
