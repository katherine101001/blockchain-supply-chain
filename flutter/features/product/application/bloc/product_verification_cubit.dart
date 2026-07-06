import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/trace_log.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_verification_state.dart';

class ProductVerificationCubit extends Cubit<ProductVerificationState> {
  ProductVerificationCubit(this._repository) : super(ProductVerificationInitial());

  final ProductRepository _repository;

  Future<void> verify(String sku) async {
    emit(ProductVerificationLoading());
    try {
      final traceLogs = await _repository.getTraceLogs(sku);
      final verified = traceLogs.any((log) => log.verified == true);
      emit(ProductVerificationLoaded(
        traceLogs: traceLogs,
        verified: verified,
      ));
    } catch (e) {
      emit(ProductVerificationError(e.toString()));
    }
  }

  void reset() {
    emit(ProductVerificationInitial());
  }
}

