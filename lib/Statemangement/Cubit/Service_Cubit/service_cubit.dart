import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/Classes/service_class.dart';
import 'package:phone_store/Classes/wallet_class.dart';
import 'package:phone_store/Data/data_wallet_layer.dart';
import 'package:phone_store/Statemangement/Cubit/Service_Cubit/service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(InitialServiceState());

  final FirebaseFirestore db = FirebaseFirestore.instance;
  String collectionName = 'service';
  List<ServiceRecord> services = [];

  Future<void> addService(ServiceRecord service, BuildContext context) async {
    emit(LoadingServiceState());
    try {
      DocumentReference docRef =
          await db.collection(collectionName).add(service.toJson());
      String docId = docRef.id;
      await docRef.update({"docId": docId});
      emit(SucessServiceState());
    } catch (e) {
      print("Error adding service: $e");
      emit(ErrorServiceState());
    }
  }

  Future<String?> getPhoneNumber(String id) async {
    emit(LoadingServiceState());
    try {
      WalletData? walletData = await DataWalletLayer.getWalletById(id);
      if (walletData != null) {
        emit(SucessServiceState());
        return walletData.phoneNumber;
      }
      print("No phone number found.");
      emit(ErrorServiceState());
      return null;
    } catch (e) {
      print("Error fetching phone number: $e");
      emit(ErrorServiceState());
      return null;
    }
  }

  Future<List<ServiceRecord>> getTodayServices() async {
    emit(LoadingServiceState());
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay =
          startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));

      QuerySnapshot querySnapshot = await db
          .collection("service")
          .where('serviceDate',
              isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('serviceDate', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No sales records found for today.");
      } else {
        print("${querySnapshot.docs.length} service records retrieved.");
      }
      emit(SucessServiceState());
      return querySnapshot.docs.map((doc) {
        return ServiceRecord.fromJson(
          doc.data() as Map<String, dynamic>,
          docId: doc.id, // Pass the document ID
        );
      }).toList();
    } catch (e) {
      print("Error retrieving today's sales records: $e");
      emit(ErrorServiceState());
      rethrow;
    }
  }

  Future<List<ServiceRecord>> getServicesByDate(List<DateTime?> dates) async {
    emit(LoadingServiceState());
    List<ServiceRecord> services = [];
    try {
      for (DateTime? date in dates) {
        DateTime startOfDay = DateTime(date!.year, date.month, date.day);
        DateTime endOfDay = startOfDay
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1));

        QuerySnapshot querySnapshot = await db
            .collection(collectionName)
            .where("serviceDate",
                isGreaterThanOrEqualTo: startOfDay.toIso8601String())
            .where("serviceDate",
                isLessThanOrEqualTo: endOfDay.toIso8601String())
            .get();

        if (querySnapshot.docs.isEmpty) {
          print("No services found for date: $date");
        }
        emit(SucessServiceState());
        services.addAll(querySnapshot.docs.map((doc) {
          return ServiceRecord.fromJson(
            doc.data() as Map<String, dynamic>,
            docId: doc.id,
          );
        }).toList());
      }
      return services; // Return after processing all dates
    } catch (e) {
      print("Error retrieving services for the given dates: $e");
      emit(ErrorServiceState());
      rethrow;
    }
  }

  Future<void> removeService(String docId, BuildContext context) async {
    emit(LoadingServiceState());
    try {
      DocumentSnapshot doc =
          await db.collection(collectionName).doc(docId).get();

      if (!doc.exists) {
        print("Sale record with ID '$docId' does not exist.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Document not found"),
          ),
        );
        return;
      }

      ServiceRecord serviceRecord = ServiceRecord.fromJson(
        doc.data() as Map<String, dynamic>,
      );
      emit(SucessServiceState());

      DataWalletLayer.returnWalletAmount(
        serviceRecord.phoneNumber,
        serviceRecord.money,
        serviceRecord.cost,
        serviceRecord.serviceType,
        context,
      );

      await db.collection(collectionName).doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف السجل بنجاح"),
        ),
      );
      print(
          "Sale record with ID '$docId' deleted successfully and inventory updated.");
    } catch (e) {
      print("Error deleting sale record: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل حذف السجل."),
        ),
      );
      emit(ErrorServiceState());
      rethrow;
    }
  }

  Future<void> fetchTodayService() async {
    emit(LoadingServiceState());
    try {
      final servicesFetched = await getTodayServices();
      services = servicesFetched;
      emit(SucessServiceState());
    } catch (e) {
      print('Error fetching items: $e');
      emit(ErrorServiceState());
    }
  }

  Future<void> fetchServicesForDates(List<DateTime?> dates) async {
    emit(LoadingServiceState());
    try {
      final servicesFetched = await getServicesByDate(dates);
      services = servicesFetched;
      emit(SucessServiceState());
    } catch (e) {
      print('Error fetching sales for selected dates: $e');
      emit(ErrorServiceState());
    }
  }
}
