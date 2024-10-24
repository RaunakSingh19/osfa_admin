import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:osfa_admin/controllor/home_controller.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Your Products'),
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
                  'Add New Product',
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDropdown(
                      context: context,
                      items: ['Table', 'Chair', 'Bed', 'Desk', 'Cupboard', 'Sofa'],
                      selectedValue: ctrl.category,
                      hint: 'Select Category',
                      onChanged: (String? value) {
                        ctrl.category = value ?? 'general';
                        ctrl.update();
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildDropdown(
                      context: context,
                      items: ['IKEA', 'Unbranded', 'Nilkamal', 'WoodenStreet'],
                      selectedValue: ctrl.brand,
                      hint: 'Select Brand',
                      onChanged: (String? value) {
                        ctrl.brand = value ?? 'Unbranded';
                        ctrl.update();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Text('Is this product on offer?'),
                const SizedBox(height: 15),
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
                      await ctrl.addProduct();
                      Get.snackbar("Success", "Product added successfully", colorText: Colors.green);
                      Get.back(); // Go back after adding the product
                    } catch (e) {
                      Get.snackbar("Error", "Failed to add product: $e", colorText: Colors.red);
                      print("Error adding product: $e");
                    }
                  },
                  child: const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

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
