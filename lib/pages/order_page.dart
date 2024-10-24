import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({Key? key}) : super(key: key);

  // Function to delete an order by document ID
  Future<void> _deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
      print('Order deleted successfully');
    } catch (e) {
      print('Failed to delete order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          // Check if the data is loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if there is an error
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders'));
          }

          // Check if the snapshot has data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          // Get the list of orders from Firestore
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              // Fetch each order details
              var order = orders[index];
              var orderData = order.data() as Map<String, dynamic>;
              String orderId = order.id; // Get the document ID for deletion

              // Extracting data from the order
              String name = orderData['name'] ?? 'Unknown';
              String address = orderData['address'] ?? 'Unknown Address';
              String phoneNumber = orderData['phoneNumber'] ?? 'Unknown Phone';
              String city = orderData['city'] ?? 'Unknown City';
              String pin = orderData['pin'] ?? 'Unknown Pin';
              double totalAmount = orderData['totalAmount'] != null
                  ? orderData['totalAmount'].toDouble()
                  : 0.0;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.receipt),
                  title: Text('Order #${index + 1} - $name'),
                  subtitle: Text('Address: $address\nCity: $city, Pin: $pin\nPhone: $phoneNumber'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Order'),
                              content: const Text('Are you sure you want to delete this order?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _deleteOrder(orderId); // Delete the order
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // You can add navigation to a detailed order page here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
