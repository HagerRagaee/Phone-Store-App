import 'package:phone_store/data/models/service_class.dart';

abstract class ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceSaved extends ServiceState {}

class ServiceFailure extends ServiceState {
  final String errorMessage;
  ServiceFailure(this.errorMessage);
}

class ServiceFetched extends ServiceState {
  final List<ServiceRecord> Service;
  ServiceFetched(this.Service);
}

class ServiceDeleted extends ServiceState {
  final String saleId;
  ServiceDeleted(this.saleId);
}

class ServicePhone extends ServiceState {
  final String serviceId;
  ServicePhone(this.serviceId);
}
