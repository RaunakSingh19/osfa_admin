// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AdminPage extends StatefulWidget {
//   @override
//   _AdminPageState createState() => _AdminPageState();
// }
//
// class _AdminPageState extends State<AdminPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Fetch users from Firestore
//   Stream<QuerySnapshot> _getUsersFromFirestore() {
//     return _firestore.collection('User').snapshots();
//   }
//
//   // Delete a user from Firebase Auth and Firestore
//   Future<void> _deleteUser(String userId) async {
//     try {
//       // Delete from Firestore
//       await _firestore.collection('User').doc(userId).delete();
//       // Delete from Firebase Auth
//       User? user = await _auth.currentUser;
//       await user?.delete();
//       setState(() {});
//     } catch (e) {
//       print('Error deleting user: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _getUsersFromFirestore(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No users found.'));
//           }
//
//           final users = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               final userDoc = users[index];
//               final userData = userDoc.data() as Map<String, dynamic>;
//
//               return ListTile(
//                 title: Text(userData['email'] ?? 'No email'),
//                 subtitle: Text('UID: ${userDoc.id}'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () async {
//                     await _deleteUser(userDoc.id);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
