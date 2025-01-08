import 'package:flutter/material.dart';
import 'package:phone_store/data/firebase_data/data_service_layer.dart';
import 'package:phone_store/data/models/service_class.dart';

class ServiceRepository {
  final DataServiceLayer dataServiceLayer;

  ServiceRepository(this.dataServiceLayer);

  Future<void> addService(ServiceRecord service, BuildContext context) async {
    try {
      await dataServiceLayer.addService(service, context);
    } on Exception catch (e) {
      print('Error saving service record: $e');
    }
  }

  Future<String?> getPhoneNumber(String id) async {
    try {
      return await dataServiceLayer.getPhoneNumber(id);
    } on Exception catch (e) {
      print('Error getting phone number: $e');
      return null;
    }
  }

  Future<List<ServiceRecord>> getTodayServices() async {
    try {
      return await dataServiceLayer.getTodayServices();
    } on Exception catch (e) {
      print('Error getting phone number: $e');
      return [];
    }
  }

  Future<List<ServiceRecord>> getServicesByDate(List<DateTime?> dates) async {
    try {
      return await dataServiceLayer.getServicesByDate(dates);
    } on Exception catch (e) {
      print('Error getting services by date: $e');
      return [];
    }
  }

  Future<bool> removeService(String docId, BuildContext context) async {
    try {
      return await dataServiceLayer.removeService(docId, context);
    } on Exception catch (e) {
      print('Error removing service record: $e');
      return false;
    }
  }
}
