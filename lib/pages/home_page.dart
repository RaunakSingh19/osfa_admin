import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osfa_admin/controllor/home_controller.dart';
import 'package:osfa_admin/pages/add_product_page.dart';
import 'package:osfa_admin/pages/edit_product_page.dart';
// import 'package:osfa_admin/pages/sidebar.dart';
// import 'package:osfa_admin/theme/theme_controller.dart';

import '../themes/theme_provider.dart';
import '../widgets/sidebar.dart';

class HomePage extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController()); // Instantiate ThemeController

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Online Furniture Selling App'),
            centerTitle: true,
          ),
          drawer: Sidebar(),  // Add the sidebar drawer here
          body: ListView.builder(
            itemCount: ctrl.products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(ctrl.products[index].name ?? ''),
                subtitle: Text((ctrl.products[index].price ?? 0).toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Edit button
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Get.to(EditProductPage(product: ctrl.products[index]));
                        // Refresh product list after returning from EditProductPage
                        ctrl.fetchProducts();
                        ctrl.update();
                      },
                    ),
                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        ctrl.deleteProduct(ctrl.products[index].id ?? '');
                        try {
                          await ctrl.productCollection.doc(ctrl.products[index].id).delete();
                          ctrl.fetchProducts();
                          Get.snackbar('Success', 'Product deleted successfully', colorText: Colors.green);
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to delete product', colorText: Colors.red);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              ctrl.resetFormFields();
              await Get.to(const AddProductPage());
              ctrl.fetchProducts();  // Refresh product list after returning from AddProductPage
              ctrl.update();
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
