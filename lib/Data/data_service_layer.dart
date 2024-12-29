// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:phone_store/Classes/service_class.dart';
// import 'package:phone_store/Classes/wallet_class.dart';
// import 'package:phone_store/Data/data_wallet_layer.dart';

// class DataServiceLayer {
//   static final FirebaseFirestore db = FirebaseFirestore.instance;
//   static const String collectionName = 'service';

//   static Future<void> addService(
//       ServiceRecord service, BuildContext context) async {
//     DocumentReference docRef =
//         await db.collection(collectionName).add(service.toJson());
//     String docId = docRef.id;
//     docRef.update({"docId": docId});
//   }

//   static Future<String?> getPhoneNumber(String id) async {
//     WalletData? walletData = await DataWalletLayer.getWalletById(id);
//     if (walletData != null) {
//       return walletData.phoneNumber;
//     }
//     print("No phone number");
//     return null;
//   }

//   static Future<List<ServiceRecord>> getTodayServices() async {
//     try {
//       DateTime now = DateTime.now();
//       DateTime startOfDay = DateTime(now.year, now.month, now.day);
//       DateTime endOfDay =
//           startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));

//       QuerySnapshot querySnapshot = await db
//           .collection("service")
//           .where('serviceDate',
//               isGreaterThanOrEqualTo: startOfDay.toIso8601String())
//           .where('serviceDate', isLessThanOrEqualTo: endOfDay.toIso8601String())
//           .get();

//       if (querySnapshot.docs.isEmpty) {
//         print("No sales records found for today.");
//       } else {
//         print("${querySnapshot.docs.length} service records retrieved.");
//       }

//       return querySnapshot.docs.map((doc) {
//         return ServiceRecord.fromJson(
//           doc.data() as Map<String, dynamic>,
//           docId: doc.id, // Pass the document ID
//         );
//       }).toList();
//     } catch (e) {
//       print("Error retrieving today's sales records: $e");
//       rethrow;
//     }
//   }

//   static Future<List<ServiceRecord>> getServicesByDate(
//       List<DateTime?> dates) async {
//     List<ServiceRecord> services = [];
//     try {
//       for (DateTime? date in dates) {
//         DateTime startOfDay = DateTime(date!.year, date.month, date.day);
//         DateTime endOfDay = startOfDay
//             .add(const Duration(days: 1))
//             .subtract(const Duration(milliseconds: 1));

//         QuerySnapshot querySnapshot = await db
//             .collection(collectionName)
//             .where("serviceDate",
//                 isGreaterThanOrEqualTo: startOfDay.toIso8601String())
//             .where("serviceDate",
//                 isLessThanOrEqualTo: endOfDay.toIso8601String())
//             .get();

//         if (querySnapshot.docs.isEmpty) {
//           print("No services found for date: $date");
//         }

//         services.addAll(querySnapshot.docs.map((doc) {
//           return ServiceRecord.fromJson(
//             doc.data() as Map<String, dynamic>,
//             docId: doc.id,
//           );
//         }).toList());
//       }
//       return services; // Return after processing all dates
//     } catch (e) {
//       print("Error retrieving services for the given dates: $e");
//       rethrow;
//     }
//   }

//   static Future<void> removeService(String docId, BuildContext context) async {
//     try {
//       DocumentSnapshot doc =
//           await db.collection(collectionName).doc(docId).get();

//       if (!doc.exists) {
//         print("Sale record with ID '$docId' does not exist.");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Document not found"),
//           ),
//         );
//         return;
//       }

//       ServiceRecord serviceRecord = ServiceRecord.fromJson(
//         doc.data() as Map<String, dynamic>,
//       );

//       DataWalletLayer.returnWalletAmount(
//         serviceRecord.phoneNumber,
//         serviceRecord.money,
//         serviceRecord.cost,
//         serviceRecord.serviceType,
//         context,
//       );

//       await db.collection(collectionName).doc(docId).delete();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("تم حذف السجل بنجاح"),
//         ),
//       );
//       print(
//           "Sale record with ID '$docId' deleted successfully and inventory updated.");
//     } catch (e) {
//       print("Error deleting sale record: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("فشل حذف السجل."),
//         ),
//       );
//       rethrow;
//     }
//   }
// }
