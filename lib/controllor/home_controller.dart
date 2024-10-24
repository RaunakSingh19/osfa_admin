import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osfa_admin/model/product/product.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference productCollection;

  final TextEditingController productNameCtrl = TextEditingController();
  final TextEditingController productDescriptionCtrl = TextEditingController();
  final TextEditingController productImgCtrl = TextEditingController();
  final TextEditingController productPriceCtrl = TextEditingController();

  String category = 'category';
  String brand = 'Unbranded';
  bool offer = false;

  final List<Product> products = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    productCollection = firestore.collection('product');
    await fetchProducts();
  }

  Future<void> addProduct() async {
    try {
      DocumentReference doc = productCollection.doc();
      Product newProduct = Product(
        id: doc.id,
        name: productNameCtrl.text.trim(),
        category: category,
        description: productDescriptionCtrl.text.trim(),
        price: double.tryParse(productPriceCtrl.text) ?? 0.0,
        brand: brand,
        image: productImgCtrl.text.trim(),
        offer: offer,
      );
      await doc.set(newProduct.toJson());
      resetFormFields();
      await fetchProducts();

    } catch (e) {
      Get.snackbar("Error", "Failed to add product: $e", colorText: Colors.red);
      print("Error adding product: $e");
    }
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await productCollection.get();
      products.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        double price = data['price'] is int
            ? (data['price'] as int).toDouble()
            : data['price'] as double;
        products.add(Product.fromJson({...data, 'price': price}));
      }
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch products: $e", colorText: Colors.red);
      print("Error fetching products: $e");
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      await fetchProducts();
      Get.snackbar("Success", "Product deleted successfully", colorText: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete product: $e", colorText: Colors.red);
      print("Error deleting product: $e");
    }
  }

  Future<void> updateProduct(String id) async {
    try {
      if (id.isNotEmpty) {
        final updatedData = {
          'name': productNameCtrl.text.trim(),
          'category': category,
          'description': productDescriptionCtrl.text.trim(),
          'price': double.tryParse(productPriceCtrl.text) ?? 0.0,
          'brand': brand,
          'image': productImgCtrl.text.trim(),
          'offer': offer,
        };
        await productCollection.doc(id).update(updatedData);
        Get.snackbar("Success", "Product updated successfully", colorText: Colors.green);
      } else {
        throw Exception("Product ID is empty.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update product: $e", colorText: Colors.red);
      print("Error updating product: $e");
    }
  }

  void resetFormFields() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productImgCtrl.clear();
    productPriceCtrl.clear();
    category = 'category';
    brand = 'Unbranded';
    offer = false;
    update();
  }

  @override
  void onClose() {
    productNameCtrl.dispose();
    productDescriptionCtrl.dispose();
    productImgCtrl.dispose();
    productPriceCtrl.dispose();
    super.onClose();
  }
}
