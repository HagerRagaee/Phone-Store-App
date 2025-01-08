import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_store/bussines_logic/Cubit/Service_Cubit/service_state.dart';
import 'package:phone_store/data/models/service_class.dart';
import 'package:phone_store/data/repository/service_repository.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit(this.repository) : super(ServiceLoading());

  List<ServiceRecord> services = [];
  final ServiceRepository repository;
  String phoneNumber = "";

  Future<void> addService(ServiceRecord service, BuildContext context) async {
    try {
      emit(ServiceLoading());
      await repository.addService(service, context);
      emit(ServiceSaved());
    } catch (error) {
      emit(ServiceFailure(error.toString()));
    }
  }

  String? getPhoneNumber(String id) {
    try {
      repository.getPhoneNumber(id).then((phone) => {
            emit(ServicePhone(id)),
            phoneNumber = phone!,
          });
      return phoneNumber;
    } catch (error) {
      emit(ServiceFailure(error.toString()));
      return null;
    }
  }

  List<ServiceRecord> getTodayServices() {
    try {
      repository.getTodayServices().then((services) => {
            emit(ServiceFetched(services)),
            this.services = services,
          });

      return services;
    } catch (error) {
      emit(ServiceFailure(error.toString()));
      return [];
    }
  }

  List<ServiceRecord> getServicesByDate(List<DateTime?> dates) {
    try {
      repository.getServicesByDate(dates).then((services) => {
            emit(ServiceFetched(services)),
            this.services = services,
          });

      return services;
    } catch (error) {
      emit(ServiceFailure(error.toString()));
      return [];
    }
  }

  Future<bool> removeService(String docId, BuildContext context) async {
    try {
      emit(ServiceDeleted(docId));
      return await repository.removeService(docId, context);
    } catch (error) {
      emit(ServiceFailure(error.toString()));
      return false;
    }
  }
}
