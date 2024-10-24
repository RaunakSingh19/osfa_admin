import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:osfa_admin/theme/theme_controller.dart';

import '../themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Obx(
              () => SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}
