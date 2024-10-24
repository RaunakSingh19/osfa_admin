import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osfa_admin/controllor/home_controller.dart';
import 'package:osfa_admin/model/product/product.dart';

class EditProductPage extends StatelessWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      // Pre-fill the controllers with the existing product data
      ctrl.productNameCtrl.text = product.name ?? '';
      ctrl.productDescriptionCtrl.text = product.description ?? '';
      ctrl.productImgCtrl.text = product.image ?? '';
      ctrl.productPriceCtrl.text = product.price?.toString() ?? '';
      
      // Ensuring default values are set properly
      ctrl.category = product.category ?? 'general';
      ctrl.brand = product.brand ?? 'Unbranded'; // Default to 'Unbranded'
      ctrl.offer = product.offer ?? false;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Edit Product',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: ctrl.productNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('Product Name'),
                    hintText: 'Enter Your Product Name',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: ctrl.productDescriptionCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('Product Description'),
                    hintText: 'Enter the Description of the Product',
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: ctrl.productImgCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('Image URL'),
                    hintText: 'Enter Your Image URL',
                  ),
                ),
                  const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final picker = ImagePicker();
                    try {
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        // For local file path
                        ctrl.productImgCtrl.text = pickedFile.path;
                      }
                    } catch (e) {
                      Get.snackbar("Error", "Failed to pick image: $e", colorText: Colors.red);
                      print("Error picking image: $e");
                    }
                  },
                  child: const Text('Pick Image from Gallery'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: ctrl.productPriceCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('Product Price'),
                    hintText: 'Enter Your Product Price',
                  ),
                ),
                const SizedBox(height: 15),

                // Column for dropdowns
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.stretch,
                //   children: [
                //     _buildDropdown(
                //       context: context,
                //       items: ['Table', 'Chair', 'Bed', 'Desk', 'Cupboard', 'Sofa'],
                //       selectedValue: ctrl.category,
                //       hint: 'Select Category',
                //       onChanged: (String? value) {
                //         ctrl.category = value ?? 'general';
                //         ctrl.update();
                //       },
                //     ),
                //     const SizedBox(height: 15),
                //     _buildDropdown(
                //       context: context,
                //       items: ['IKEA', 'Unbranded', 'Nilkamal', 'WoodenStreet'],
                //       selectedValue: ctrl.brand,
                //       hint: 'Select Brand',
                //       onChanged: (String? value) {
                //         ctrl.brand = value ?? 'Unbranded';
                //         ctrl.update();
                //       },
                //     ),
                //   ],
                // ),

                const SizedBox(height: 5),
                const Text('Is this product on offer?'),
                const SizedBox(height: 5),
                _buildDropdown(
                  context: context,
                  items: ['true', 'false'],
                  selectedValue: ctrl.offer.toString(),
                  hint: 'Is this product on offer?',
                  onChanged: (String? value) {
                    ctrl.offer = value == 'true';
                    ctrl.update();
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    try {
                      // Update the product in Firestore
                      await ctrl.updateProduct(product.id ?? '');
                      // Fetch the updated product list
                      await ctrl.fetchProducts();
                      // Update the UI and go back
                      Get.back();
                      // Show a success message
                      Get.snackbar("Success", "Product updated successfully", colorText: Colors.green);
                    } catch (e) {
                      // Show an error message in case of failure
                      Get.snackbar("Error", "Failed to update product: $e", colorText: Colors.red);
                      print("Error updating product: $e");
                    }
                  },
                  child: const Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Widget for building the dropdown menus
  Widget _buildDropdown({
    required BuildContext context,
    required List<String> items,
    required String selectedValue,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField2<String>(
      value: items.contains(selectedValue) ? selectedValue : null,
      items: items
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: hint,
      ),
      hint: Text(hint),
    );
  }
}
