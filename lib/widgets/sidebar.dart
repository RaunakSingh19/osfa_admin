
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/settings_page.dart';
import '../pages/order_page.dart'; // Import the Order page
import '../themes/theme_provider.dart';

class Sidebar extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: themeController.isDarkMode ? Colors.grey.shade800 : Colors.deepPurple,
            ),
            child: const Text(
              'OFSA Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Home ListTile
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.back(); // Close the drawer
              Get.offNamed('/home'); // Navigate to Home Page
            },
          ),
          // Add Product ListTile
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Product'),
            onTap: () {
              Get.back(); // Close the drawer
              Get.toNamed('/addProduct'); // Navigate to Add Product Page
            },
          ),
          // Settings ListTile
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Get.back(); // Close the drawer
              Get.to(SettingsPage()); // Navigate to Settings Page
            },
          ),
          const Divider(),
          // Orders ListTile
          ListTile(
            leading: const Icon(Icons.receipt), // You can choose a more suitable icon
            title: const Text('Orders'),
            onTap: () {
              Get.back(); // Close the drawer
              Get.to(OrderPage()); // Navigate to Order Page
            },
          ),
        ],
      ),
    );
  }
}
