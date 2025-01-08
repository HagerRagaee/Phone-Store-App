import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryInitial());
}
